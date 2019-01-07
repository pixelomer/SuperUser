#import "SuperUserSpringBoard.h"

@implementation SuperUserSpringBoard

- (void)didReceiveNotification:(NSString * _Nonnull)name fromCenter:(_Nonnull CFNotificationCenterRef)center {
    NSLog(@"Received notification named: %@", name);
}

- (void)registerObservers {
    NSLog(@"Registering observers...");
    [notifCenter addObserverWithName:@"com.pixelomer.superuser/test.succesful"];
}

- (_Nullable instancetype)init {
    [super init];
    notifCenter = [[DarwinNotificationCenter alloc] initWithDelegate:[self retain]];
    if (!notifCenter) return nil;
    return self;
}

@end