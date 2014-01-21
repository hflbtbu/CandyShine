//
//  DragView.h
//  CandyShine
//
//  Created by huangfulei on 14-1-21.
//  Copyright (c) 2014年 CandyWearables. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DragView : UIView

@property (nonatomic, assign)CGFloat fromPointY;
@property (nonatomic, assign)CGFloat toPointY;

- (id)initWithFrame:(CGRect)frame fromPointY:(CGFloat)fromPointY toPointY:(CGFloat)toPointY;

@end
