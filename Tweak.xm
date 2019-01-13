#import <Foundation/Foundation.h>
#import "macros.h"
#import "SuperSUiOS/SuperSUiOS.h"

SuperUserSpringBoard *server;
SuperUserClient *client;
CPDistributedMessagingCenter *notifCenter;
NSBundle *mainBundle;
bool isSpringBoard;

%group Client
%hookf(int, setuid, uid_t val) {
    return [client authenticateWithIDType:IDTypeUserID ID:val];
}
%hookf(int, seteuid, uid_t val) {
    return [client authenticateWithIDType:IDTypeEffectiveUserID ID:val];
}
%hookf(int, setgid, uid_t val) {
    return [client authenticateWithIDType:IDTypeGroupID ID:val];
}
%end

%ctor {
    NSLog(@"init");
    notifCenter = [CPDistributedMessagingCenter centerNamed:NOTIFICATION_CENTER_NAME];
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
                %init(Client);
                [SuperUserIDType setOriginalEUID:_logos_orig$Client$seteuid UID:_logos_orig$Client$setuid GID:_logos_orig$Client$setgid];
                [client startServer];
            }
        }
    }
    else {
        NSLog(@"Notification center couldn't be initialized.");
    }
}