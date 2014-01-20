//
//  UIXib.h
//  CandyShine
//
//  Created by huangfulei on 14-1-20.
//  Copyright (c) 2014年 CandyWearables. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIXib : NSObject

+ (id)viewWithXib:(NSString *)xib;

+ (id)cellWithXib:(NSString *)xib style:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
