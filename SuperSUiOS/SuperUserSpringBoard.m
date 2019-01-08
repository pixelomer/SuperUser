#import "SuperUserSpringBoard.h"
#define NOTIF_RECEIVED_SEL @selector(didReceiveNotification:withUserInfo:)

@implementation SuperUserSpringBoard

- (void)didReceiveNotification:(NSString *)name withUserInfo:(NSDictionary *)userInfo {
    if (name && userInfo) {
        NSLog(@"Handling notification \"%@\" with user info: %@", name, userInfo);   
        
    }
    else { NSLog(@"Dismissing notification: %@", name); }
}

- (void)registerObservers {
    NSLog(@"Registering observers for notification center: %@", _notifCenter);
    rocketbootstrap_distributedmessagingcenter_apply([_notifCenter retain]);
    NSLog(@"Applied RocketBootstrap applied.");
    //[_notifCenter runServerOnCurrentThread];
    //NSLog(@"Server started running on main thread.");
    dispatch_async(dispatch_get_main_queue(), ^(){
        [_notifCenter runServerOnCurrentThread];
    });
    NSLog(@"Server started on background thread.");
    [_notifCenter registerForMessageName:@"com.pixelomer.superuser/authentication.request" target:self selector:NOTIF_RECEIVED_SEL];
    NSLog(@"Registering message name.");
}

- (_Nullable instancetype)initWithNotificationCenter:(CPDistributedMessagingCenter * _Nonnull)center {
    [super init];
    _notifCenter = [center retain];
    if (!_notifCenter) return nil;
    return self;
}

@end