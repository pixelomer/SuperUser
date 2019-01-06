#import "SuperUserObserver.h"

// SpringBoard
@implementation SuperUserObserver

+ (NSString *)localizedDescriptionForIDType:(unsigned short)type {
    if (type == IDTypeEffectiveUserID) return LocalizedString(@"effective user ID");
    else if (type == IDTypeUserID) return LocalizedString(@"user ID");
    else if (type == IDTypeGroupID) return LocalizedString(@"group ID");
    else return LocalizedString(@"unknown ID");
}

- (void)registerAsObserver {
    NSLog(@"Registering SpringBoard observer...");
    //[notifCenter addObserver:self selector:@selector(appWantsToAuthenticate:) name:kAuthenticationRequest object:nil suspensionBehavior:CFNotificationSuspensionBehaviorDeliverImmediately];
    [_center runServerOnCurrentThread];
    [_center registerForMessageName:kAuthenticationRequest target:self selector:@selector(appWantsToAuthenticate:withUserInfo:)];
}

- (instancetype)initWithPolicy:(LAPolicy)policy {
    [super init];
    self.policy = policy;
    _center = [CPDistributedMessagingCenter centerNamed:kAuthenticationCenter];
    rocketbootstrap_distributedmessagingcenter_apply(_center);
    return self;
}

- (void)getPermissionFromUserWithAppName:(NSString *)appName
    andID:(uid_t)newID
    withIDType:(unsigned short)idType
    andRequestID:(NSString *)reqID
{
    NSString *requestID = [reqID copy];
    NSString *applicationName = [appName copy];
    NSLog(@"-[getPermissionFromUserWithAppName:\"%@\" andID:%i withIDType:%i andRequestID:%@]", appName, newID, idType, reqID);
    struct passwd *uinfo = (idType == IDTypeGroupID) ? NULL : getpwuid(newID);
    NSString *idDescription = (uinfo != NULL && uinfo->pw_name != NULL) ?
        [NSString stringWithFormat:@"%s (%i)", uinfo->pw_name, newID] :
        [NSString stringWithFormat:@"%i", newID];
    NSString *reason = [NSString stringWithFormat:
        LocalizedString(@"%@ wants to set %@ to %@."),
        applicationName, [SuperUserObserver localizedDescriptionForIDType:idType], idDescription];
    /*
    void (^buttonAction)(UIAlertAction * action) = ^(UIAlertAction * action){
        dispatch_sync(dispatch_get_main_queue(), ^{
            [_center sendMessageName:[kAuthenticationReply stringByAppendingFormat:@".%@", requestID] 
                userInfo:@{
                    kHasAuthenticated : ([action.title isEqualToString:@"OK"] ? @YES : @NO)
                }
            ];
        });
    };
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:reason message:@"SuperUser" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:buttonAction]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:buttonAction]];
    */
    __unused UIAlertView *dAlert = [[NSClassFromString(@"UIAlertView") alloc] initWithTitle:@"SuperUser" message:reason delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [_center sendMessageName:[kAuthenticationReply stringByAppendingFormat:@".%@", requestID] 
        userInfo:@{
            kHasAuthenticated : @YES,
            kID : @(newID),
            kIDType : @(idType)
        }
    ];
}

- (void)appWantsToAuthenticate:(id)v1 withUserInfo:(NSDictionary *)userInfo {
    @autoreleasepool {
        NSLog(@"SpringBoard was notified! v1: %@", v1);
        NSString *appName = userInfo[kAppName];
        uid_t newID = [(NSNumber*)userInfo[kID] intValue];
        short idType = [(NSNumber*)userInfo[kIDType] shortValue];
        NSString *reqID = userInfo[kRequestID];
        if ([appName isEqualToString:@"(unknown)"])
            appName = LocalizedString(appName);
        NSLog(@"%@ wants to authenticate to get ID %i for ID type %i", appName, newID, idType);
        NSLog(@"Request ID: %@", reqID);
        [self getPermissionFromUserWithAppName:[appName copy]
            andID:newID
            withIDType:idType
            andRequestID:[reqID copy]
        ];
    }
}

@end

// Other apps
@implementation SuperUser

- (instancetype)init {
    [super init];
    notifCenter = [CPDistributedMessagingCenter centerNamed:kAuthenticationCenter];
    rocketbootstrap_distributedmessagingcenter_apply(notifCenter);
    return self;
}

// Never called
- (void)authenticationReplyReceived:(NSString *)messageName userInfo:(NSDictionary *)userInfo {
    NSLog(@"-[SuperUser authenticationReplyReceiver:\"%@\" userInfo:%@]", messageName, userInfo);
    authenticationStatus = userInfo[kHasAuthenticated];
    bool authSuccess = [authenticationStatus boolValue];
    if (authSuccess) {
        [self setID:[(NSNumber*)[userInfo objectForKey:kIDType] shortValue] to:[(NSNumber*)[userInfo objectForKey:kID] intValue]];
    }
    [notifCenter unregisterForMessageName:messageName];
}

- (void)setID:(short)type to:(uid_t)ID {
    NSLog(@"-[SuperUser setID:%i to:%i]", type, ID);
    if (type == IDTypeEffectiveUserID) seteuid(ID);
    else if (type == IDTypeGroupID) setgid(ID);
    else if (type == IDTypeUserID) setuid(ID);
}

- (bool)authenticateWithIDType:(short)idType ID:(uid_t)newID {
    NSString *requestID = [@(arc4random()) stringValue];
    NSString *messageName = [kAuthenticationReply stringByAppendingFormat:@".%@", requestID];
    [notifCenter registerForMessageName:messageName target:self selector:@selector(authenticationReplyReceived:)];
    NSLog(@"Notifying SpringBoard about changing the ID of type %i to %i (Request ID: #%@)...", idType, newID, requestID);
    NSString *appName = @"(unknown)";
    if (mainBundle && [mainBundle isKindOfClass:[NSBundle class]])
        appName = [[mainBundle localizedInfoDictionary] objectForKey:@"CFBundleDisplayName"] ?: 
            ([[mainBundle infoDictionary] objectForKey:@"CFBundleExecutable"] ?: appName);
    NSDictionary *requestObject = @{
        kAppName : appName,
        kProcessName : NSProcessInfo.processInfo.processName,
        kID : @(newID),
        kIDType : @(idType),
        kRequestID : requestID
    };
    [notifCenter sendMessageName:kAuthenticationRequest userInfo:requestObject];
    NSLog(@"Authentication request completed with object: \"%@\"", requestObject);
    while (!authenticationStatus); // Block the main thread until the alert view is answered
    [notifCenter unregisterForMessageName:messageName];
    bool authSuccess = [authenticationStatus boolValue];
    [authenticationStatus release];
    authenticationStatus = NULL;
    return authSuccess;
}

@end