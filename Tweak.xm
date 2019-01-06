#import "macros.h"
#import "SuperUserObserver/SuperUserObserver.h"
#import <SpringBoard/SpringBoard.h>

id observer;
NSDistributedNotificationCenter *notifCenter;

%group SpringBoard
%end

%group Global
%end

%group App
%hookf(int, setgid, gid_t gid) {
    return ([observer authenticateWithIDType:IDTypeGroupID ID:gid] ? %orig : -1);
}
%hookf(int, setuid, uid_t uid) {
    return ([observer authenticateWithIDType:IDTypeUserID ID:uid] ? %orig : -1);
}
%hookf(int, seteuid, uid_t euid) {
    return ([observer authenticateWithIDType:IDTypeEffectiveUserID ID:euid] ? %orig : -1);
}
%end

%ctor {
    notifCenter = [(NSDistributedNotificationCenter*)[NSDistributedNotificationCenter defaultCenter] retain];
    %init(Global);
    if ([[mainBundle bundleIdentifier] isEqualToString:@"com.apple.springboard"]) {
        LAPolicy policy;
        if (kCFCoreFoundationVersionNumber >= 1240.10) policy = LAPolicyDeviceOwnerAuthentication;
        else policy = LAPolicyDeviceOwnerAuthenticationWithBiometrics;
        observer = [[[SuperUserObserver alloc] initWithPolicy:policy] retain];
        [observer registerAsObserver];
        %init(SpringBoard);
    }
    else {
        observer = [[[SuperUser alloc] init] retain];
        %init(App);
    }
}