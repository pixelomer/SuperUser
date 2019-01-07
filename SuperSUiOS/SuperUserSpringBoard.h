#import <Foundation/Foundation.h>
#import "../macros.h"
#import "DarwinNotificationCenter.h"

@interface SuperUserSpringBoard : NSObject<DarwinNotificationCenterDelegate> {
    DarwinNotificationCenter *notifCenter;
}
- (void)registerObservers;
- (void)didReceiveNotification:(NSString * _Nonnull)name fromCenter:(_Nonnull CFNotificationCenterRef)center;
- (_Nullable instancetype)init;
@end