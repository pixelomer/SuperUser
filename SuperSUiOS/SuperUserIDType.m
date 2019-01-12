#import "SuperUserIDType.h"

@implementation SuperUserIDType

int (*setuid_orig)(uid_t);
int (*seteuid_orig)(uid_t);
int (*setgid_orig)(uid_t);

+ (void)setOriginalEUID:(int (* _Nonnull)(uid_t))euid UID:(int (* _Nonnull)(uid_t))uid GID:(int (* _Nonnull)(uid_t))gid {
    seteuid_orig = euid;
    setuid_orig = uid;
    setgid_orig = gid;
}

+ (int (* _Nullable)(uid_t))setterFunctionForIDType:(IDType)type {
    if (type == IDTypeEffectiveUserID) return seteuid_orig;
    else if (type == IDTypeUserID) return setuid_orig;
    else if (type == IDTypeGroupID) return setgid_orig;
    else {
        @throw [NSException exceptionWithName:NSInvalidArgumentException
            reason:[NSString stringWithFormat:@"Invalid IDType: %i", type]
            userInfo:nil
        ];
    }
}

+ (uid_t (* _Nullable)())getterFunctionForIDType:(IDType)type {
    if (type == IDTypeEffectiveUserID) return &geteuid;
    else if (type == IDTypeUserID) return &getuid;
    else if (type == IDTypeGroupID) return &getgid;
    else {
        @throw [NSException exceptionWithName:NSInvalidArgumentException
            reason:[NSString stringWithFormat:@"Invalid IDType: %i", type]
            userInfo:nil
        ];
    }
}

+ (NSString * _Nonnull)localizedDescriptionForIDType:(IDType)type {
    if (type == IDTypeEffectiveUserID) return LocalizedString(@"effective user ID");
    else if (type == IDTypeUserID) return LocalizedString(@"user ID");
    else if (type == IDTypeGroupID) return LocalizedString(@"group ID");
    else return LocalizedString(@"unknown ID");
}

+ (uid_t)IDForIDType:(IDType)type {
    return [SuperUserIDType getterFunctionForIDType:type]();
}

+ (int)setID:(uid_t)ID forType:(IDType)type {
    NSLog(@"+[SuperUserIDType setID:%i forType:%i]", ID, type);
    return [SuperUserIDType setterFunctionForIDType:type](ID);
}

@end