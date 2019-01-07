#import "DarwinNotificationCenter.h"

void DarwinNotificationCenterCallback(CFNotificationCenterRef center, void *observer, CFNotificationName name, const void *object, CFDictionaryRef userInfo) {
    NSLog(@"Internal callback was called, forwarding to %@...", (id)observer);
    [(id<DarwinNotificationCenterDelegate>)[(id)observer performSelector:@selector(delegate)] didReceiveNotification:(__bridge NSString*)name fromCenter:center];
}

@implementation DarwinNotificationCenter

- (void)removeEveryObserver {
    CFNotificationCenterRemoveEveryObserver(_notifCenterRef, self);
}

- (void)addObserverWithName:(NSString * _Nonnull)name {
    CFNotificationCenterAddObserver(_notifCenterRef, self, &DarwinNotificationCenterCallback, (__bridge CFNotificationName)name, NULL, 0);
}

- (void)removeObserverNamed:(NSString * _Nonnull)name {
    CFNotificationCenterRemoveObserver(_notifCenterRef, self, (__bridge CFNotificationName)name, NULL);
}

- (void)postNotification:(NSString * _Nonnull)name {
    CFNotificationCenterPostNotification(_notifCenterRef, (__bridge CFNotificationName)name, NULL, NULL, NO);
}

+ (void)postNotification:(NSString * _Nonnull)name {
    CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), (__bridge CFNotificationName)name, NULL, NULL, NO);
}

- (_Nullable instancetype)initWithDelegate:(_Nonnull id<DarwinNotificationCenterDelegate>)delegate {
    [super init];
    _notifCenterRef = CFNotificationCenterGetDarwinNotifyCenter();
    self.delegate = delegate;
    return self;
}

+ (_Nullable instancetype)notificationCenterWithDelegate:(_Nonnull id<DarwinNotificationCenterDelegate>)delegate {
    return [[DarwinNotificationCenter alloc] initWithDelegate:delegate];
}

@end