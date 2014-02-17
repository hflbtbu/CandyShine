//
//  PickerView.h
//  CandyShine
//
//  Created by huangfulei on 14-2-17.
//  Copyright (c) 2014年 CandyWearables. All rights reserved.
//


#define kPickerHeight @"kPickerHeight"
#define kPickerHuor   @"kPickerHuor"
#define kPickerMinute @"kPickerMinute"
#define kPickerYear   @"kPickerYear"
#define kPickerMonth  @"kPickerMonth"
#define kPickerDay    @"kPickerDay"
#define kPickerWeight @"kPickerWeight"


#import <UIKit/UIKit.h>

@protocol PickerViewDelegate <NSObject>

- (void)pickerViewDidSelectedWithVlaue:(NSDictionary *)dic;

@end

@interface PickerView : UIView

@property (nonatomic, assign) PickerViewType pickerViewType;
@property (nonatomic, assign) id<PickerViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame :(PickerViewType)pickerViewType;

- (void)show;

- (void)hide;

@end
