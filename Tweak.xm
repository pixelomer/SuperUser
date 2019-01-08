#import <Foundation/Foundation.h>
#import "macros.h"
#import "SuperSUiOS/SuperSUiOS.h"

SuperUserSpringBoard *server;
CPDistributedMessagingCenter *notifCenter;
NSBundle *mainBundle;

%ctor {
    NSLog(@"init");
    notifCenter = [CPDistributedMessagingCenter centerNamed:NOTIFICATION_CENTER_NAME];
    if (notifCenter) {
        mainBundle = NSBundle.mainBundle;
        if (mainBundle && mainBundle.bundleIdentifier && [mainBundle.bundleIdentifier isEqualToString:@"com.apple.springboard"]) {
            server = [[[SuperUserSpringBoard alloc] initWithNotificationCenter:notifCenter] retain];
            NSLog(@"Server: %@", server);
            [server registerObservers];
        }
        else {
            NSLog(@"Sending test notification...");
            [notifCenter sendMessageName:@"com.pixelomer.superuser/authentication.request" userInfo:@{
                @"Test" : @"Successful",
                @"pname" : NSProcessInfo.processInfo.processName,
                @"bid" : ((mainBundle && mainBundle.bundleIdentifier) ? mainBundle.bundleIdentifier : @"")
            }];
        }
    }
    else {
        NSLog(@"Notification center couldn't be initialized.");
    }
}