#import "NSBundle+UserFriendlyName.h"

@implementation NSBundle(UserFriendlyName)

// Priority:
//  1. Display name (app name in the homescreen)
//  2. Executable name
//  3. Process name
//  4. "(unknown)"
- (NSString *)userFriendlyName {
    return [self.localizedInfoDictionary objectForKey:@"CFBundleDisplayName"] ?: 
        ([self.infoDictionary objectForKey:@"CFBundleExecutable"] ?: 
        (NSProcessInfo.processInfo.processName ?: @"(unknown)"));
}

@end