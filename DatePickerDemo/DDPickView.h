//
//  DDPickView.h
//  DatePickerDemo
//
//  Created by wdc on 2018/3/14.
//  Copyright © 2018年 dd. All rights reserved.
//

/**
 需求:展示多种格式的时间
 年
 年月
 年月日
 年月日时
 年月日时分
 年月日时分秒
 
 展示自定义数据
 **/

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, DDPickViewDateType) {
    KDDPickViewDateType_Y = 0,
    KDDPickViewDateType_YM,
    KDDPickViewDateType_YMD,
    KDDPickViewDateType_YMDH,
    KDDPickViewDateType_YMDHM,
    KDDPickViewDateType_YMDHMS,
    KDDPickViewDateType_Custom,
};

typedef void (^DD_PickerViewResultBlock)(NSArray *resultArray,BOOL isCancel);

@interface DDPickView : UIView

/**
 日期从哪一年开始,如不传默认1900年开始
 */
@property (nonatomic, strong) NSDate *startDate;
/**
 日期到哪一年结束,如不传默认2100年结束
 */
@property (nonatomic, assign) NSInteger endDate;
/**
 开始的选中日期,如不传则默认为当前时间
 */
@property (nonatomic, strong) NSDate *selDate;
/**
 设置标题
 */
@property (nonatomic, copy) NSString *titleStr;
/**
 取消按钮标题
 */
@property (nonatomic, copy) NSString *leftBtnTitle;
/**
 确定按钮标题
 */
@property (nonatomic, copy) NSString *rightBtnTitle;
/**
 设置背景颜色
 */
@property (nonatomic, strong) UIColor *bgColor;
/**
 日期选择文本颜色
 */
@property (nonatomic, strong) UIColor *dateTextColor;
/**
 设置分钟数为0
 */
@property (nonatomic, assign) BOOL minutesIsZero;
/**
 设置分割线颜色
 */
@property (nonatomic, strong) UIColor *lineViewColor;

/**
 弹出日期选择器
 @param frame frame
 @param pickerViewType pickerViewType
 @param configuration 配置pickView基本信息
 @param resultBlock 返回结果的block,bolck中BOOL值为NO代表点击了确定,为YES代表点击了取消或背景区域
 */
+ (void)pickerViewWithFrame:(CGRect)frame andType:(DDPickViewDateType)pickerViewType
              configuration:(void (^)(DDPickView *pickView))configuration
                      resultBlock:(DD_PickerViewResultBlock)resultBlock;

/**
 弹出自定义数据选择器

 @param frame frame
 @param pickerViewType KDDPickViewDateType_Custom
 @param dataArray 自定义数据源,二维数组,dataArray[component][row]
 @param configuration 配置pickView基本信息
 @param resultBlock 返回结果的block,bolck中BOOL值为NO代表点击了确定,为YES代表点击了取消或背景区域
 */
+ (void)pickerViewWithFrame:(CGRect)frame andType:(DDPickViewDateType)pickerViewType dataArray:(NSMutableArray *)dataArray configuration:(void (^)(DDPickView *pickView))configuration resultBlock:(DD_PickerViewResultBlock)resultBlock;

@end
