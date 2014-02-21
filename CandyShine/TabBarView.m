//
//  TabBarView.m
//  CandyShine
//
//  Created by huangfulei on 14-1-20.
//  Copyright (c) 2014年 CandyWearables. All rights reserved.
//

#import "TabBarView.h"

@implementation TabBarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        for (int i = 0; i<5; i++) {
            UIButton *item = [[self subviews] objectAtIndex:i];
            //[item setEdgeWithTop:4 Bottom:1];
            
            
            CGRect fame = item.imageView.frame;
            fame = item.titleLabel.frame;
        }
    }
    return self;
}


- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    int selectedIndex = point.x/64;
    UIButton *item = [[self subviews] objectAtIndex:selectedIndex];
    if (item != _selectedButton) {
        _selectedButton.selected = NO;
        item.selected = YES;
        _selectedButton = item;
    }
    return NO;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
