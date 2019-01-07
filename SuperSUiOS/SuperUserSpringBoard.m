#import "SuperUserSpringBoard.h"

@implementation SuperUserSpringBoard

- (void)didReceiveNotification:(NSString * _Nonnull)name fromCenter:(_Nonnull CFNotificationCenterRef)center {
    NSLog(@"Received notification named: %@", name);
}

- (void)registerObservers {
    [notifCenter addObserverWithName:@"com.pixelomer.superuser/test.succesful"];
}

- (_Nullable instancetype)init {
    if ([super init]) {
        notifCenter = [DarwinNotificationCenter notificationCenterWithDelegate:[self retain]];
        if (!notifCenter) return nil;
    }
    return nil;
}

@end