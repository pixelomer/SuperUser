#import <Foundation/Foundation.h>
#import "../macros.h"
#import "SuperUserClient.h"
#import "../Extensions/UIAlertView+Context.h"
#import <grp.h>
#import <pwd.h>

@interface SuperUserSpringBoard : NSObject
@property (readonly,nonatomic) CPDistributedMessagingCenter * _Nonnull notifCenter;
- (void)registerObservers;
+ (NSString * _Nonnull)requestMessage;
- (_Nullable instancetype)init __attribute__((unavailable("Use \"initWithNotificationCenter:\"")));
- (_Nullable instancetype)initWithNotificationCenter:(CPDistributedMessagingCenter * _Nonnull)center;
@end