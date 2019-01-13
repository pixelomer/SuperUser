#import "SuperUserClient.h"
#import "../Extensions/Extensions.h"

@implementation SuperUserClient

- (void)didReceiveNotification:(NSString *)name fromCenter:(CFNotificationCenterRef)center {
    NSLog(@"Received reply notification with name: %@", name);
    NSString *nameWithoutSuffix = [name substringToIndex:([name length] - 1)];
    NSLog(@"Raw notification name: %@", nameWithoutSuffix);
    NSArray *IDs = [ongoingRequests objectForKey:nameWithoutSuffix];
    NSLog(@"Notification IDs: %@", IDs);
    if (IDs)
    {
        [_darwinNotifCenter removeObserverNamed:[nameWithoutSuffix stringByAppendingString:@"S"]];
        [_darwinNotifCenter removeObserverNamed:[nameWithoutSuffix stringByAppendingString:@"F"]];
        [ongoingRequests removeObjectForKey:nameWithoutSuffix];
        if ([name hasSuffix:@"S"]) {
            IDType type = [IDs[0] shortValue];
            NSLog(@"Authentication was successful. Performing operations. Current ID: %i", [SuperUserIDType IDForIDType:type]);
            [SuperUserIDType setID:[IDs[1] intValue] forType:type];
            NSLog(@"New ID: %i", [SuperUserIDType IDForIDType:type]);
        }
    }
}

+ (NSString * _Nonnull)replyMessage {
    return NOTIFICATION_CENTER_NAME@"/authentication.reply";
}

- (_Nullable instancetype)init {
    return nil;
}

- (_Nullable instancetype)initWithNotificationCenter:(CPDistributedMessagingCenter * _Nonnull)center {
    [super init];
    if (!center) return nil;
    _notifCenter = [center retain];
    _darwinNotifCenter = [[DarwinNotificationCenter notificationCenterWithDelegate:self] retain];
    ongoingRequests = [[NSMutableDictionary alloc] init];
    if (!_notifCenter || !_darwinNotifCenter || !ongoingRequests) return nil;
    return self;
}

- (void)startServer {
    // Does nothing
}

- (bool)authenticateWithIDType:(IDType)type ID:(uid_t)ID {
    NSLog(@"Client wants to set its %@ to %i", [SuperUserIDType localizedDescriptionForIDType:type], type);
    NSMutableDictionary *userInfo = [@{
        kProcessName : NSProcessInfo.processInfo.processName,
        kID : @(ID),
        kIDType : @(type)
    } mutableCopy];
    if (NSBundle.mainBundle) {
        if (NSBundle.mainBundle.userFriendlyName)
            [userInfo setObject:NSBundle.mainBundle.userFriendlyName forKey:kUserFriendlyName];
        if (NSBundle.mainBundle.bundleIdentifier)
            [userInfo setObject:NSBundle.mainBundle.bundleIdentifier forKey:kBundleID];
    }
    NSString *observerName = @"";
    do {
        observerName = [NSString stringWithFormat:@"%@/%@/%@",
            SuperUserClient.replyMessage,
            userInfo[kBundleID] ?: userInfo[kProcessName],
            [@(arc4random()) stringValue]
        ];
    } while ([ongoingRequests objectForKey:observerName] != NULL);
    [ongoingRequests setObject:[@[
        @(type),
        @(ID)
    ] retain] forKey:observerName];
    [userInfo setObject:observerName forKey:kObserverName];
    [_darwinNotifCenter addObserverWithName:[observerName stringByAppendingString:@"F"]];
    [_darwinNotifCenter addObserverWithName:[observerName stringByAppendingString:@"S"]];
    [_notifCenter sendMessageName:SuperUserSpringBoard.requestMessage userInfo:[userInfo copy]];
    [userInfo release];
    return true;
}

@end