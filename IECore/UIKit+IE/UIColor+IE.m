//
//  UIColor+IE.m
//  IECore
//
//  Created by Eason on 15/8/24.
//  Copyright (c) 2015年 iEason. All rights reserved.
//

#import "UIColor+IE.h"

#define AGEColorImplement(COLOR_NAME,RED,GREEN,BLUE)    \
+ (UIColor *)COLOR_NAME{    \
    static UIColor* COLOR_NAME##_color;    \
    static dispatch_once_t COLOR_NAME##_onceToken;   \
    dispatch_once(&COLOR_NAME##_onceToken, ^{    \
        COLOR_NAME##_color = [UIColor colorWithRed:(float)RED/255 green:(float)GREEN/255 blue:(float)BLUE/255 alpha:1.0];  \
    });\
    return COLOR_NAME##_color;  \
}

@implementation UIColor (IE)

AGEColorImplement(mcSystemColor, 0xf9, 0x3f, 0x3d)




#pragma mark - tools
- (NSString *)hexString{
    NSArray *colorArray	= [self rgbaArray];
    int r = [colorArray[0] floatValue] * 255;
    int g = [colorArray[1] floatValue] * 255;
    int b = [colorArray[2] floatValue] * 255;
    NSString *red = [NSString stringWithFormat:@"%02x", r];
    NSString *green = [NSString stringWithFormat:@"%02x", g];
    NSString *blue = [NSString stringWithFormat:@"%02x", b];
    
    return [NSString stringWithFormat:@"#%@%@%@", red, green, blue];
}

- (NSArray *)rgbaArray
{
    // Takes a [self class] and returns R,G,B,A values in NSNumber form
    CGFloat r = 0;
    CGFloat g = 0;
    CGFloat b = 0;
    CGFloat a = 0;
    
    if ([self respondsToSelector:@selector(getRed:green:blue:alpha:)])
    {
        [self getRed:&r green:&g blue:&b alpha:&a];
    }
    else
    {
        const CGFloat *components = CGColorGetComponents(self.CGColor);
        r = components[0];
        g = components[1];
        b = components[2];
        a = components[3];
    }
    
    return @[@(r), @(g), @(b), @(a)];
}

@end
