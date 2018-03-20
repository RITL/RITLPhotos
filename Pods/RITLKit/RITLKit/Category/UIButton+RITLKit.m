#import "UIButton+RITLKit.h"
#import "RITLRuntimeTool.h"


@interface RITLButtonExtension : NSObject

///color
@property (nonatomic, strong, nullable) UIColor *titleColor;
@property (nonatomic, strong, nullable) UIColor *titleShadowColor;

///title
@property (nonatomic, copy, nullable) NSString *title;
@property (nonatomic, copy, nullable) NSAttributedString *attributeTitle;

///image
@property (nonatomic, strong, nullable) UIImage *image;
//@property (nonatomic, strong, nullable) UIImage *backgroundImage;



+ (instancetype)ritlButtonExtension:(void(^)(RITLButtonExtension *obj))handler;
- (instancetype)mutable:(void(^)(RITLButtonExtension *obj))handler;

@end

@implementation RITLButtonExtension

+ (instancetype)ritlButtonExtension:(void (^)(RITLButtonExtension *))handler
{
    id obj = RITLButtonExtension.new;
    
    handler(obj);
    
    return obj;
}

- (instancetype)mutable:(void (^)(RITLButtonExtension *))handler
{
    handler(self);
    
    return self;
}

@end




@interface UIButton (RITLSwizzled)

@end

@implementation UIButton (RITLSwizzled)

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    return [super methodSignatureForSelector:aSelector];
}


- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    [super forwardInvocation:anInvocation];
}

@end

@implementation UIButton (RITLKit)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        [self ritl_swizzledInstanceSelector:@selector(methodSignatureForSelector:) swizzled:@selector(ritl_methodSignatureForSelector:)];
        
        [self ritl_swizzledInstanceSelector:@selector(forwardInvocation:) swizzled:@selector(ritl_forwardInvocation:)];
    });
}


- (NSMethodSignature *)ritl_methodSignatureForSelector:(SEL)sel
{
    SEL changedSelector = sel;
    
    if ([self isExtensionGetterSelector:sel])//getter
    {
        changedSelector = @selector(extensionValueForSelName:state:);
        
        return [self.class instanceMethodSignatureForSelector:changedSelector];
    }
    
    else if ([self isExtensionSetterSelector:sel])
    {
        changedSelector = @selector(setButtonExtension:forState:);
        
        return [self.class instanceMethodSignatureForSelector:changedSelector];
    }
    
    return [self ritl_methodSignatureForSelector:sel];
}




- (void)ritl_forwardInvocation:(NSInvocation *)invocation
{
    NSString *propertyName = nil;
    
    // getter
    propertyName = [self isExtensionGetterSelector:invocation.selector];
    
    if (propertyName)
    {
        UIControlState state = [self stateExtension:propertyName];
        
        invocation.selector = @selector(extensionValueForSelName:state:);
        [invocation setArgument:&propertyName atIndex:2];// self, _cmd, key
        [invocation setArgument:&state atIndex:3];
        [invocation invokeWithTarget:self];
        return;
    }
    
    
    // setter
    propertyName = [self isExtensionSetterSelector:invocation.selector];
    
    if (propertyName)
    {
        //获得第一个参数
        id object = nil;
        [invocation getArgument:&object atIndex:2];
        
        /// 获得对象
        RITLButtonExtension *obj = [self buttonExtension:propertyName argu:object];
        
        //获得当前状态
        UIControlState state = [self stateExtension:propertyName];
        
        invocation.selector = @selector(setButtonExtension:forState:);
        [invocation setArgument:&obj atIndex:2]; // self, _cmd, obj, state
        [invocation setArgument:&state atIndex:3];
        [invocation invokeWithTarget:self];
        return;
    }
    
    [self ritl_forwardInvocation:invocation];
}




