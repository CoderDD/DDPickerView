//
//  DDPickView.m
//  DatePickerDemo
//
//  Created by wdc on 2018/3/14.
//  Copyright © 2018年 dd. All rights reserved.
//

#import "DDPickView.h"
#import "NSDate+DDPickView.h"
#import "Header.h"

@interface DDPickView()<UIPickerViewDataSource,UIPickerViewDelegate>
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UIButton *bgView;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *enterBtn;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, assign) CGFloat  pickerViewHeight;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *yearArray;
@property (nonatomic, strong) NSMutableArray *monthArray;
@property (nonatomic, strong) NSMutableArray *dayArray;
@property (nonatomic, strong) NSMutableArray *hoursArray;
@property (nonatomic, strong) NSMutableArray *minutesArray;
@property (nonatomic, strong) NSMutableArray *secondsArray;
@property (nonatomic, copy) NSString *resultStr;
@property (nonatomic, strong) NSMutableArray *resultArray;
@property (nonatomic, assign) DDPickViewDateType dateType;
@property (nonatomic, strong) UIWindow *alertWindow;
@property (nonatomic, copy) DD_PickerViewResultBlock resultBlock;
@property (nonatomic, strong) NSArray *labelTextArray;
@end
@implementation DDPickView

+ (void)pickerViewWithFrame:(CGRect)frame andType:(DDPickViewDateType)pickerViewType
              configuration:(void (^)(DDPickView *pickView))configuration
                      resultBlock:(DD_PickerViewResultBlock)resultBlock
{
    DDPickView *pickView = [[DDPickView alloc]initWithFrame:frame];
    pickView.dateType = pickerViewType;
    pickView.pickerViewHeight = 309;
    if (configuration) {
        configuration(pickView);
    }
    [pickView setupSubViews];
    [pickView selectRow];
    pickView.resultBlock = resultBlock;
    [[UIApplication sharedApplication].keyWindow addSubview:pickView];
    [pickView show];
}

+ (void)pickerViewWithFrame:(CGRect)frame andType:(DDPickViewDateType)pickerViewType dataArray:(NSMutableArray *)dataArray configuration:(void (^)(DDPickView *pickView))configuration resultBlock:(DD_PickerViewResultBlock)resultBlock
{
    DDPickView *pickView = [[DDPickView alloc]initWithFrame:frame];
    pickView.dateType = pickerViewType;
    pickView.pickerViewHeight = 265;
    pickView.dataArray = dataArray.mutableCopy;
    if (configuration) {
        configuration(pickView);
    }
    [pickView setupSubViews];
    [pickView selectRow];
    pickView.resultBlock = resultBlock;
    [[UIApplication sharedApplication].keyWindow addSubview:pickView];
    [pickView show];
}

#pragma mark - 布局子控件
#pragma mark *********************
- (void)setupSubViews
{
    CGFloat lineHeight = 1;
    CGFloat headerViewH = 45;
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, headerViewH)];
    headView.backgroundColor = [UIColor whiteColor];
    
    UIView *line1View = [[UIView alloc] initWithFrame:CGRectMake(0, 44, ScreenWidth, lineHeight)];
    line1View.backgroundColor = SHColor_LineColor230;
    
    if (self.leftBtnTitle.length) {
        CGSize leftSize = stringSize(self.leftBtnTitle, CGSizeMake(ScreenWidth, 44), 18);
        _cancelBtn = [self btnWithFrame:CGRectMake(10, 0, leftSize.width, 44) title:_leftBtnTitle font:18 titleColor:[UIColor blackColor]];
    }else{
        _cancelBtn = [self btnWithFrame:CGRectMake(10, 0, 50, 44) title:@"取消" font:18 titleColor:[UIColor blackColor]];
    }
    [_cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:_cancelBtn];
    if (self.rightBtnTitle.length) {
        CGSize rightSize = stringSize(self.rightBtnTitle, CGSizeMake(ScreenWidth, 44), 18);
        _enterBtn = [self btnWithFrame:CGRectMake(ScreenWidth - rightSize.width - 10, 0, rightSize.width, 44) title:_rightBtnTitle font:18 titleColor:[UIColor blackColor]];
    }else{
        _enterBtn = [self btnWithFrame:CGRectMake(ScreenWidth - 60, 0, 50, 44) title:@"确定" font:18 titleColor:[UIColor blackColor]];
    }
    [_enterBtn addTarget:self action:@selector(enterBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:_enterBtn];
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_cancelBtn.frame), 0, ScreenWidth - 20 - CGRectGetWidth(_cancelBtn.frame) - CGRectGetWidth(_enterBtn.frame), 44)];
    _titleLabel.font = [UIFont systemFontOfSize:18];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.text = _titleStr.length ? _titleStr : @"";
    [headView addSubview:_titleLabel];
    
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(headView.frame), ScreenWidth, _pickerViewHeight-CGRectGetHeight(line1View.frame)-CGRectGetHeight(headView.frame))];
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    _pickerView.backgroundColor = _bgColor ? _bgColor : [UIColor whiteColor];
    _pickerView.showsSelectionIndicator = YES;
    
    _bgView = [[UIButton alloc] initWithFrame:self.bounds];
    [_bgView addTarget:self action:@selector(bgViewClick:) forControlEvents:UIControlEventTouchUpInside];
    _bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    _bgView.alpha = 0;
    
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-_pickerViewHeight, ScreenWidth, _pickerViewHeight)];
    _contentView.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:_bgView];
    [_contentView addSubview:headView];
    [_contentView addSubview:line1View];
    [_contentView addSubview:_pickerView];
    [self addSubview:_contentView];
}

