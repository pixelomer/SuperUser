#import "SuperUserSpringBoard.h"
#define NOTIF_RECEIVED_SEL @selector(didReceiveNotification:withUserInfo:)

@implementation SuperUserSpringBoard

- (void)didReceiveNotification:(NSString *)name withUserInfo:(NSDictionary *)userInfo {
    if (name && userInfo) {
        NSLog(@"Handling notification \"%@\" with user info: %@", name, userInfo);   
        
    }
    else { NSLog(@"Dismissing notification: %@", name); }
}

+ (NSString * _Nonnull)requestMessage {
    return @"com.pixelomer.superuser/authentication.request";
}

- (void)registerObservers {
    NSLog(@"Registering observers for notification center: %@", _notifCenter);
    rocketbootstrap_distributedmessagingcenter_apply([_notifCenter retain]);
    NSLog(@"RocketBootstrap applied.");
    [_notifCenter runServerOnCurrentThread];
    NSLog(@"Server started running on main thread.");
    [_notifCenter registerForMessageName:SuperUserSpringBoard.requestMessage target:self selector:NOTIF_RECEIVED_SEL];
    NSLog(@"Registering message name.");
}

- (_Nullable instancetype)init {
    return nil;
}

- (_Nullable instancetype)initWithNotificationCenter:(CPDistributedMessagingCenter * _Nonnull)center {
    [super init];
    _notifCenter = [center copy];
    if (!_notifCenter) return nil;
    return self;
}

@end