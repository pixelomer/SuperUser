#import <Foundation/Foundation.h>

typedef NS_ENUM(short, IDType) {
    IDTypeGroupID,
    IDTypeEffectiveUserID,
    IDTypeUserID
};

@interface SuperUserIDType : NSObject
+ (void)setOriginalEUID:(int (* _Nonnull)(uid_t))euid UID:(int (* _Nonnull)(uid_t))uid GID:(int (* _Nonnull)(uid_t))gid;
+ (int (* _Nullable)(uid_t))setterFunctionForIDType:(IDType)type;
+ (uid_t (* _Nullable)())getterFunctionForIDType:(IDType)type;
+ (uid_t)IDForIDType:(IDType)type;
+ (int)setID:(uid_t)ID forType:(IDType)type;
+ (NSString * _Nonnull)localizedDescriptionForIDType:(IDType)type;
@end