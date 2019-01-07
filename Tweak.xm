#import <Foundation/Foundation.h>
#import "macros.h"
#import "SuperSUiOS/SuperSUiOS.h"

SuperUserSpringBoard *server;

%ctor {
    NSLog(@"init");
    NSBundle *mainBundle = NSBundle.mainBundle;
    if (mainBundle && mainBundle.bundleIdentifier && [mainBundle.bundleIdentifier isEqualToString:@"com.apple.springboard"]) {
        server = [[[SuperUserSpringBoard alloc] init] retain];
        NSLog(@"Server: %@", server);
        [server registerObservers];
    }
    else {
        NSLog(@"Sending test notification...");
        [DarwinNotificationCenter postNotification:@"com.pixelomer.superuser/test.succesful"];
    }
}