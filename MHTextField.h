//
//  MHTextField.h
//  CandyShine
//
//  Created by huangfulei on 14-2-18.
//  Copyright (c) 2014年 CandyWearables. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MHTextField;

@protocol MHTextFieldDelegate <NSObject>

@required
- (MHTextField*) textFieldAtIndex:(int)index;
- (int) numberOfTextFields;

@end

@interface MHTextField : UITextField

@property (nonatomic) BOOL required;
@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, setter = setDateField:) BOOL isDateField;
@property (nonatomic, setter = setEmailField:) BOOL isEmailField;

@property (nonatomic, assign) id<MHTextFieldDelegate> textFieldDelegate;

- (BOOL) validate;

@end