//
//  UIXib.m
//  CandyShine
//
//  Created by huangfulei on 14-1-20.
//  Copyright (c) 2014年 CandyWearables. All rights reserved.
//

#import "UIXib.h"

@implementation UIXib

+ (id)viewWithXib:(NSString *)xib {
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:xib owner:nil options:nil];
    UIView *view = [views objectAtIndex:0];
    view = [view initWithFrame:view.frame];
    return view;
}

+ (id)cellWithXib:(NSString *)xib style:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    NSArray *cells = [[NSBundle mainBundle] loadNibNamed:xib owner:nil options:nil];
    UITableViewCell *cell = [(UITableViewCell *)[cells objectAtIndex:0] initWithStyle:style reuseIdentifier:reuseIdentifier];
    return cell;
}


@end
