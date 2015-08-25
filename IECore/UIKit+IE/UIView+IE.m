//
//  UIView+IE.m
//  IECore
//
//  Created by Eason on 15/8/24.
//  Copyright (c) 2015年 iEason. All rights reserved.
//

#import "UIView+IE.h"
#import "IECommon.h"
#import <objc/runtime.h>

#define UIView_key_tapBlock       "UIView.tapBlock"

#define UIView_activityIndicatorViewTag 4534570

@implementation UIView (IE)

#pragma mark - common
- (UIViewController *)currentViewController
{
    id viewController = [self nextResponder];
    UIView *view      = self;
    
    while (viewController && ![viewController isKindOfClass:[UIViewController class]])
    {
        view           = [view superview];
        viewController = [view nextResponder];
    }
    
    return viewController;
}

- (UIImage *)snapshot
{
    UIGraphicsBeginImageContext(self.bounds.size);
    
    if (IOS7_OR_LATER) {
        // 这个方法比ios6下的快15倍
        [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
    } else  {
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)rotate:(CGFloat)angle
{
    self.transform = CGAffineTransformRotate(CGAffineTransformIdentity, M_PI * angle);
}

- (void)circle
{
    self.clipsToBounds = YES;
    
    self.layer.cornerRadius = self.bounds.size.width / 2;
}

- (void)cornerRadius:(CGFloat)radius
{
    self.clipsToBounds = YES;
    
    self.layer.cornerRadius = radius;
}

- (void)setCornerRadius:(CGFloat)radius
            borderColor:(UIColor *)borderColor
            borderWidth:(CGFloat)borderWidth
{
    [self.layer setMasksToBounds:YES];
    [self.layer setCornerRadius:radius];
    [self.layer setBorderColor:[borderColor CGColor]];
    [self.layer setBorderWidth:borderWidth];
}

- (void)roundedRadius:(CGFloat)radius byRoundingCorners:(UIRectCorner)corners
{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 100, 29)
                                                   byRoundingCorners:corners
                                                         cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

#pragma mark - gesture
- (void)addTapGestureWithTarget:(id)target action:(SEL)action
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    [self addGestureRecognizer:tap];
}

- (void)addTapGestureWithBlock:(void (^)(UIView *gestureView))aBlock
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self addGestureRecognizer:tap];
    
    objc_setAssociatedObject(self, UIView_key_tapBlock, aBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)tapAction
{
    void(^aBlock)(UIView *gestureView) = objc_getAssociatedObject(self, UIView_key_tapBlock);
    
    if (aBlock) aBlock(self);
}

- (void)removeTapGesture
{
    for (UIGestureRecognizer *gesture in self.gestureRecognizers)
    {
        if ([gesture isKindOfClass:[UITapGestureRecognizer class]])
        {
            [self removeGestureRecognizer:gesture];
        }
    }
}

#pragma mark - activityIndicatorView
- (UIActivityIndicatorView *)activityIndicatorView
{
    UIActivityIndicatorView *aView = (UIActivityIndicatorView *)[self viewWithTag:UIView_activityIndicatorViewTag];
    if (aView == nil)
    {
        aView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        aView.center = CGPointMake(self.bounds.size.width * .5, self.bounds.size.height * .5);
        aView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        aView.tag = UIView_activityIndicatorViewTag;
    }
    return aView;
}

- (UIActivityIndicatorView *)activityIndicatorViewShow
{
    UIActivityIndicatorView *aView = [self activityIndicatorView];
    
    [self addSubview:aView];
    [self bringSubviewToFront:aView];
    [aView startAnimating];
    
    aView.alpha = 0;
    [UIView animateWithDuration:.35 animations:^{
        aView.alpha = 1;
    }];
    
    return aView;
}

- (void)activityIndicatorViewHidden
{
    UIActivityIndicatorView *aView = (UIActivityIndicatorView *)[self viewWithTag:UIView_activityIndicatorViewTag];
    if (aView)
    {
        [aView stopAnimating];
        aView.alpha = 1;
        
        [UIView animateWithDuration:.35 animations:^{
            aView.alpha = 0;
        } completion:^(BOOL finished) {
            [aView removeFromSuperview];
        }];
    }
}

#pragma mark - animation
- (void)animationShake
{
    CABasicAnimation *shake = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    //设置抖动幅度
    shake.fromValue    = [NSNumber numberWithFloat:-0.1];
    shake.toValue      = [NSNumber numberWithFloat:+0.1];
    shake.duration     = 0.06;
    shake.autoreverses = YES;//是否重复
    shake.repeatCount  = 3;
    [self.layer addAnimation:shake forKey:@"XYShake"];
}

