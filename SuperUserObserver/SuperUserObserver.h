#import "../macros.h"

@interface SuperUserObserver : NSObject
@property (nonatomic,assign) LAPolicy policy;
@property (nonatomic,readonly) CPDistributedMessagingCenter *center;
@property (nonatomic,assign) id springBoard;
- (instancetype)initWithPolicy:(LAPolicy)policy;
- (void)appWantsToAuthenticate:(id)v1 withUserInfo:(NSDictionary *)userInfo;
+ (NSString *)localizedDescriptionForIDType:(unsigned short)type;
- (void)registerAsObserver;
@end

@interface SuperUser : NSObject {
    NSNumber *authenticationStatus;
    CPDistributedMessagingCenter *notifCenter;
}
- (bool)authenticateWithIDType:(short)idType ID:(uid_t)newID;
@end