#if DEBUG
#define NSLog(args...) NSLog(@"[SuperUser] "args)
#else
#define NSLog(...); /* */
#endif
#define NOTIFICATION_CENTER_NAME @"com.pixelomer.superuser"
#import <rocketbootstrap/rocketbootstrap.h>
#import <AppSupport/CPDistributedMessagingCenter.h>
#define NOTIF_RECEIVED_SEL @selector(didReceiveNotification:withUserInfo:)