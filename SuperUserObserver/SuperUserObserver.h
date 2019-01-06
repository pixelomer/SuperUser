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
    CPDistributedMessagingCenter *notifCenter;
}
@property (nonatomic,assign) int (*orig_setgid)(gid_t gid);
@property (nonatomic,assign) int (*orig_setuid)(uid_t uid);
@property (nonatomic,assign) int (*orig_seteuid)(uid_t euid);
@property (nonatomic,retain) NSNumber *authenticationStatus;
- (bool)authenticateWithIDType:(short)idType ID:(uid_t)newID;
@end