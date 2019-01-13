#import <Foundation/Foundation.h>
#import <DarwinNotificationCenter/DarwinNotificationCenter.h>
#import "../macros.h"
#import "SuperUserIDType.h"
#import "SuperUserSpringBoard.h"

@interface SuperUserClient : NSObject<DarwinNotificationCenterDelegate> {
    NSMutableDictionary<NSString *, NSArray<NSNumber*> *> *ongoingRequests;
}
@property (readonly,nonatomic) CPDistributedMessagingCenter * _Nonnull notifCenter;
@property (readonly,nonatomic) DarwinNotificationCenter * _Nonnull darwinNotifCenter;
+ (NSString * _Nonnull)replyMessage;
- (_Nullable instancetype)init __attribute__((unavailable("Use \"initWithNotificationCenter:\"")));
- (_Nullable instancetype)initWithNotificationCenter:(CPDistributedMessagingCenter * _Nonnull)center;
- (bool)authenticateWithIDType:(IDType)type ID:(uid_t)ID;
- (void)startServer;
@end