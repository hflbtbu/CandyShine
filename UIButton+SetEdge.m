//
//  UIButton+SetEdge.m
//  CandyShine
//
//  Created by huangfulei on 14-1-20.
//  Copyright (c) 2014年 CandyWearables. All rights reserved.
//

#import "UIButton+SetEdge.h"

@implementation UIButton (SetEdge)

- (void)setEdgeWithTop:(int)top Bottom:(int)bottom{
    [self setImageEdgeInsets:UIEdgeInsetsMake(-(self.imageView.frame.origin.y - top)*2, (self.frame.size.width/2 - self.imageView.center.x)*2, 0, 0)];
    [self setTitleEdgeInsets:UIEdgeInsetsMake((self.frame.size.height/2 - self.titleLabel.frame.size.height/2 - bottom)*2, -(self.titleLabel.center.x - self.frame.size.width/2)*2, 0, 0)];
}

- (void)setEdgeWithLeft:(int)left Space:(int)space{
    [self setImageEdgeInsets:UIEdgeInsetsMake(0, -(self.imageView.frame.origin.x - left)*2, 0, 0)];
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -(self.titleLabel.frame.origin.x - (self.imageView.frame.size.width + self.imageView.frame.origin.x) - space)*2, 0, 0)];
}


@end
