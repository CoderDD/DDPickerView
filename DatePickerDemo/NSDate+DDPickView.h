//
//  NSDate+DDPickView.h
//  DatePickerDemo
//
//  Created by wdc on 2018/3/15.
//  Copyright © 2018年 dd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (DDPickView)
@property (nonatomic, readonly) NSInteger year;
@property (nonatomic, readonly) NSInteger month;
@property (nonatomic, readonly) NSInteger day;
@property (nonatomic, readonly) NSInteger nearestHour;
@property (nonatomic, readonly) NSInteger hour;
@property (nonatomic, readonly) NSInteger minute;
@property (nonatomic, readonly) NSInteger second;
@property (nonatomic, readonly) NSInteger nanosecond;
@property (nonatomic, readonly) NSInteger weekday;
@end
