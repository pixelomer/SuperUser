#import <Foundation/Foundation.h>
#import <SpringBoard/SpringBoard.h>
#import <DarwinNotificationCenter/DarwinNotificationCenter.h>
#import "../macros.h"
#import "SuperUserClient.h"
#import "../Extensions/UIAlertView+Context.h"
#import <grp.h>
#import <pwd.h>

@interface SuperUserSpringBoard : NSObject<DarwinNotificationCenterDelegate> {
    NSMutableArray *alerts;
    DarwinNotificationCenter *darwinNotifCenter;
}
@property (readonly,nonatomic) CPDistributedMessagingCenter * _Nonnull notifCenter;
- (void)dismissAllAlerts;
- (void)registerObservers;
- (void)didReceiveNotification:(NSString * _Nonnull)name fromCenter:(_Nonnull CFNotificationCenterRef)center;
+ (NSString * _Nonnull)requestMessage;
- (_Nullable instancetype)init __attribute__((unavailable("Use \"initWithNotificationCenter:\"")));
- (_Nullable instancetype)initWithNotificationCenter:(CPDistributedMessagingCenter * _Nonnull)center;
@end