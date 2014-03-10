//
//  NewsCell.h
//  CandyShine
//
//  Created by huangfulei on 14-2-18.
//  Copyright (c) 2014年 CandyWearables. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsCell : UITableViewCell

@property (nonatomic, retain)IBOutlet UILabel *pageLB;
@property (nonatomic, retain)IBOutlet UIImageView *pictureImageView;
@property (nonatomic, retain)IBOutlet UILabel *contentLB;
@property (nonatomic, retain)IBOutlet UILabel *dayLB;
@property (nonatomic, retain)IBOutlet UILabel *motheLB;
@property (nonatomic, retain)IBOutlet UILabel *authorLB;
@property (nonatomic, retain)IBOutlet UIScrollView *scrollView;

@end
