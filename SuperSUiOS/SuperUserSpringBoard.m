#import "SuperUserSpringBoard.h"
// Temporary
#define LocalizedString(val) val

@implementation SuperUserSpringBoard

- (void)didReceiveNotification:(NSString *)name withUserInfo:(NSDictionary *)userInfo {
    if (name && userInfo) {
        NSLog(@"Handling notification \"%@\" with user info: %@", name, userInfo);   
        UIAlertView *alert = [[NSClassFromString(@"UIAlertView") alloc]
            initWithTitle:@"SuperUser"
            message:@"Can I haz root?"
            delegate:nil
            cancelButtonTitle:nil
            otherButtonTitles:
                LocalizedString(@"Yes"),
                LocalizedString(@"Always"),
                LocalizedString(@"No"),
                LocalizedString(@"Never"), nil];
        [alert show];
    }
    else { NSLog(@"Dismissing notification: %@", name); }
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
    [_notifCenter registerForMessageName:SuperUserSpringBoard.requestMessage target:self selector:NOTIF_RECEIVED_SEL];
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