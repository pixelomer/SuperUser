#import <Foundation/Foundation.h>
#import "../macros.h"
#import <notify.h>

@protocol DarwinNotificationCenterDelegate
@required
- (void)didReceiveNotification:(NSString * _Nonnull)name fromCenter:(_Nonnull CFNotificationCenterRef)center;
@end

@interface DarwinNotificationCenter : NSObject
@property (nonatomic,readonly) _Nonnull CFNotificationCenterRef notifCenterRef;
@property (nonatomic,retain) _Nonnull id<DarwinNotificationCenterDelegate> delegate;

- (void)removeEveryObserver;
- (void)addObserverWithName:(NSString * _Nonnull)name;
- (void)removeObserverNamed:(NSString * _Nonnull)name;
- (void)postNotification:(NSString * _Nonnull)name;
+ (void)postNotification:(NSString * _Nonnull)name;
- (_Nullable instancetype)initWithDelegate:(_Nonnull id<DarwinNotificationCenterDelegate>)delegate;
+ (_Nullable instancetype)notificationCenterWithDelegate:(_Nonnull id<DarwinNotificationCenterDelegate>)delegate;

@end