- (void)animationCrossfadeWithDuration:(NSTimeInterval)duration
{
    //jump through a few hoops to avoid QuartzCore framework dependency
    CAAnimation *animation = [NSClassFromString(@"CATransition") animation];
    [animation setValue:@"kCATransitionFade" forKey:@"type"];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    animation.duration = duration;
    [self.layer addAnimation:animation forKey:nil];
}

- (void)animationCrossfadeWithDuration:(NSTimeInterval)duration completion:(void(^)())completion
{
    [self animationCrossfadeWithDuration:duration];
    
    if (completion) {
        
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC));
        dispatch_after(time, dispatch_get_main_queue(), completion);
    }
}

- (void)animationCubeWithDuration:(NSTimeInterval)duration direction:(NSString *)direction
{
    CATransition *transtion = [CATransition animation];
    transtion.duration = duration;
    [transtion setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    [transtion setType:@"cube"];
    [transtion setSubtype:direction];
    [self.layer addAnimation:transtion forKey:@"transtionKey"];
}

- (void)animationCubeWithDuration:(NSTimeInterval)duration direction:(NSString *)direction completion:(void(^)())completion
{
    [self animationCubeWithDuration:duration direction:direction];
    if (completion) {
        
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC));
        dispatch_after(time, dispatch_get_main_queue(), completion);
    }
}

- (void)animationOglFlipWithDuration:(NSTimeInterval)duration direction:(NSString *)direction
{
    CATransition *transtion = [CATransition animation];
    transtion.duration = duration;
    [transtion setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    [transtion setType:@"oglFlip"];
    [transtion setSubtype:direction];
    [self.layer addAnimation:transtion forKey:@"transtionKey"];
}

- (void)animationOglFlipWithDuration:(NSTimeInterval)duration
                           direction:(NSString *)direction
                          completion:(void(^)())completion
{
    [self animationOglFlipWithDuration:duration direction:direction];
    
    if (completion) {
        
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC));
        dispatch_after(time, dispatch_get_main_queue(), completion);
    }
}

- (void)animationMoveInWithDuration:(NSTimeInterval)duration direction:(NSString *)direction
{
    CATransition *transtion = [CATransition animation];
    transtion.duration = duration;
    [transtion setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    [transtion setType:kCATransitionMoveIn];
    [transtion setSubtype:direction];
    [self.layer addAnimation:transtion forKey:@"transtionKey"];
}

- (void)animationMoveInWithDuration:(NSTimeInterval)duration
                          direction:(NSString *)direction
                         completion:(void(^)())completion
{
    [self animationMoveInWithDuration:duration direction:direction];
    
    if (completion) {
        
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC));
        dispatch_after(time, dispatch_get_main_queue(), completion);
    }
}

@end

#pragma mark - UIView+Rect
@implementation UIView (Rect)

- (CGFloat)x {
    
    return self.frame.origin.x;
}

- (void)setX:(CGFloat)value {
    
    self.frame = CGRectMake(value, self.y, self.width, self.height);
}

- (CGFloat)y {
    
    return self.frame.origin.y;
}

- (void)setY:(CGFloat)value {
    
    self.frame = CGRectMake(self.x, value, self.width, self.height);
}

- (CGPoint)origin {
    
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin {
    
    self.frame = CGRectMake(origin.x, origin.y, self.width, self.height);
}

- (CGFloat)width {
    
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)value {
    
    self.frame = CGRectMake(self.x, self.y, value, self.height);
}

- (CGFloat)height {
    
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)value {
    
    self.frame = CGRectMake(self.x, self.y, self.width, value);
}

- (CGSize)size {
    
    return self.frame.size;
}

- (void)setSize:(CGSize)size {
    
    self.frame = CGRectMake(self.x, self.y, size.width, size.height);
}

- (CGFloat)minX
{
    return CGRectGetMinX(self.frame);
}

- (CGFloat)midX
{
    return CGRectGetMidX(self.frame);
}

- (CGFloat)maxX
{
    
    return CGRectGetMaxX(self.frame);
}

- (CGFloat)minY
{
    return CGRectGetMinY(self.frame);
}

- (CGFloat)midY
{
    return CGRectGetMidY(self.frame);
}

- (CGFloat)maxY
{
    return CGRectGetMaxY(self.frame);
}

@end
