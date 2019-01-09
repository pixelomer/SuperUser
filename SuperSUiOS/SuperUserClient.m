#import "SuperUserClient.h"

@implementation SuperUserClient

+ (NSString * _Nonnull)replyMessage {
    return NOTIFICATION_CENTER_NAME@"/authentication.reply";
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
    rocketbootstrap_distributedmessagingcenter_apply([_notifCenter retain]);
    NSLog(@"RocketBootstrap applied.");
    [[_notifCenter retain] runServerOnCurrentThread];
    NSLog(@"Started client server for notification center: %@", _notifCenter);
}

- (bool)authenticateWithIDType:(IDType)type ID:(uid_t)ID {
    NSLog(@"Client wants to authenticate with ID %i of type %i", ID, type);
    return true;
}

@end