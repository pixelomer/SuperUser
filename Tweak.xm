#import <Foundation/Foundation.h>
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
%hookf(int, setgid, gid_t val) {
    return [client authenticateWithIDType:IDTypeGroupID ID:val];
}
%end

%group Server
%end

%ctor {
    NSLog(@"init with UID=%i, GID=%i, EUID=%i", getuid(), getgid(), geteuid());
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
                %init(Server);
                [server registerObservers];
            }
            else {
                %init(Client);
                [SuperUserIDType setOriginalEUID:_logos_orig$Client$seteuid UID:_logos_orig$Client$setuid GID:_logos_orig$Client$setgid];
                [client startServer];
                // Apps with SUID bit set will be ran as the owner as soon as the binary is executed. Compare it to the real ID to check it.
                if (getuid() != geteuid()) {
                    uid_t olduid = geteuid();
                    [SuperUserIDType setID:getuid() forType:IDTypeEffectiveUserID];
                    [client authenticateWithIDType:IDTypeEffectiveUserID ID:olduid];
                }
            }
        }
    }
    else {
        NSLog(@"Notification center couldn't be initialized.");
    }
}