//
//  rere.m
//  CandyShine
//
//  Created by huangfulei on 14-2-20.
//  Copyright (c) 2014年 CandyWearables. All rights reserved.
//

#import "CircleImageView.h"

@implementation CircleImageView

- (id)initWithFrame:(CGRect)frame image:(NSString *)image
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        CAShapeLayer *circleLine = [CAShapeLayer layer];
        circleLine.frame  = CGRectMake(0, 0, self.width, self.height);
        circleLine.lineWidth = kCircleImageViewLineWidth;
        circleLine.strokeColor = [kContentHighlightColor CGColor];
        circleLine.fillColor = [[UIColor whiteColor] CGColor];
        UIBezierPath *circlePath = [UIBezierPath bezierPath];
        [circlePath addArcWithCenter:CGPointMake(self.width/2, self.height/2) radius:MIN(self.width, self.height)/2 - kCircleImageViewLineWidth/2 startAngle:0 endAngle:M_PI*2 clockwise:YES];
        circleLine.path = [circlePath CGPath];
        [self.layer addSublayer:circleLine];
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake((kCircleImageViewLineWidth + kCircleImageViewLineCap), (kCircleImageViewLineWidth + kCircleImageViewLineCap), self.width - 2*(kCircleImageViewLineWidth + kCircleImageViewLineCap), self.height - 2*(kCircleImageViewLineWidth + kCircleImageViewLineCap))];
        _imageView.layer.cornerRadius =self.width/2 - (kCircleImageViewLineWidth + kCircleImageViewLineCap);
        _imageView.layer.masksToBounds = YES;
        _imageView.image = [UIImage imageNamed:image];

        
        [self addSubview:_imageView];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)layoutSubviews {
//    [super layoutSubviews];
//    UIImage *image = _imageView.image;
//    if (image.size.width < _imageView.width) {
//        _imageView.frame = CGRectMake((self.width - image.size.width)/2, (self.height - image.size.height)/2, image.size.width, image.size.height);
//        _imageView.layer.cornerRadius = image.size.width/2;
//    }

}

@end
