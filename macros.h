#if DEBUG
#define NSLog(args...) NSLog(@"[SuperUser] "args)
#else
#define NSLog(...); /* */
#endif
#define NOTIFICATION_CENTER_NAME @"com.pixelomer.superuser"
#import <rocketbootstrap/rocketbootstrap.h>
#import <AppSupport/CPDistributedMessagingCenter.h>
typedef NS_ENUM(NSInteger, IDType) {
    IDTypeGroupID,
    IDTypeEffectiveUserID,
    IDTypeUserID
};