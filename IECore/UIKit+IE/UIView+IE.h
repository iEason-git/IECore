//
//  UIView+IE.h
//  IECore
//
//  Created by Eason on 15/8/24.
//  Copyright (c) 2015年 iEason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (IE)

#pragma mark -
#pragma mark # common
// 当前vc
- (UIViewController *)currentViewController;

// 截屏
- (UIImage *)snapshot;

// 旋转 1.0:顺时针180度
- (void)rotate:(CGFloat)angle;

//圆形
- (void)circle;
//圆角化
- (void)cornerRadius:(CGFloat)radius;
/**
 *  圆角化并可设置边框颜色及宽度
 *
 *  @param radius      圆角偏移值
 *  @param borderColor 边框颜色
 *  @param borderWidth 边框宽度
 */
- (void)setCornerRadius:(CGFloat)radius borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth;
/**
 *  部分圆角化
 *
 *  @param radius  圆角偏移值
 *  @param corners 圆角位置
 *
 *  @return self
 */
- (void)roundedRadius:(CGFloat)radius byRoundingCorners:(UIRectCorner)corners;

#pragma mark -
#pragma mark # gesture

// 增加手势
- (void)addTapGestureWithTarget:(id)target action:(SEL)action;
- (void)addTapGestureWithBlock:(void (^)(UIView *gestureView))aBlock;
- (void)removeTapGesture;

#pragma mark -
#pragma mark # UIActivityIndicatorView

// 活动指示器
- (UIActivityIndicatorView *)activityIndicatorViewShow;
- (UIActivityIndicatorView *)activityIndicatorView;
- (void)activityIndicatorViewHidden;

#pragma mark -
#pragma mark # animation

// 抖动
- (void)animationShake;
// 淡入淡出
- (void)animationCrossfadeWithDuration:(NSTimeInterval)duration;
- (void)animationCrossfadeWithDuration:(NSTimeInterval)duration completion:(void(^)())completion;

/** 立方体翻转
 *kCATransitionFromRight, kCATransitionFromLeft, kCATransitionFromTop, kCATransitionFromBottom
 */
- (void)animationCubeWithDuration:(NSTimeInterval)duration direction:(NSString *)direction;
- (void)animationCubeWithDuration:(NSTimeInterval)duration direction:(NSString *)direction completion:(void(^)())completion;

/** 翻转
 *kCATransitionFromRight, kCATransitionFromLeft, kCATransitionFromTop, kCATransitionFromBottom
 */
- (void)animationOglFlipWithDuration:(NSTimeInterval)duration direction:(NSString *)direction;
- (void)animationOglFlipWithDuration:(NSTimeInterval)duration direction:(NSString *)direction completion:(void(^)())completion;

/** 覆盖
 *kCATransitionFromRight, kCATransitionFromLeft, kCATransitionFromTop, kCATransitionFromBottom
 */
- (void)animationMoveInWithDuration:(NSTimeInterval)duration direction:(NSString *)direction;
- (void)animationMoveInWithDuration:(NSTimeInterval)duration direction:(NSString *)direction completion:(void(^)())completion;

@end

@interface UIView (Rect)

@property (nonatomic) CGFloat x;
@property (nonatomic) CGFloat y;
@property (nonatomic) CGPoint origin;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;
@property (nonatomic) CGSize  size;

@property (nonatomic, assign, readonly) CGFloat minX;
@property (nonatomic, assign, readonly) CGFloat midX;
@property (nonatomic, assign, readonly) CGFloat maxX;

@property (nonatomic, assign, readonly) CGFloat minY;
@property (nonatomic, assign, readonly) CGFloat midY;
@property (nonatomic, assign, readonly) CGFloat maxY;

@end