#pragma mark - 点击事件
#pragma mark *********************
- (void)bgViewClick:(UIButton *)sender
{
    [self dismiss];
    if (self.resultBlock)
    {
        self.resultBlock(self.resultArray,YES);
    }
}
- (void)cancelBtnClick:(UIButton *)sender
{
    [self dismiss];
    if (self.resultBlock)
    {
        self.resultBlock(self.resultArray,YES);
    }
}
- (void)enterBtnClick:(UIButton *)sender
{
    [self dismiss];
    if (self.resultBlock)
    {
        self.resultBlock(self.resultArray,NO);
    }
}
#pragma mark - show/dismiss
#pragma mark *********************
- (void)show
{
    self.hidden = NO;
    _contentView.frame = CGRectMake(0, self.superview.bounds.size.height-_pickerViewHeight, ScreenWidth, _pickerViewHeight);
    self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.3f];
    [UIView animateWithDuration:0.3 animations:^{
        _bgView.alpha = 1;
    }];
    [animation setType:kCATransitionMoveIn];
    [animation setSubtype:kCATransitionFromTop];
    [animation setFillMode:kCAFillModeForwards];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    [_contentView.layer addAnimation:animation forKey:nil];
}
- (void)dismiss
{
    [UIView animateWithDuration:.3 animations:^{
        _contentView.frame = CGRectMake(0, self.bounds.size.height, ScreenWidth, _pickerViewHeight);
        _bgView.alpha = 0;
    } completion:^(BOOL finished) {
        self.frame = CGRectMake(0, self.superview.bounds.size.height, ScreenWidth, ScreenHeight);
        [self removeFromSuperview];
    }];
}
#pragma mark - UIPickerViewDataSource,UIPickerViewDelegate
#pragma mark *********************
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return self.dataArray.count;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return ((NSMutableArray *)self.dataArray[component]).count;
}
-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 45;
}
-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return ((pickerView.bounds.size.width-20)-2*(self.dataArray.count-1))/self.dataArray.count;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *labelText = [[UILabel alloc] init];
    labelText.font = [UIFont systemFontOfSize:15];
    labelText.backgroundColor = [UIColor clearColor];
    labelText.textAlignment = NSTextAlignmentCenter;
    labelText.textColor = self.dateTextColor;
    NSArray *componentArray = self.dataArray[component];
    labelText.text = componentArray[row];
    
    for (UIView *lineView in pickerView.subviews)
    {
        if (lineView.frame.size.height < 1)
        {
            lineView.backgroundColor = self.lineViewColor ? self.lineViewColor : [UIColor grayColor];
        }
    }
    return labelText;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self refreshResultStrWithRow:row inComponent:component];
}
#pragma mark - 刷新结果
#pragma mark *********************
- (void)refreshResultStrWithRow:(NSInteger)row inComponent:(NSInteger)component
{
    //刷新日期数组
    if (_dateType == KDDPickViewDateType_YMD || _dateType == KDDPickViewDateType_YMDH || _dateType == KDDPickViewDateType_YMDHM || _dateType == KDDPickViewDateType_YMDHMS) {
        //如果滚动的是年,月,才刷新日期数组
        switch (component) {
            case 0: //年
            {
                NSString *year = self.dataArray[component][row];
                NSString *month = self.resultArray[1];
                [self refreshDayArrayWithYear:year Month:month];
            }
                break;
            case 1: //月
            {
                NSString *year = self.resultArray[0];
                NSString *month = self.dataArray[component][row];
                [self refreshDayArrayWithYear:year Month:month];
            }
                break;
                
            default:
                break;
        }
    }
    //把resultArray的元素替换掉
    [self.resultArray replaceObjectAtIndex:component withObject:((NSMutableArray *)self.dataArray[component])[row]];
    self.resultStr = @"";
    for (NSString *str in self.resultArray) {
        self.resultStr = [self.resultStr stringByAppendingString:str];
    }
    NSLog(@"%@",self.resultStr);
}
#pragma mark - 计算当月有多少天
#pragma mark *********************
- (NSInteger)totaldaysInMonth:(NSDate *)date
{
    NSRange daysInOfMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return daysInOfMonth.length;
}
//刷新day数组
- (void)refreshDayArrayWithYear:(NSString *)year Month:(NSString *)month
{
    [self.dayArray removeAllObjects];
    if ([year containsString:@"年"]) {
        year = [year substringToIndex:year.length - 1];
    }
    if ([month containsString:@"月"]) {
        month = [month substringToIndex:month.length - 1];
    }
    NSString * dateStr = [NSString stringWithFormat:@"%@-%@",year,month];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM";
    NSDate * date = [dateFormatter dateFromString:dateStr];
    NSInteger count =  [self totaldaysInMonth:date];
    for (int i = 1; i < count + 1; i++)
    {
        NSString *str = [NSString stringWithFormat:@"%02i日",i];
        [_dayArray addObject:str];
    }
    //因为天数改变了,所以结果数组的天数也要刷新
    if (count == 28) {
        //如果之前的结果大于28
        NSString *temp = self.resultArray[2];
        NSInteger day = [[temp substringToIndex:2] integerValue];
        if (day > 28) {
            [self.resultArray replaceObjectAtIndex:2 withObject:@"28日"];
        }
    }else if (count == 29){
        NSString *temp = self.resultArray[2];
        NSInteger day = [[temp substringToIndex:2] integerValue];
        if (day > 29) {
            [self.resultArray replaceObjectAtIndex:2 withObject:@"29日"];
        }
    }
    [self.pickerView reloadComponent:2];
}
#pragma mark - 快速创建按钮
#pragma mark *********************
- (UIButton *)btnWithFrame:(CGRect)frame title:(NSString *)title font:(CGFloat)font titleColor:(UIColor *)titleColor
{
    UIButton *btn = [[UIButton alloc]initWithFrame:frame];
    [btn setTitle:title forState:0];
    [btn setTitleColor:titleColor forState:0];
    btn.titleLabel.font = [UIFont systemFontOfSize:font];
    return btn;
}
#pragma mark - 懒加载
#pragma mark *********************
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = @[].mutableCopy;
        switch (_dateType) {
            case KDDPickViewDateType_Y:
            {
                [_dataArray addObject:self.yearArray];
            }
                break;
            case KDDPickViewDateType_YM:
            {
                [_dataArray addObject:self.yearArray];
                [_dataArray addObject:self.monthArray];
            }
                 break;
            case KDDPickViewDateType_YMD:
            {
                [_dataArray addObject:self.yearArray];
                [_dataArray addObject:self.monthArray];
                [_dataArray addObject:self.dayArray];
            }
                 break;
            case KDDPickViewDateType_YMDH:
            {
                [_dataArray addObject:self.yearArray];
                [_dataArray addObject:self.monthArray];
                [_dataArray addObject:self.dayArray];
                [_dataArray addObject:self.hoursArray];
            }
                 break;
            case KDDPickViewDateType_YMDHM:
            {
                [_dataArray addObject:self.yearArray];
                [_dataArray addObject:self.monthArray];
                [_dataArray addObject:self.dayArray];
                [_dataArray addObject:self.hoursArray];
                [_dataArray addObject:self.minutesArray];
            }
                 break;
            case KDDPickViewDateType_YMDHMS:
            {
                [_dataArray addObject:self.yearArray];
                [_dataArray addObject:self.monthArray];
                [_dataArray addObject:self.dayArray];
                [_dataArray addObject:self.hoursArray];
                [_dataArray addObject:self.minutesArray];
                [_dataArray addObject:self.secondsArray];
            }
                break;
            case KDDPickViewDateType_Custom:
            {
                
            }
                break;
                
            default:
                break;
        }
    }
    return _dataArray;
}
- (NSMutableArray *)yearArray
{
    if (!_yearArray)
    {
        _yearArray = @[].mutableCopy;
        for (NSInteger i = (_startDate ? _startDate.year : 1900); i <= (self.endDate ? self.endDate : 2100); i++)
        {
            NSString *str = [NSString stringWithFormat:@"%04ld年",i];
            [_yearArray addObject:str];
        }
    }
    return _yearArray;
}
- (NSMutableArray *)monthArray
{
    if (!_monthArray)
    {
        _monthArray = @[].mutableCopy;
        for (int i = 1; i < 13; i++)
        {
            NSString *str = [NSString stringWithFormat:@"%02i月",i];
            [_monthArray addObject:str];
        }
    }
    return _monthArray;
}
- (NSMutableArray *)dayArray
{
    if (!_dayArray)
    {
        _dayArray = @[].mutableCopy;
        NSDate *date = _selDate ? _selDate : [NSDate date];
        NSInteger days = [self totaldaysInMonth:date];
        for (int i = 1; i <= days; i++) {
            NSString *str = [NSString stringWithFormat:@"%02i日",i];
            [_dayArray addObject:str];
        }
    }
    
    return _dayArray;
}

