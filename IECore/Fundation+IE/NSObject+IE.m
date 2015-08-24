//
//  NSObject+IE.m
//  IECore
//
//  Created by Eason on 15/8/24.
//  Copyright (c) 2015年 iEason. All rights reserved.
//

#import "NSObject+IE.h"
#import <objc/runtime.h>

#define NSObject_key_tempObject	"NSObject.tempObject"
#define NSObject_key_objectDic	"NSObject.objectDic"
#define NSObject_key_EventBlockDic	"NSObject.eventBlockDic"

@implementation NSObject (IE)

#pragma mark- object
- (id)tempObject
{
    return objc_getAssociatedObject(self, NSObject_key_tempObject);
}

- (void)setTempObject:(id)tempObject
{
    [self willChangeValueForKey:@"tempObject"];
    
    objc_setAssociatedObject(self, NSObject_key_tempObject, tempObject, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self didChangeValueForKey:@"tempObject"];
}

- (id)bindObject:(const char *)identifier;
{
    NSAssert(identifier != nil, @"identifier can't be nil.");
    
    return objc_getAssociatedObject(self, identifier);
}

- (void)setBindObject:(const char *)identifier object:(id)obj
{
    NSAssert(identifier != nil, @"identifier can't be nil.");
    
    objc_setAssociatedObject(self, identifier, obj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)sendObject:(id)anObject
{
    [self sendObject:anObject withIdentifier:@"sendObject"];
}

- (void)receiveObject:(void(^)(id object))aBlock
{
    [self receiveObject:aBlock withIdentifier:@"sendObject"];
}

- (void)sendObject:(id)anObject withIdentifier:(NSString *)identifier
{
    NSAssert(identifier != nil, @"identifier can't be nil.");
    
    NSDictionary *dic = objc_getAssociatedObject(self, NSObject_key_objectDic);
    
    if(dic == nil) return;
    
    void(^aBlock)(id anObject) =  [dic objectForKey:identifier];
    aBlock(anObject);
}

- (void)receiveObject:(void(^)(id object))aBlock withIdentifier:(NSString *)identifier
{
    NSAssert(identifier != nil, @"identifier can't be nil.");
    
    NSMutableDictionary *dic = objc_getAssociatedObject(self, NSObject_key_objectDic);
    if(dic == nil)
    {
        dic = [NSMutableDictionary dictionaryWithCapacity:4];
        objc_setAssociatedObject(self, NSObject_key_objectDic, dic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    [dic setObject:[aBlock copy] forKey:identifier];
}

#pragma mark - block
- (id)blockForDefaultEvent
{
    return [self blockForEventWithIdentifier:@"EventBlock"];
}

- (void)handlerDefaultEventWithBlock:(id)block
{
    [self handlerEventWithBlock:block withIdentifier:@"EventBlock"];
}

- (void)handlerEventWithBlock:(id)aBlock withIdentifier:(NSString *)identifier
{
    NSAssert(identifier != nil, @"identifier can't be nil.");
    
    NSMutableDictionary *dic = objc_getAssociatedObject(self, NSObject_key_EventBlockDic);
    if(dic == nil)
    {
        dic = [[NSMutableDictionary alloc] init];
        objc_setAssociatedObject(self, NSObject_key_EventBlockDic, dic, OBJC_ASSOCIATION_RETAIN);
    }
    
    [dic setObject:[aBlock copy] forKey:identifier];
}

- (id)blockForEventWithIdentifier:(NSString *)identifier
{
    NSAssert(identifier != nil, @"identifier can't be nil.");
    
    NSDictionary *dic = objc_getAssociatedObject(self, NSObject_key_EventBlockDic);
    
    if(dic == nil) return nil;
    
    return [dic objectForKey:identifier];
}

#pragma mark- copy
- (id)deepCopy
{
    return [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:self]];
}

@end
