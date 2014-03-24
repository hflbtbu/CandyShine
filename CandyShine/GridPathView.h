//
//  GridPathView.h
//  CandyShine
//
//  Created by huangfulei on 14-1-21.
//  Copyright (c) 2014年 CandyWearables. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GridPathView : UIView

@property (nonatomic, strong) NSArray *valueArray;
@property (nonatomic, assign) DataPattern currentPattern;
@property (nonatomic, assign) BOOL isToday;

- (void)refresh;

@end
