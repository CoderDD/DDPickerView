# DDPickerView

日期选择器
```
需求:展示多种格式的时间
年,
年月,
年月日,
年月日时,
年月日时分,
年月日时分秒,
展示自定义数据
```

如何使用
```
[DDPickView pickerViewWithFrame:self.view.bounds andType:KDDPickViewDateType_YMDHM configuration:^(DDPickView *pickView) {
        
    } resultBlock:^(NSArray *resultArray,BOOL isCancel) {
        NSLog(@"%@",resultArray);
    }];
```
