//
//  UIBezierPath+Smoothing.h
//  CandyShine
//
//  Created by huangfulei on 14-1-21.
//  Copyright (c) 2014年 CandyWearables. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBezierPath (Smoothing)

- (UIBezierPath*)smoothedPathWithGranularity:(NSInteger)granularity minY:(CGFloat)minY maxY:(CGFloat)maxY;

@end
