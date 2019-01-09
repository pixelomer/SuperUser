#import "SuperUserClient.h"

@implementation SuperUserClient

+ (NSString * _Nonnull)replyMessage {
    return @"com.pixelomer.superuser/authentication.reply";
}

- (_Nullable instancetype)init {
    return nil;
}

- (_Nullable instancetype)initWithNotificationCenter:(CPDistributedMessagingCenter * _Nonnull)center {
    [super init];
    _notifCenter = [center copy];
    if (!_notifCenter) return nil;
    return self;
}

- (bool)authenticateWithIDType:(IDType)type {
    return true;
}

@end