//
//  VerticalLabel.h
//  CandyShine
//
//  Created by huangfulei on 14-2-19.
//  Copyright (c) 2014年 CandyWearables. All rights reserved.
//

typedef enum
{
    VerticalAlignmentTop = 0, // default
    VerticalAlignmentMiddle,
    VerticalAlignmentBottom,
} VerticalAlignment;

#import <UIKit/UIKit.h>

@interface VerticalLabel : UILabel
{
    VerticalAlignment _verticalAlignment;
}

@property (nonatomic, assign) VerticalAlignment verticalAlignment;

@end
