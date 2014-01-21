//
//  DragView.m
//  CandyShine
//
//  Created by huangfulei on 14-1-21.
//  Copyright (c) 2014年 CandyWearables. All rights reserved.
//

#import "DragView.h"

@interface DragView ()
{
    CGFloat _prePointY;
    CGFloat _offset1;
    CGFloat _offset2;
    CGFloat _offset3;
}
@end


@implementation DragView

- (id)initWithFrame:(CGRect)frame fromPointY:(CGFloat)fromPointY toPointY:(CGFloat)toPointY {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _fromPointY = fromPointY;
        _toPointY = toPointY;
        _prePointY = frame.origin.y;
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(receivePanGestureRecognizer:)];
        [self addGestureRecognizer:panGestureRecognizer];
    }
    return self;
}

- (void)receivePanGestureRecognizer:(UIPanGestureRecognizer *)recognizer {
    CGPoint touchPoint = [recognizer locationInView:KEY_WINDOW];
    CGFloat offset = touchPoint.y - _prePointY;
    _prePointY = touchPoint.y;
    
    _offset1 = _offset2;
    _offset2 = _offset3;
    _offset3 = offset;
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        
    } else if (recognizer.state == UIGestureRecognizerStateEnded){
        if ((_toPointY<=self.y && self.y <=_toPointY + 20) ||  ((self.y > _toPointY +20 && self.y < _fromPointY - 20) && ((_offset1 + _offset2 + _offset3) < 0)) ) {
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.y = _toPointY;
            } completion:^(BOOL finished) {
                
            }];
        } else if ((self.y >=_fromPointY - 20) || ((self.y > _toPointY +20 && self.y < _fromPointY - 20) && ((_offset1 + _offset2 + _offset3) > 0))) {
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.y = _fromPointY;
            } completion:^(BOOL finished) {
                
            }];
        }
    } else if (recognizer.state == UIGestureRecognizerStateCancelled){
        
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGFloat y = self.y + offset;
       y = y<_toPointY ? _toPointY : y;
        self.y = y;
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
