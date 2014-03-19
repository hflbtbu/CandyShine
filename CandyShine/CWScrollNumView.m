//
//  CWScrollNumView.m
//  CandyShine
//
//  Created by huangfulei on 14-2-22.
//  Copyright (c) 2014年 CandyWearables. All rights reserved.
//

#define kSpaceBetweenDigitView  5

#import "CWScrollNumView.h"

@interface CWScrollDigitView ()
{
    CGFloat _oneNumberHeightl;
    UILabel *_numberLB;
    NSInteger _count;
}

@end

@implementation CWScrollDigitView

- (id)initWithFrame:(CGRect)frame :(BOOL)isScrolled
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        CGSize size = [@"8" sizeWithFont:[UIFont systemFontOfSize:40]];
        _oneNumberHeightl = size.height;
        _numberLB = [[UILabel alloc] initWithFrame:CGRectMake(0, isScrolled? -_oneNumberHeightl*10 : 0, size.width, isScrolled? _oneNumberHeightl*21 : _oneNumberHeightl)];
        _numberLB.numberOfLines = isScrolled ?  21 : 1;
        _numberLB.font = [UIFont systemFontOfSize:40];
        _numberLB.backgroundColor = [UIColor blackColor];
        _numberLB.text = isScrolled ? @"0\n9\n8\n7\n6\n5\n4\n3\n2\n1\n0\n1\n2\n3\n4\n5\n6\n7\n8\n9\n0" : @"0";
        _numberLB.backgroundColor = [UIColor clearColor];
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake((self.width - size.width)/2, (self.height - size.height)/2, size.width, size.height)];
        view.clipsToBounds = YES;
        [view addSubview:_numberLB];
        
        _count = 0;
        
        [self addSubview:view];
    }
    return self;
}

- (void)add {
    [UIView animateWithDuration:0.04 animations:^{
        _numberLB.y += _oneNumberHeightl;
    } completion:^(BOOL finished) {
        if (_count < 10) {
            [_delegate scrollDigitViewCurrentNumber:_count];
            _count++;
            [self performSelector:@selector(add)];
        } else {
            _count = 0;
            _numberLB.y = -_oneNumberHeightl*10;
        }
    }];
}

- (void)plus {
    [UIView animateWithDuration:0.04 animations:^{
        _numberLB.y -= _oneNumberHeightl;
    } completion:^(BOOL finished) {
        if (_count < 10) {
            [_delegate scrollDigitViewCurrentNumber:_count];
            _count++;
            [self performSelector:@selector(add)];
        } else {
            _count = 0;
            _numberLB.y = -_oneNumberHeightl*10;
        }
    }];

}

- (void)setNumber:(NSInteger)number {
    _number = number;
    _numberLB.text = [NSString stringWithFormat:@"%d",_number];
}

@end

@interface CWScrollNumView () <CWScrollDigitViewDelegate>
{
    CWScrollDigitView *_digitView0;
    CWScrollDigitView *_digitView1;
    CWScrollDigitView *_digitView2;
    CWScrollDigitView *_digitView3;
    
    BOOL _isAdd;
}
@end

@implementation CWScrollNumView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)awakeFromNib {
    CGFloat width = (self.width - 3*kSpaceBetweenDigitView)/4;
    CGRect frame = CGRectMake(3*(width + kSpaceBetweenDigitView), 0, width, self.height);
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"intro_bg_number"]];
    image.frame = frame;
    [self addSubview:image];
    _digitView0 = [[CWScrollDigitView alloc] initWithFrame:frame :YES];
    _digitView0.delegate = self;
    [self addSubview:_digitView0];
    
    frame =CGRectMake(2*(width + kSpaceBetweenDigitView), 0, width, self.height);
    image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"intro_bg_number"]];
    image.frame = frame;
    [self addSubview:image];
    _digitView1 = [[CWScrollDigitView alloc] initWithFrame:frame :NO];
    [self addSubview:_digitView1];
    
    frame =CGRectMake(width + kSpaceBetweenDigitView, 0, width, self.height);
    image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"intro_bg_number"]];
    image.frame = frame;
    [self addSubview:image];
    _digitView2 = [[CWScrollDigitView alloc] initWithFrame:frame :NO];
    [self addSubview:_digitView2];
    
    frame =CGRectMake(0, 0, width, self.height);
    image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"intro_bg_number"]];
    image.frame = frame;
    [self addSubview:image];
    _digitView3 = [[CWScrollDigitView alloc] initWithFrame:frame :NO];
    [self addSubview:_digitView3];
    
}


- (void)scrollDigitViewCurrentNumber:(NSInteger)number {
    if (number >= 9 ) {
        [_digitView1 setNumber:0];
        _number += _isAdd ? 100 : -100;
        [self refreshNumbrLB];
    } else {
        [_digitView1 setNumber:number+1];
    }
}

- (void)refreshNumbrLB {
    NSInteger number3 = _number/1000;
    NSInteger number2 = (_number - number3*1000)/100;
    [_digitView2 setNumber:number2];
    [_digitView3 setNumber:number3];
}

- (void)setNumber:(NSInteger)number {
    _number = number;
    [self refreshNumbrLB];
}

- (void)add {
    if (_number < 9800) {
        _isAdd = YES;
        [_digitView0 add];
    }
}

- (void)plus {
    if (_number > 200) {
        _isAdd =NO;
        [_digitView0 plus];
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
