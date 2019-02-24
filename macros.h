#import <rocketbootstrap/rocketbootstrap.h>
#import <AppSupport/CPDistributedMessagingCenter.h>
#if DEBUG
#define NSLog(args...) NSLog(@"[SuperUser] "args)
#else
#define NSLog(...); /* */
#endif
#define NOTIFICATION_CENTER_NAME @"com.pixelomer.superuser"
#define kProcessName @"pname"
#define kUserFriendlyName @"ufriendlyname"
#define kBundleID @"bid"
#define kIDType @"idtype"
#define kID @"id"
#define LocalizedString(val) [NSBundle.mainBundle localizedStringForKey:val value:val table:nil]
#define kSuccess @"success"
@interface NSUserDefaults(Private)
- (id)setObject:(id)obj forKey:(NSString *)key inDomain:(NSString *)domain;
- (id)objectForKey:(NSString *)key inDomain:(NSString *)domain;
@end