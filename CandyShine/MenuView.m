//
//  MenuView.m
//  CandyShine
//
//  Created by huangfulei on 14-1-23.
//  Copyright (c) 2014年 CandyWearables. All rights reserved.
//

#import "MenuView.h"

#define MenuViewArrowHeight 7

#define MenuViewMoveImageGap 50

@interface MenuView ()
{
    UIImageView *_movedImage;
    
    DataPattern _currentPattern;
}
@end

@implementation MenuView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _currentPattern = DataPatternDay;
        
        UIImageView *bg = [[UIImageView alloc] initWithFrame:self.bounds];
        bg.image = [UIImage imageNamed:@"menu_bg"];
        [self addSubview:bg];

        UILabel *menuLB1  = [[UILabel alloc] initWithFrame:CGRectMake(0, MenuViewArrowHeight, self.width, (self.height - MenuViewArrowHeight)/2)];
        menuLB1.textAlignment = NSTextAlignmentCenter;
        menuLB1.text = @"日视图";
        menuLB1.font = kContentFont1;
        menuLB1.textColor = kContentNormalColor;
        menuLB1.backgroundColor = [UIColor clearColor];
        [self addSubview:menuLB1];
        
        UILabel *menuLB2  = [[UILabel alloc] initWithFrame:CGRectMake(0, MenuViewArrowHeight + (self.height - MenuViewArrowHeight)/2 - 6, self.width, (self.height - MenuViewArrowHeight)/2)];
        menuLB2.textAlignment = NSTextAlignmentCenter;
        [self addSubview:menuLB2];
        menuLB2.text = @"周视图";
        menuLB2.font = kContentFont1;
        menuLB2.textColor = kContentNormalColor;
        menuLB2.backgroundColor = [UIColor clearColor];
        
        _movedImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"menu_selected"]];
        _movedImage.center = CGPointMake(MenuViewMoveImageGap, MenuViewArrowHeight + (self.height - MenuViewArrowHeight)/4 );
        [self addSubview:_movedImage];
        
        UITapGestureRecognizer *_tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(receiveTapGestureRecognizer:)];
        [self addGestureRecognizer:_tapGestureRecognizer];
    }
    return self;
}

- (void)receiveTapGestureRecognizer:(UITapGestureRecognizer *)recognizer {
        CGPoint touchPoint = [recognizer locationInView:self];
    if (touchPoint.y > MenuViewArrowHeight && touchPoint.y < MenuViewArrowHeight + (self.height - MenuViewArrowHeight)/2) {
        if (_currentPattern != DataPatternDay) {
            _currentPattern = DataPatternDay;
            [UIView animateWithDuration:0.15 animations:^{
                _movedImage.center = _movedImage.center = CGPointMake(MenuViewMoveImageGap, MenuViewArrowHeight + (self.height - MenuViewArrowHeight)/4);
            } completion:^(BOOL finished) {
                [_delegate menuViewDidSelectedDataPattern:DataPatternDay];
            }];
        } else {
            self.hidden = YES;
        }
    } else {
        if (_currentPattern != DataPatternWeek) {
            _currentPattern = DataPatternWeek;
            [UIView animateWithDuration:0.15 animations:^{
                _movedImage.center =  CGPointMake(MenuViewMoveImageGap, MenuViewArrowHeight + (self.height - MenuViewArrowHeight)*0.75 - 6);
            } completion:^(BOOL finished) {
                [_delegate menuViewDidSelectedDataPattern:DataPatternWeek];
            }];
        } else {
            self.hidden = YES;
        }
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
