#import "SuperUserSpringBoard.h"

@implementation SuperUserSpringBoard

- (void)didReceiveNotification:(NSString * _Nonnull)name fromCenter:(_Nonnull CFNotificationCenterRef)center {
    if ([name isEqualToString:@"com.apple.springboard.lockcomplete"]) {
        NSLog(@"Screen was locked.");
        //[self dismissAllAlerts];
    }
}

- (void)dismissAllAlerts {
    /*
    for (UIAlertView *alert in alerts) {
        [alert dismissWithClickedButtonIndex:alert.cancelButtonIndex animated:NO];
        alert.context = [alert buttonTitleAtIndex:alert.cancelButtonIndex];
    }
    */
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    alertView.context = [alertView buttonTitleAtIndex:buttonIndex];
}

- (NSDictionary *)didReceiveNotification:(NSString *)name withUserInfo:(NSDictionary *)userInfo {
    if (name && userInfo) {
        uid_t newID = [(NSNumber *)userInfo[kID] intValue];
        short newIDType = [(NSNumber *)userInfo[kIDType] shortValue];
        NSString *userDefaultsKey = [NSString stringWithFormat:@"%@/%@/%i", userInfo[kBundleID], userInfo[kProcessName], newIDType];
        NSNumber *userDefaultsValue = [[NSUserDefaults standardUserDefaults] objectForKey:userDefaultsKey inDomain:@"com.pixelomer.superuser.history"];
        if (userDefaultsValue)
            return @{ kSuccess : userDefaultsValue };
        NSString *IDDescription = [NSString stringWithFormat:@"%i", newID];
        if (newIDType == IDTypeGroupID) {
            struct group *idinfo = getgrgid(newID);
            if (idinfo && idinfo->gr_name)
                IDDescription = [IDDescription stringByAppendingFormat:@" (%s)", idinfo->gr_name];
        }
        else {
            struct passwd *idinfo = getpwuid(newID);
            if (idinfo && idinfo->pw_name)
                IDDescription = [IDDescription stringByAppendingFormat:@" (%s)", idinfo->pw_name];
        }
        NSString *reason = [NSString stringWithFormat:@"Allow \"%@\" to set its %@ to %@?",
            userInfo[kUserFriendlyName],
            [SuperUserIDType localizedDescriptionForIDType:newIDType],
            IDDescription
        ];
        NSLog(@"Handling notification \"%@\" with user info: %@", name, userInfo);   
        UIAlertView *alert = [[NSClassFromString(@"UIAlertView") alloc]
            initWithTitle:reason
            message:LocalizedString(@"This will be used by the app to either gain or drop priveleges.")
            delegate:self
            cancelButtonTitle:LocalizedString(@"Don't Allow")
            otherButtonTitles:
                @"Allow Once",
                @"Always Allow",
                @"Never Allow",
            nil
        ];
        [alert show];
        NSLog(@"Alert shown.");
        /**************************************************************************************/
        /* Work-in-progress attempt to block main thread while not blocking user interactions */
        /*                                                                                    */
        /* Reason: Some applications can behave unexpectedly if they don't get permissions    */
        /*         they asked for immediately and even showing the alert itself takes a       */
        /*         second. As a result, the main thread is blocked to make sure the app       */
        /*         doesn't attempt to do anything with the permissions. This, however, causes */
        /*         a different problem. Blocking the main thread while not blocking user      */
        /*         interactions makes it impossible for the user to wake the device up. As a  */
        /*         result, if an app/daemon asks for permission while the device is asleep,   */
        /*         the user won't be able to answer the alert.                                */
        /**************************************************************************************/
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        int i = 0;
        NSTimeInterval interval = 0.5;
        NSTimeInterval timeoutInSeconds = 5.0;
        int maxIterations = timeoutInSeconds / interval;
        while (!alert.context && maxIterations >= i) {
            NSDate *date = [NSDate dateWithTimeIntervalSinceNow:interval];
            [runLoop runUntilDate:date];
            i++;
        }
        if (!alert.context) {
            [alert dismissWithClickedButtonIndex:alert.cancelButtonIndex animated:NO];
            alert.context = [alert buttonTitleAtIndex:alert.cancelButtonIndex];
        }
        if ([(NSString *)alert.context isEqualToString:@"Allow Once"]) {
            return @{ kSuccess : @(YES) };
        }
        else if ([(NSString *)alert.context isEqualToString:@"Always Allow"]) {
            [[NSUserDefaults standardUserDefaults] setObject:@1 forKey:userDefaultsKey inDomain:@"com.pixelomer.superuser.history"];
            return @{ kSuccess : @(YES) };
        }
        else if ([(NSString *)alert.context isEqualToString:@"Never Allow"]) 
            [[NSUserDefaults standardUserDefaults] setObject:@0 forKey:userDefaultsKey inDomain:@"com.pixelomer.superuser.history"];
    }
    else {
        NSLog(@"Dismissing notification: %@", name);
    }
    return @{ kSuccess : @(NO) };
}

+ (NSString * _Nonnull)requestMessage {
    return @"authentication.request";
}

- (void)registerObservers {
    NSLog(@"Registering observers for notification center: %@", _notifCenter);
    rocketbootstrap_distributedmessagingcenter_apply([_notifCenter retain]);
    NSLog(@"RocketBootstrap applied.");
    [_notifCenter runServerOnCurrentThread];
    NSLog(@"Server started running on main thread.");
    [_notifCenter registerForMessageName:SuperUserSpringBoard.requestMessage target:self selector:@selector(didReceiveNotification:withUserInfo:)];
    NSLog(@"Registered request message.");
    [darwinNotifCenter addObserverWithName:@"com.apple.springboard.lockcomplete"];
    NSLog(@"Registered SpringBoard lockcomplete notification.");
}

- (_Nullable instancetype)init {
    return nil;
}

- (_Nullable instancetype)initWithNotificationCenter:(CPDistributedMessagingCenter * _Nonnull)center {
    [super init];
    if (!center) return nil;
    _notifCenter = [center retain];
    darwinNotifCenter = [DarwinNotificationCenter notificationCenterWithDelegate:self];
    if (!_notifCenter || !darwinNotifCenter) return nil;
    alerts = [[NSMutableArray alloc] init];
    return self;
}

@end