//
//  UIButton+SetEdge.h
//  CandyShine
//
//  Created by huangfulei on 14-1-20.
//  Copyright (c) 2014年 CandyWearables. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (SetEdge)

- (void)setEdgeWithTop:(int)top Bottom:(int)bottom;
- (void)setEdgeWithLeft:(int)left Space:(int)space;
- (void)setEdgeCenterWithSpace:(int)space;

@end
