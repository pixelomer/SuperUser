#import <Foundation/Foundation.h>
#import "../macros.h"

@interface SuperUserSpringBoard : NSObject
@property (readonly,nonatomic) CPDistributedMessagingCenter * _Nonnull notifCenter;
- (void)registerObservers;
- (_Nullable instancetype)initWithNotificationCenter:(CPDistributedMessagingCenter * _Nonnull)center;
@end