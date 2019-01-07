#import <Foundation/Foundation.h>
#import "SuperSUiOS/SuperSUiOS.h"

%ctor {
    NSBundle *mainBundle = NSBundle.mainBundle;
    if (mainBundle && mainBundle.bundleIdentifier && [mainBundle.bundleIdentifier isEqualToString:@"com.apple.springboard"]) {
        SuperUserSpringBoard *server = [[SuperUserSpringBoard alloc] init];
        [server registerObservers];
    }
}