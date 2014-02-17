//
//  PickerView.m
//  CandyShine
//
//  Created by huangfulei on 14-2-17.
//  Copyright (c) 2014年 CandyWearables. All rights reserved.
//

#define kShadeViewTag 9999

#import "PickerView.h"

@interface  PickerView () <UIPickerViewDelegate, UIPickerViewDataSource>
{
    UIPickerView *_pickerView;
    UIDatePicker *_datePicker;
    
    NSInteger _heightInt;
    NSInteger _heightFloat;
    
    NSInteger _weightInt;
    NSInteger _weightFloat;
    
    NSInteger _year;
    NSInteger _month;
    NSInteger _day;
    NSInteger _hour;
    NSInteger _minute;


    
}
@end

@implementation PickerView

- (id)initWithFrame:(CGRect)frame :(PickerViewType)pickerViewType {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _pickerViewType = pickerViewType;
        
        if (_pickerViewType == PickerViewHeight || _pickerViewType == PickerViewWeight) {
            _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, self.width, 216)];
            _pickerView.dataSource = self;
            _pickerView.delegate = self;
            [self addSubview:_pickerView];
        } else {
            _datePicker =[[UIDatePicker alloc] initWithFrame:CGRectMake(0, 44, self.width, 216)];
            _datePicker.timeZone = [NSTimeZone defaultTimeZone];
            _datePicker.datePickerMode = _pickerViewType == PickerViewTime ? UIDatePickerModeTime:UIDatePickerModeDate;
            //[_datePicker addTarget:self action:@selector(datePickerSelectedHander) forControlEvents:UIControlEventValueChanged];
            [self addSubview:_datePicker];
        }
        
        
        //创建工具栏
        NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:3];
        UIBarButtonItem *confirmBtn = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(pickerSelectedHander)];
        UIBarButtonItem *flexibleSpaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(hide)];
        [items addObject:cancelBtn];
        [items addObject:flexibleSpaceItem];
        [items addObject:confirmBtn];
        UIToolbar *toolVBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.width, 44)];
        toolVBar.items = items;
        [self addSubview:toolVBar];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;

}


- (void)pickerSelectedHander {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
    if (_pickerViewType == PickerViewWeight) {
        [dic setObject:[NSNumber numberWithFloat:_weightInt*1.0 + _weightFloat*0.1] forKey:kPickerWeight];
    } else if (_pickerViewType == PickerViewHeight) {
        [dic setObject:[NSNumber numberWithFloat:_heightInt + _heightFloat*0.1] forKey:kPickerHeight];
    } else {
        unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;
        NSDateComponents *components = [[NSCalendar currentCalendar] components:flags fromDate:[_datePicker date]];
        if (_pickerViewType == PickerViewBirthday) {
            [dic setObject:[NSNumber numberWithInteger:[components year]]forKey:kPickerYear];
            [dic setObject:[NSNumber numberWithInteger:[components month]]forKey:kPickerMonth];
            [dic setObject:[NSNumber numberWithInteger:[components day]]forKey:kPickerDay];
        } else {
            [dic setObject:[NSNumber numberWithInteger:[components hour]]forKey:kPickerHuor];
            [dic setObject:[NSNumber numberWithInteger:[components minute]]forKey:kPickerMinute];
        }
        
    }
    [_delegate pickerViewDidSelectedWithVlaue:dic];
}

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (_pickerViewType == PickerViewTime) {
        return 2;
    } else if (_pickerViewType == PickerViewHeight || _pickerViewType == PickerViewWeight) {
        return 3;
    }
    return 0;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (_pickerViewType == PickerViewTime) {
        if (component == 0) {
            return 24;
        }
        return 60;
    } else if (_pickerViewType == PickerViewHeight) {
        if (component == 0) {
            return 3;
        } else if (component == 1) {
            return 10;
        }
        return 1;
    } else if (_pickerViewType == PickerViewWeight) {
        if (component == 0) {
            return 161;
        } else if (component == 1) {
            return 10;
        }
        return 1;
    }
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (_pickerViewType == PickerViewHeight) {
        if (component == 0) {
            return [NSString stringWithFormat:@"%d",row];
        } else if (component == 1) {
            return [NSString stringWithFormat:@".%d",row];
        } else {
            return @"米";
        }
    } else if (_pickerViewType == PickerViewTime) {
        if (component == 0) {
            return [NSString stringWithFormat:@"%02d",row];
        } else {
            return [NSString stringWithFormat:@"%02d",row];
        }
    } else if (_pickerViewType == PickerViewWeight) {
        if (component == 0) {
            return [NSString stringWithFormat:@"%d",row + 40];
        } else if (component == 1) {
            return [NSString stringWithFormat:@".%d",row];
        } else {
            return @"公斤";
        }
    }

    return @"helo";
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (_pickerViewType == PickerViewHeight) {
        if (component == 0) {
            _heightInt = row;
        } else {
            _heightFloat = row;
        }
    } else if (_pickerViewType == PickerViewWeight) {
        if (component == 0) {
            _weightInt = row + 40;
        } else {
            _weightFloat = row;
        }
    }
}

- (void)show {
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    UIView *shade = [[UIView alloc] initWithFrame:keyWindow.bounds];
    shade.tag = kShadeViewTag;
    shade.backgroundColor = [UIColor blackColor];
    shade.alpha = 0;
    [keyWindow addSubview:shade];
    [keyWindow addSubview:self];
    self.frame = CGRectMake(0, keyWindow.height, keyWindow.width, 304);
    [UIView animateWithDuration:0.4 animations:^{
        shade.alpha =  0.7;
        self.frame = CGRectMake(0, keyWindow.height - 260, keyWindow.width, 260);
    }];
}

- (void)hide {
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    UIView *shade = [keyWindow viewWithTag:kShadeViewTag];
    [UIView animateWithDuration:0.4 animations:^{
        shade.alpha = 0;
        self.frame = CGRectMake(0, keyWindow.height, keyWindow.width, 260);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [shade removeFromSuperview];
    }];
}






/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
