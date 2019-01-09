#import <Foundation/Foundation.h>
#import "macros.h"
#import "SuperSUiOS/SuperSUiOS.h"

SuperUserSpringBoard *server;
SuperUserClient *client;
NSBundle *mainBundle;
bool isSpringBoard;

%group Client
%hookf(int, setuid, uid_t val) {
    return [client authenticateWithIDType:IDTypeUserID ID:val] ? %orig : -1;
}
%hookf(int, seteuid, uid_t val) {
    return [client authenticateWithIDType:IDTypeEffectiveUserID ID:val] ? %orig : -1;
}
%hookf(int, setgid, uid_t val) {
    return [client authenticateWithIDType:IDTypeGroupID ID:val] ? %orig : -1;
}
%end

%ctor {
    NSLog(@"init");
    CPDistributedMessagingCenter *notifCenter = [CPDistributedMessagingCenter centerNamed:NOTIFICATION_CENTER_NAME];
    if (notifCenter) {
        mainBundle = NSBundle.mainBundle;
        isSpringBoard = (mainBundle && mainBundle.bundleIdentifier && [mainBundle.bundleIdentifier isEqualToString:@"com.apple.springboard"]);
        if (isSpringBoard)
            server = [[[SuperUserSpringBoard alloc] initWithNotificationCenter:notifCenter] retain];
        else
            client = [[[SuperUserClient alloc] initWithNotificationCenter:notifCenter] retain];
        if (server || client) {
            if (isSpringBoard) {
                NSLog(@"Server: %@", server);
                [server registerObservers];
            }
            else {
                [SuperUserIDType setOriginalEUID:_logos_orig$Client$seteuid UID:_logos_orig$Client$setuid GID:_logos_orig$Client$setgid];
                NSLog(@"Sending test notification...");
                [notifCenter sendMessageName:SuperUserSpringBoard.requestMessage userInfo:@{
                    @"Test" : @"Successful",
                    @"pname" : NSProcessInfo.processInfo.processName,
                    @"bid" : ((mainBundle && mainBundle.bundleIdentifier) ? mainBundle.bundleIdentifier : @"")
                }];
                %init(Client);
            }
        }
    }
    else {
        NSLog(@"Notification center couldn't be initialized.");
    }
}