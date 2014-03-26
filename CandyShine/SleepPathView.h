//
//  SleepPathView.h
//  CandyShine
//
//  Created by huangfulei on 14-2-13.
//  Copyright (c) 2014年 CandyWearables. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SleepPathView : UIView


@property (nonatomic, retain) IBOutlet UILabel *timeLB1;
@property (nonatomic, retain) IBOutlet UILabel *timeLB2;
@property (nonatomic, retain) IBOutlet UILabel *timeLB3;
@property (nonatomic, retain) IBOutlet UILabel *timeLB4;
@property (nonatomic, retain) IBOutlet UILabel *timeLB5;

@property (nonatomic, retain) NSArray *sleepDataArray;

@property (nonatomic, assign) NSInteger sleepPosition;

@property (nonatomic, assign) NSInteger sleepEndPosition;

@property (nonatomic, retain) NSDate *fromeDate;

@property (nonatomic, retain) NSDate *toDate;

- (void)refresh;

@end
