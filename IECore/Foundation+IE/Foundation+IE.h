//
//  Foundation+IE.h
//  IECore
//
//  Created by Eason on 15/8/24.
//  Copyright (c) 2015年 iEason. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef IECore_Foundation_IE_h
#define IECore_Foundation_IE_h

#import "NSObject+IE.h"

#endif

#ifdef c__plusplus
extern "c"{
#endif
    //生成随机数,endvalue > startValue
    static inline NSInteger randomValueFrom(NSInteger startValue, NSInteger endValue)
    {
        return (NSInteger)(arc4random() % (endValue - startValue)) + startValue;
    }
#ifdef c__plusplus
}
#endif