- (NSString *)isExtensionGetterSelector:(SEL)selector
{
    NSString *selectorName = NSStringFromSelector(selector);
    
    if ([selectorName hasPrefix:@"ritl_"]) {//表示getter方法
        
        return selectorName;
    }
    
    return nil;
}



- (NSString *)isExtensionSetterSelector:(SEL)selector
{
    NSString *selectorName = NSStringFromSelector(selector);
    
    if ([selectorName hasPrefix:@"setRitl_"]) {//表示setter方法
        
        return selectorName;
    }
    
    return nil;
}


- (id)extensionValueForSelName:(NSString *)selName state:(UIControlState)state
{
    RITLButtonExtension *ex = [self defaultExtension:state];
    
    if ([selName containsString:@"AttributedTitle"]) {
        
        return ex.attributeTitle;
        
    }else if([selName containsString:@"TitleColor"]){
        
        return ex.titleColor;
        
    }else if([selName containsString:@"TitleShadowColor"]){
        
        return ex.titleShadowColor;
        
    }/*else if([selName containsString:@"BackgroundImage"]){
        
        return ex.backgroundImage;
      
    }*/else if ([selName containsString:@"Image"]){
        
        return ex.image;
        
    }else if([selName containsString:@"Title"]){
        
        return ex.title;
    }
    
    return nil;
}


- (RITLButtonExtension *)buttonExtension:(NSString *)selName argu:(id)object
{
    UIControlState state = [self stateExtension:selName];
    
    return [[self defaultExtension:state] mutable:^(RITLButtonExtension *obj) {
        
        if ([selName containsString:@"AttributedTitle"]) {
            
            obj.attributeTitle = object;
            
        }else if([selName containsString:@"TitleColor"]){
            
            obj.titleColor = object;
            
        }else if([selName containsString:@"TitleShadowColor"]){
            
            obj.titleShadowColor = object;
            
        }/*else if([selName containsString:@"BackgroundImage"]){
            
            obj.backgroundImage = object;
            
        }*/else if ([selName containsString:@"Image"]){
            
            obj.image = object;
            
        }else if([selName containsString:@"Title"]){
            
            obj.title = object;
        }
    }];
    
}


- (UIControlState)stateExtension:(NSString *)selName
{
    if ([selName containsString:@"normal"]) {
        return UIControlStateNormal;
    }
    
    else if([selName containsString:@"highlighted"]){
        return UIControlStateHighlighted;
    }
    
    else if([selName containsString:@"disabled"]){
        return UIControlStateDisabled;
    }
    
    else if([selName containsString:@"selected"]){
        return UIControlStateSelected;
    }
    
    else if([selName containsString:@"application"]){
        return UIControlStateApplication;
    }
    
    if (UIDevice.currentDevice.systemVersion.floatValue >= 9.0) {
        
        if (@available(iOS 9.0, *)) {
            if([selName containsString:@"focused"]){ return UIControlStateFocused; }
        }
    }
    
    return UIControlStateReserved;
}



#pragma mark -

- (RITLButtonExtension *)defaultExtension:(UIControlState)state
{
    return [RITLButtonExtension ritlButtonExtension:^(RITLButtonExtension *obj) {
        
        obj.title = [self titleForState:state];
        obj.attributeTitle = [self attributedTitleForState:state];
        obj.image = [self imageForState:state];
        //obj.backgroundImage = [self backgroundImageForState:state];
        obj.titleColor = [self titleColorForState:state];
        obj.titleShadowColor = [self titleShadowColorForState:state];
    }];
}


- (void)setButtonExtension:(RITLButtonExtension *)obj forState:(UIControlState)state
{
    [self setTitle:obj.title forState:state];
    [self setAttributedTitle:obj.attributeTitle forState:state];
    
    [self setImage:obj.image forState:state];
    //[self setBackgroundImage:obj.backgroundImage forState:state];
    
    [self setTitleColor:obj.titleColor forState:state];
    [self setTitleShadowColor:obj.titleShadowColor forState:state];
}

@end
