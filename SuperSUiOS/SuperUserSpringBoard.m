#import "SuperUserSpringBoard.h"

@implementation SuperUserSpringBoard

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    alertView.context = @(buttonIndex);
}

- (NSDictionary *)didReceiveNotification:(NSString *)name withUserInfo:(NSDictionary *)userInfo {
    if (name && userInfo) {
        uid_t newID = [(NSNumber *)userInfo[kID] intValue];
        short newIDType = [(NSNumber *)userInfo[kIDType] shortValue];
        NSString *IDDescription = [NSString stringWithFormat:@"%i", newID];
        if (newIDType == IDTypeGroupID) {
            struct group *idinfo = getgrgid(newID);
            if (idinfo && idinfo->gr_name)
                IDDescription = [IDDescription stringByAppendingFormat:@" (%s)", idinfo->gr_name];
        }
        else {
            struct passwd *idinfo = getpwuid(newID);
            if (idinfo && idinfo->pw_name)
                IDDescription = [IDDescription stringByAppendingFormat:@" (%s)", idinfo->pw_name];
        }
        NSString *reason = [NSString stringWithFormat:@"Allow \"%@\" to set its %@ to %@?",
            userInfo[kUserFriendlyName],
            [SuperUserIDType localizedDescriptionForIDType:newIDType],
            IDDescription
        ];
        NSLog(@"Handling notification \"%@\" with user info: %@", name, userInfo);   
        UIAlertView *alert = [[NSClassFromString(@"UIAlertView") alloc]
            initWithTitle:reason
            message:LocalizedString(@"This will be used by the app to either gain or drop priveleges.")
            delegate:self
            cancelButtonTitle:LocalizedString(@"Don't Allow")
            otherButtonTitles:
                LocalizedString(@"Allow"),
            nil
        ];
        [alert show];
        NSLog(@"Alert shown.");
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        while(!alert.context) {
            [runLoop runMode:NSDefaultRunLoopMode beforeDate:[NSDate date]];
        }
        if ([(NSNumber *)alert.context boolValue]) {
            return @{ kSuccess : @(YES) };
        }
    }
    else {
        NSLog(@"Dismissing notification: %@", name);
    }
    return @{ kSuccess : @(NO) };
}

+ (NSString * _Nonnull)requestMessage {
    return @"authentication.request";
}

- (void)registerObservers {
    NSLog(@"Registering observers for notification center: %@", _notifCenter);
    rocketbootstrap_distributedmessagingcenter_apply([_notifCenter retain]);
    NSLog(@"RocketBootstrap applied.");
    [_notifCenter runServerOnCurrentThread];
    NSLog(@"Server started running on main thread.");
    [_notifCenter registerForMessageName:SuperUserSpringBoard.requestMessage target:self selector:@selector(didReceiveNotification:withUserInfo:)];
    NSLog(@"Registered request message.");
}

- (_Nullable instancetype)init {
    return nil;
}

- (_Nullable instancetype)initWithNotificationCenter:(CPDistributedMessagingCenter * _Nonnull)center {
    [super init];
    if (!center) return nil;
    _notifCenter = [center retain];
    if (!_notifCenter) return nil;
    return self;
}

@end