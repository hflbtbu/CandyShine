//
//  RegistMHTextField.m
//  CandyShine
//
//  Created by huangfulei on 14-2-18.
//  Copyright (c) 2014年 CandyWearables. All rights reserved.
//

#import "RegistMHTextField.h"

@implementation RegistMHTextField

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setBorderStyle:UITextBorderStyleNone];
    
    //[self setFont: [UIFont systemFontOfSize:17]];
    //[self setTintColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0]];
    [self setBackgroundColor:[UIColor whiteColor]];
}

- (CGRect)textRectForBounds:(CGRect)bounds
{
    return CGRectInset(bounds, 10, 5);
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return CGRectInset(bounds, 10, 5);
}

- (void)layoutSublayersOfLayer:(CALayer *)layer
{
    [super layoutSublayersOfLayer:layer];
    
    [layer setBorderWidth: 0.5];
    [layer setBorderColor: [UIColor colorWithWhite:0.1 alpha:0.2].CGColor];
    
    [layer setCornerRadius:4.0];
    [layer setShadowOpacity:1.0];
    [layer setShadowColor:[UIColor redColor].CGColor];
    [layer setShadowOffset:CGSizeMake(1.0, 1.0)];
}

//- (void) drawPlaceholderInRect:(CGRect)rect {
//    NSDictionary *attributes = @{ NSFontAttributeName: [UIFont systemFontOfSize:12], NSForegroundColorAttributeName : [UIColor colorWithRed:182/255. green:182/255. blue:183/255. alpha:1.0]};
//    [self.placeholder drawInRect:CGRectInset(rect, 5, 5) withAttributes:attributes];
//}

@end
