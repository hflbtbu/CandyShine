//
//  MenuView.m
//  CandyShine
//
//  Created by huangfulei on 14-1-23.
//  Copyright (c) 2014年 CandyWearables. All rights reserved.
//

#import "MenuView.h"

#define MenuViewArrowHeight 0

#define MenuViewMoveImageGap 40

@interface MenuView ()
{
    UIImageView *_movedImage;
}
@end

@implementation MenuView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIImageView *bg = [[UIImageView alloc] initWithFrame:self.bounds];
        bg.image = [UIImage imageNamed:@"menuviewbg"];
        [self addSubview:bg];

        UILabel *menuLB1  = [[UILabel alloc] initWithFrame:CGRectMake(0, MenuViewArrowHeight, self.width, (self.height - MenuViewArrowHeight)/2)];
        menuLB1.textAlignment = NSTextAlignmentCenter;
        menuLB1.text = @"日视图";
        menuLB1.backgroundColor = [UIColor orangeColor];
        [self addSubview:menuLB1];
        
        UILabel *menuLB2  = [[UILabel alloc] initWithFrame:CGRectMake(0, MenuViewArrowHeight + (self.height - MenuViewArrowHeight)/2, self.width, (self.height - MenuViewArrowHeight)/2)];
        menuLB2.textAlignment = NSTextAlignmentCenter;
        [self addSubview:menuLB2];
        menuLB2.text = @"周视图";
        menuLB2.backgroundColor = [UIColor grayColor];
        
        _movedImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
        _movedImage.center = CGPointMake(self.width - MenuViewMoveImageGap, MenuViewArrowHeight + (self.height - MenuViewArrowHeight)/4);
        
        UITapGestureRecognizer *_tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(receiveTapGestureRecognizer:)];
        [self addGestureRecognizer:_tapGestureRecognizer];
        
        self.backgroundColor = [UIColor orangeColor];
    }
    return self;
}

- (void)receiveTapGestureRecognizer:(UITapGestureRecognizer *)recognizer {
        CGPoint touchPoint = [recognizer locationInView:self];
    if (touchPoint.y > MenuViewArrowHeight && touchPoint.y < MenuViewArrowHeight + (self.height - MenuViewArrowHeight)/2) {
        _movedImage.center = _movedImage.center = CGPointMake(self.width - MenuViewMoveImageGap, MenuViewArrowHeight + (self.height - MenuViewArrowHeight)/4);
        [_delegate menuViewDidSelectedDataPattern:DataPatternDay];
    } else {
        _movedImage.center = CGPointMake(self.width - MenuViewMoveImageGap, MenuViewArrowHeight + (self.height - MenuViewArrowHeight)*1.5);
        [_delegate menuViewDidSelectedDataPattern:DataPatternWeek];
    }
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