- (NSMutableArray *)hoursArray
{
    if (!_hoursArray)
    {
        _hoursArray = @[].mutableCopy;
        
        for (int i = 0; i < 24; i++)
        {
            NSString *str = [NSString stringWithFormat:@"%02i时",i];
            [_hoursArray addObject:str];
        }
    }
    return _hoursArray;
}

- (NSMutableArray *)minutesArray
{
    if (!_minutesArray)
    {
        _minutesArray = @[].mutableCopy;
        int minutes = _minutesIsZero ? 1 : 60;
        for (int i = 0; i < minutes; i++)
        {
            NSString *str = [NSString stringWithFormat:@"%02i分",i];
            [_minutesArray addObject:str];
        }
    }
    return _minutesArray;
}

- (NSMutableArray *)secondsArray
{
    if (!_secondsArray)
    {
        _secondsArray = @[].mutableCopy;
        
        for (int i = 0; i < 60; i++)
        {
            NSString *str = [NSString stringWithFormat:@"%02i秒",i];
            [_secondsArray addObject:str];
        }
    }
    return _secondsArray;
}

- (void)selectRow
{
    _resultArray = @[].mutableCopy;
    NSDate *date = _selDate ? _selDate : [NSDate date];
    switch (_dateType) {
        case KDDPickViewDateType_Y:
        {
            [_pickerView selectRow:[self.yearArray indexOfObject:[NSString stringWithFormat:@"%ld年",date.year]] inComponent:0 animated:YES];
            [_resultArray addObject:[NSString stringWithFormat:@"%ld年",date.year]];
        }
            break;
        case KDDPickViewDateType_YM:
        {
            [_pickerView selectRow:[self.yearArray indexOfObject:[NSString stringWithFormat:@"%ld年",date.year]] inComponent:0 animated:YES];
            [_pickerView selectRow:[self.monthArray indexOfObject:[NSString stringWithFormat:@"%02ld月",date.month]] inComponent:1 animated:YES];
            
            [_resultArray addObject:[NSString stringWithFormat:@"%ld年",date.year]];
            [_resultArray addObject:[NSString stringWithFormat:@"%02ld月",date.month]];
        }
            break;
        case KDDPickViewDateType_YMD:
        {
            [_pickerView selectRow:[self.yearArray indexOfObject:[NSString stringWithFormat:@"%ld年",date.year]] inComponent:0 animated:YES];
            [_pickerView selectRow:[self.monthArray indexOfObject:[NSString stringWithFormat:@"%02ld月",date.month]] inComponent:1 animated:YES];
            [_pickerView selectRow:[self.dayArray indexOfObject:[NSString stringWithFormat:@"%02ld日",date.day]] inComponent:2 animated:YES];
            
            [_resultArray addObject:[NSString stringWithFormat:@"%ld年",date.year]];
            [_resultArray addObject:[NSString stringWithFormat:@"%02ld月",date.month]];
            [_resultArray addObject:[NSString stringWithFormat:@"%02ld日",date.day]];
        }
            break;
        case KDDPickViewDateType_YMDH:
        {
            [_pickerView selectRow:[self.yearArray indexOfObject:[NSString stringWithFormat:@"%ld年",date.year]] inComponent:0 animated:YES];
            [_pickerView selectRow:[self.monthArray indexOfObject:[NSString stringWithFormat:@"%02ld月",date.month]] inComponent:1 animated:YES];
            [_pickerView selectRow:[self.dayArray indexOfObject:[NSString stringWithFormat:@"%02ld日",date.day]] inComponent:2 animated:YES];
            [_pickerView selectRow:[self.hoursArray indexOfObject:[NSString stringWithFormat:@"%02ld时",date.hour]] inComponent:3 animated:YES];
            
            [_resultArray addObject:[NSString stringWithFormat:@"%ld年",date.year]];
            [_resultArray addObject:[NSString stringWithFormat:@"%02ld月",date.month]];
            [_resultArray addObject:[NSString stringWithFormat:@"%02ld日",date.day]];
            [_resultArray addObject:[NSString stringWithFormat:@"%02ld时",date.hour]];
        }
            break;
        case KDDPickViewDateType_YMDHM:
        {
            [_pickerView selectRow:[self.yearArray indexOfObject:[NSString stringWithFormat:@"%ld年",date.year]] inComponent:0 animated:YES];
            [_pickerView selectRow:[self.monthArray indexOfObject:[NSString stringWithFormat:@"%02ld月",date.month]] inComponent:1 animated:YES];
            [_pickerView selectRow:[self.dayArray indexOfObject:[NSString stringWithFormat:@"%02ld日",date.day]] inComponent:2 animated:YES];
            [_pickerView selectRow:[self.hoursArray indexOfObject:[NSString stringWithFormat:@"%02ld时",date.hour]] inComponent:3 animated:YES];
            if (!_minutesIsZero) {
               [_pickerView selectRow:[self.minutesArray indexOfObject:[NSString stringWithFormat:@"%02ld分",date.minute]] inComponent:4 animated:YES];
            }
            
            [_resultArray addObject:[NSString stringWithFormat:@"%ld年",date.year]];
            [_resultArray addObject:[NSString stringWithFormat:@"%02ld月",date.month]];
            [_resultArray addObject:[NSString stringWithFormat:@"%02ld日",date.day]];
            [_resultArray addObject:[NSString stringWithFormat:@"%02ld时",date.hour]];
            if (_minutesIsZero) {
                [_resultArray addObject:@"00分"];
            }else{
                [_resultArray addObject:[NSString stringWithFormat:@"%02ld分",date.minute]];
            }
        }
            break;
        case KDDPickViewDateType_YMDHMS:
        {
            [_pickerView selectRow:[self.yearArray indexOfObject:[NSString stringWithFormat:@"%ld年",date.year]] inComponent:0 animated:YES];
            [_pickerView selectRow:[self.monthArray indexOfObject:[NSString stringWithFormat:@"%02ld月",date.month]] inComponent:1 animated:YES];
            [_pickerView selectRow:[self.dayArray indexOfObject:[NSString stringWithFormat:@"%02ld日",date.day]] inComponent:2 animated:YES];
            [_pickerView selectRow:[self.hoursArray indexOfObject:[NSString stringWithFormat:@"%02ld时",date.hour]] inComponent:3 animated:YES];
            [_pickerView selectRow:[self.minutesArray indexOfObject:[NSString stringWithFormat:@"%02ld分",date.minute]] inComponent:4 animated:YES];
            [_pickerView selectRow:[self.secondsArray indexOfObject:[NSString stringWithFormat:@"%02ld秒",date.second]] inComponent:5 animated:YES];
            
            [_resultArray addObject:[NSString stringWithFormat:@"%ld年",date.year]];
            [_resultArray addObject:[NSString stringWithFormat:@"%02ld月",date.month]];
            [_resultArray addObject:[NSString stringWithFormat:@"%02ld日",date.day]];
            [_resultArray addObject:[NSString stringWithFormat:@"%02ld时",date.hour]];
            [_resultArray addObject:[NSString stringWithFormat:@"%02ld分",date.minute]];
            [_resultArray addObject:[NSString stringWithFormat:@"%02ld秒",date.second]];
        }
            break;
            case KDDPickViewDateType_Custom:
        {
            for (NSArray *arr in self.dataArray) {
                for (int i = 0; i < 1; i++) {
                    [_resultArray addObject:arr[i]];
                }
            }
        }
            break;
            
        default:
            break;
    }
    
    self.resultStr = @"";
    for (NSString *str in self.resultArray) {
        self.resultStr = [self.resultStr stringByAppendingString:str];
    }
}

#pragma mark -Label的大小
CGSize stringSize(NSString *text, CGSize limitSize, CGFloat fontSize)
{
    CGSize labelSize;
    if (text.length == 0) {
        return CGSizeZero;
    }
    labelSize =[text boundingRectWithSize:limitSize
                                  options:NSStringDrawingTruncatesLastVisibleLine
                | NSStringDrawingUsesLineFragmentOrigin
                | NSStringDrawingUsesFontLeading
                               attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]}
                                  context:nil].size;
    return labelSize;
}

@end
