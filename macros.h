#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <AppSupport/CPDistributedMessagingCenter.h>
#import <rocketbootstrap/rocketbootstrap.h>
#import <LocalAuthentication/LocalAuthentication.h>
#import <Foundation/NSDistributedNotificationCenter.h>
#import <pwd.h>
#define mainBundle NSBundle.mainBundle
#define LocalizedString(string) [mainBundle localizedStringForKey:string value:string table:nil]
#define kAuthenticationRequest @"com.pixelomer.superuser.app.authRequest"
#define kAuthenticationCenter @"com.pixelomer.superuser"
#define kAuthenticationReply @"com.pixelomer.superuser.app.authReply"
#define b64encode(string) [[string dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength]
#define b64decode(string) [[NSString alloc] initWithData:[[NSData alloc] initWithBase64EncodedString:string options:NSDataBase64DecodingIgnoreUnknownCharacters] encoding:NSUTF8StringEncoding]
#define kID @"newID"
#define kIDType @"IDType"
#define kRequestID @"requestID"
#define kAppName @"appName"
#define kHasAuthenticated @"authSuccessful"
#define kProcessName @"pname"
#define IDTypeEffectiveUserID 0
#define IDTypeUserID 1
#define IDTypeGroupID 2
#if DEBUG
#define NSLog(args...) NSLog(@"[SuperUser] "args)
#else
#define NSLog(...); /* */
#endif