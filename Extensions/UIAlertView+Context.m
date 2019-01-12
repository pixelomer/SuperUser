#import "UIAlertView+Context.h"

@implementation UIAlertView(Context)
@dynamic context;

-(void)setContext:(id)context {
    objc_setAssociatedObject(self, @selector(context), context, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(id)context {
    return objc_getAssociatedObject(self, @selector(context));
}

@end