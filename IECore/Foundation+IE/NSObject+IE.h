//
//  NSObject+IE.h
//  IECore
//
//  Created by Eason on 15/8/24.
//  Copyright (c) 2015年 iEason. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (IE)

#pragma mark -
#pragma mark # object
@property (nonatomic, strong) id    tempObject;

//bind object
//setbind value
- (id)bindObject:(const char *)identifier;
- (void)setBindObject:(const char *)identifier object:(id)obj;

// send object
// handle block with default identifier is @"sendObject".
- (void)receiveObject:(void(^)(id object))aBlock;
- (void)sendObject:(id)anObject;

//tag can't be nil
- (void)receiveObject:(void(^)(id object))aBlock withIdentifier:(NSString *)identifier;
- (void)sendObject:(id)anObject withIdentifier:(NSString *)identifier;

#pragma mark -
#pragma mark # block
- (id)blockForDefaultEvent;
// handle block with default identifier is @"EventBlock".
- (void)handlerDefaultEventWithBlock:(id)aBlock;

// 设置一个block作为回调
- (void)handlerEventWithBlock:(id)aBlock withIdentifier:(NSString *)identifier;
- (id)blockForEventWithIdentifier:(NSString *)identifier;

#pragma mark -
#pragma mark # copy
// 基于NSKeyArchive.如果 self导入XYAutoCoding.h,可用与自定义对象
- (id)deepCopy;

@end
