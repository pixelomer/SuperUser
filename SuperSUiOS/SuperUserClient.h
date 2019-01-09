#import <Foundation/Foundation.h>
#import "../macros.h"

@interface SuperUserClient : NSObject
@property (readonly,nonatomic) CPDistributedMessagingCenter * _Nonnull notifCenter;
+ (NSString * _Nonnull)replyMessage;
- (_Nullable instancetype)init __attribute__((unavailable("Use \"initWithNotificationCenter:\"")));
- (_Nullable instancetype)initWithNotificationCenter:(CPDistributedMessagingCenter * _Nonnull)center;
- (bool)authenticateWithIDType:(IDType)type;
@end