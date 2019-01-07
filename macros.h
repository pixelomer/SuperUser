#if DEBUG
#define NSLog(args...) NSLog(@"[SuperUser] "args)
#else
#define NSLog(...); /* */
#endif