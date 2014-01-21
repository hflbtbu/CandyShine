//
//  UINavigationItem+CustomeItem.m
//  CandyShine
//
//  Created by huangfulei on 14-1-20.
//  Copyright (c) 2014年 CandyWearables. All rights reserved.
//

#import "UINavigationItem+CustomeItem.h"

@implementation UINavigationItem (CustomeItem)

- (UIBarButtonItem *)customeBarButtonItemWithImageName:(NSString *)imageName target:(id)target action:(SEL)action {
    UIBarButtonItem *barButtonItem;
    UIImage *image = [UIImage imageNamed:imageName];
//    if (IsIOS7) {
//        barButtonItem = [[UIBarButtonItem alloc] initWithImage:image landscapeImagePhone:nil style:UIBarButtonItemStylePlain target:target action:action];
//    } else {
        CGRect frame = CGRectMake(0, 0, image.size.width, image.size.height);
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = frame;
        [button setImage:image forState:UIControlStateNormal];
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        
        barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        
    //}
    return barButtonItem;
}

- (void)setCustomeLeftBarButtonItem:(NSString *)imageName target:(id)target action:(SEL)action {
    
    self.leftBarButtonItem = [self customeBarButtonItemWithImageName:imageName target:target action:action];
}

@end
