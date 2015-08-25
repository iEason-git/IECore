//
//  UIColor+IE.h
//  IECore
//
//  Created by Eason on 15/8/24.
//  Copyright (c) 2015年 iEason. All rights reserved.
//

#import <UIKit/UIKit.h>

//颜色值
#define makeColor(_r, _g, _b, _a)   [UIColor colorWithRed:(float)_r/255 green:(float)_g/255 blue:(float)_b/255 alpha:_a]

//返回一个十六进制表示的颜色 eg:0xFFFFFF代表白色
#define UIColorFromHEX(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
                                                 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
                                                  blue:((float)(rgbValue & 0xFF))/255.0 \
                                                 alpha:1.0]

#define UIColorFromHEXA(rgbaValue) [UIColor colorWithRed:((float)((rgbaValue & 0xFF000000) >> 24))/255.0 \
                                                   green:((float)((rgbaValue & 0xFF0000) >> 16))/255.0 \
                                                    blue:((float)((rgbaValue & 0xFF00) >> 8))/255.0 \
                                                   alpha:((float)(rgbaValue & 0xFF))/255.0]


@interface UIColor (IE)

/*系统主色*/
+ (UIColor *)mcSystemColor;


// 返回颜色的十六进制string
- (NSString *)hexString;

/**
 Creates an array of 4 NSNumbers representing the float values of r, g, b, a in that order.
 @return    NSArray
 */
- (NSArray *)rgbaArray;

@end
