//
//  UIFont+IE.m
//  IECore
//
//  Created by Eason on 15/8/24.
//  Copyright (c) 2015年 iEason. All rights reserved.
//

#import "UIFont+IE.h"

@implementation UIFont (IE)

+(UIFont *)mcFontBig
{
    return [UIFont systemFontOfSize:18.f];
}

+(UIFont *)mcFontNomarl
{
    return [UIFont systemFontOfSize:15.f];
}

+(UIFont *)mcFontSmall
{
    return [UIFont systemFontOfSize:13.f];
}

+(UIFont *)mcFontSuperSmall
{
    return [UIFont systemFontOfSize:11.f];
}

+(UIFont *)mcFontBoldBig
{
    return [UIFont boldSystemFontOfSize:18.f];
}

+(UIFont *)mcFontBoldNomal
{
    return [UIFont boldSystemFontOfSize:15.f];
}

+(UIFont *)mcFontBoldSmall
{
    return [UIFont boldSystemFontOfSize:13.f];
}

+(UIFont *)mcFontBoldSuperSmall
{
    return [UIFont boldSystemFontOfSize:11.f];
}

@end
