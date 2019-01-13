#import "SuperUserClient.h"
#import "../Extensions/Extensions.h"

@implementation SuperUserClient

- (_Nullable instancetype)init {
    return nil;
}

- (_Nullable instancetype)initWithNotificationCenter:(CPDistributedMessagingCenter * _Nonnull)center {
    [super init];
    if (!center) return nil;
    _notifCenter = [center retain];
    ongoingRequests = [[NSMutableDictionary alloc] init];
    if (!_notifCenter || !ongoingRequests) return nil;
    return self;
}

- (void)startServer {
    // Does nothing
}

- (int)authenticateWithIDType:(IDType)type ID:(uid_t)ID {
    NSLog(@"Client wants to set its %@ to %i", [SuperUserIDType localizedDescriptionForIDType:type], type);
    NSMutableDictionary *userInfo = [@{
        kProcessName : NSProcessInfo.processInfo.processName,
        kID : @(ID),
        kIDType : @(type)
    } mutableCopy];
    if (NSBundle.mainBundle) {
        if (NSBundle.mainBundle.userFriendlyName)
            [userInfo setObject:NSBundle.mainBundle.userFriendlyName forKey:kUserFriendlyName];
        if (NSBundle.mainBundle.bundleIdentifier)
            [userInfo setObject:NSBundle.mainBundle.bundleIdentifier forKey:kBundleID];
    }
    NSDictionary *reply = [_notifCenter sendMessageAndReceiveReplyName:SuperUserSpringBoard.requestMessage userInfo:[userInfo copy]];
    NSLog(@"Reply: %@", reply);
    [userInfo release];
    if (reply && [(NSNumber *)reply[kSuccess] boolValue]) {
        NSLog(@"Authentication was successful. Performing operations. Current ID: %i", [SuperUserIDType IDForIDType:type]);
        [SuperUserIDType setID:ID forType:type];
        NSLog(@"New ID: %i", [SuperUserIDType IDForIDType:type]);
        return 0;
    }
    return -1;
}

@end