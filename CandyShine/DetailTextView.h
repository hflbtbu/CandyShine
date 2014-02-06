//
//  DetailTextView.h
//  CandyShine
//
//  Created by huangfulei on 14-2-6.
//  Copyright (c) 2014年 CandyWearables. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailTextView : UILabel

{
    NSMutableAttributedString *resultAttributedString;
}

-(void)setKeyWordTextArray:(NSArray *)keyWordArray WithFont:(UIFont *)font AndColor:(UIColor *)keyWordColor;
-(void)setText:(NSString *)text WithFont:(UIFont *)font AndColor:(UIColor *)color;


@end
