#import "SuperUserClient.h"
#import "../Extensions/Extensions.h"

@implementation SuperUserClient

+ (NSString * _Nonnull)replyMessage {
    return @"authentication.reply";
}

- (_Nullable instancetype)init {
    return nil;
}

- (_Nullable instancetype)initWithNotificationCenter:(CPDistributedMessagingCenter * _Nonnull)center {
    [super init];
    if (!center) return nil;
    _notifCenter = [center retain];
    if (!_notifCenter) return nil;
    return self;
}

- (void)startServer {
    [[_notifCenter retain] runServerOnCurrentThread];
    NSLog(@"Started client server for notification center: %@", _notifCenter);
}

- (bool)authenticateWithIDType:(IDType)type ID:(uid_t)ID {
    NSLog(@"Client wants to authenticate with ID %i of type %i", ID, type);
    NSMutableDictionary *userInfo = [@{
        kProcessName : NSProcessInfo.processInfo.processName,
        kUserFriendlyName : NSBundle.mainBundle.userFriendlyName
    } mutableCopy];
    if (NSBundle.mainBundle) {
        if (NSBundle.mainBundle.bundleIdentifier)
            [userInfo setObject:NSBundle.mainBundle.bundleIdentifier forKey:kBundleID];
    }
    [_notifCenter sendMessageName:SuperUserSpringBoard.requestMessage userInfo:[userInfo copy]];
    return true;
}

@end