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
    [observer authenticateWithIDType:IDTypeUserID ID:gid];
    return 0;
}
%hookf(int, setuid, uid_t uid) {
    [observer authenticateWithIDType:IDTypeUserID ID:uid];
    return 0;
}
%hookf(int, seteuid, uid_t euid) {
    [observer authenticateWithIDType:IDTypeUserID ID:euid];
    return 0;
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
        ((SuperUser*)observer).orig_setuid = _logos_orig$App$setuid;
        ((SuperUser*)observer).orig_setgid = _logos_orig$App$setgid;
        ((SuperUser*)observer).orig_seteuid = _logos_orig$App$seteuid;
    }
}