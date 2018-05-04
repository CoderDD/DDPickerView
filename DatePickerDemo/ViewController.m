//
//  ViewController.m
//  DatePickerDemo
//
//  Created by wdc on 2018/2/26.
//  Copyright © 2018年 dd. All rights reserved.
//

#import "ViewController.h"
#import "DDPickView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)YMDHMS:(UIButton *)sender {
    [DDPickView pickerViewWithFrame:self.view.bounds andType:KDDPickViewDateType_YMDHMS configuration:^(DDPickView *pickView) {
        
    } resultBlock:^(NSArray *resultArray,BOOL isCancel) {
        NSLog(@"%@",resultArray);
    }];
}
- (IBAction)YMDHM:(UIButton *)sender {
    [DDPickView pickerViewWithFrame:self.view.bounds andType:KDDPickViewDateType_YMDHM configuration:^(DDPickView *pickView) {
        
    } resultBlock:^(NSArray *resultArray,BOOL isCancel) {
        NSLog(@"%@",resultArray);
    }];
}
- (IBAction)YMDH:(UIButton *)sender {
    [DDPickView pickerViewWithFrame:self.view.bounds andType:KDDPickViewDateType_YMDH configuration:^(DDPickView *pickView) {
        
    } resultBlock:^(NSArray *resultArray,BOOL isCancel) {
        NSLog(@"%@",resultArray);
    }];
}
- (IBAction)YMD:(UIButton *)sender {
    [DDPickView pickerViewWithFrame:self.view.bounds andType:KDDPickViewDateType_YMD configuration:^(DDPickView *pickView) {
        
    } resultBlock:^(NSArray *resultArray,BOOL isCancel) {
        NSLog(@"%@",resultArray);
    }];
}
- (IBAction)YM:(UIButton *)sender {
    [DDPickView pickerViewWithFrame:self.view.bounds andType:KDDPickViewDateType_YM configuration:^(DDPickView *pickView) {
        
    } resultBlock:^(NSArray *resultArray,BOOL isCancel) {
        NSLog(@"%@",resultArray);
    }];
}
- (IBAction)Y:(UIButton *)sender {
    [DDPickView pickerViewWithFrame:self.view.bounds andType:KDDPickViewDateType_Y configuration:^(DDPickView *pickView) {
        
    } resultBlock:^(NSArray *resultArray,BOOL isCancel) {
        NSLog(@"%@",resultArray);
    }];
}
- (IBAction)CUSTOM:(UIButton *)sender {
    NSMutableArray *arr = @[@[@"男",@"女"],@[@"18",@"23",@"28"],@[@"中国大陆",@"香港",@"台湾"]].mutableCopy;
    [DDPickView pickerViewWithFrame:self.view.bounds andType:KDDPickViewDateType_Custom dataArray:arr configuration:^(DDPickView *pickView) {
        
    } resultBlock:^(NSArray *resultArray,BOOL isCancel) {
        NSLog(@"%@",resultArray);
    }];
}

@end
