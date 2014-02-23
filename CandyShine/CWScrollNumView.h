//
//  CWScrollNumView.h
//  CandyShine
//
//  Created by huangfulei on 14-2-22.
//  Copyright (c) 2014年 CandyWearables. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol CWScrollDigitViewDelegate <NSObject>

- (void)scrollDigitViewCurrentNumber:(NSInteger)number;

@end

@interface CWScrollDigitView : UIView

@property (nonatomic, assign) id<CWScrollDigitViewDelegate> delegate;
@property (nonatomic, assign) NSInteger number;

- (id)initWithFrame:(CGRect)frame :(BOOL)isScrolled;

- (void)add;

- (void)plus;

@end

@interface CWScrollNumView : UIView

@property (nonatomic, assign) NSInteger number;

- (void)add;

- (void)plus;

@end
