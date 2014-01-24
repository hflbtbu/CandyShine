//
//  MenuView.h
//  CandyShine
//
//  Created by huangfulei on 14-1-23.
//  Copyright (c) 2014年 CandyWearables. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MenuViewDelegate <NSObject>

- (void)menuViewDidSelectedDataPattern:(DataPattern)dataPattern;

@end

@interface MenuView : UIView

@property (nonatomic, assign) id<MenuViewDelegate> delegate;

@end
