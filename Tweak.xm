#import <Foundation/Foundation.h>
#import "macros.h"
#import "SuperSUiOS/SuperSUiOS.h"

SuperUserSpringBoard *server;
SuperUserClient *client;
NSBundle *mainBundle;

%group Client
%hookf(int, setuid, uid_t val) {
    return %orig;
}
%hookf(int, seteuid, uid_t val) {
    return %orig;
}
%hookf(int, setgid, uid_t val) {
    return %orig;
}
%end

%ctor {
    NSLog(@"init");
    CPDistributedMessagingCenter *notifCenter = [CPDistributedMessagingCenter centerNamed:NOTIFICATION_CENTER_NAME];
    if (notifCenter) {
        mainBundle = NSBundle.mainBundle;
        if (mainBundle && mainBundle.bundleIdentifier && [mainBundle.bundleIdentifier isEqualToString:@"com.apple.springboard"]) {
            server = [[[SuperUserSpringBoard alloc] initWithNotificationCenter:notifCenter] retain];
            NSLog(@"Server: %@", server);
            [server registerObservers];
        }
        else {
            NSLog(@"Sending test notification...");
            [notifCenter sendMessageName:SuperUserSpringBoard.requestMessage userInfo:@{
                @"Test" : @"Successful",
                @"pname" : NSProcessInfo.processInfo.processName,
                @"bid" : ((mainBundle && mainBundle.bundleIdentifier) ? mainBundle.bundleIdentifier : @"")
            }];
            %init(Client);
        }
    }
    else {
        NSLog(@"Notification center couldn't be initialized.");
    }
}