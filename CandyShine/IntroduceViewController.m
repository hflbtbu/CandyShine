//
//  IntroduceViewController.m
//  CandyShine
//
//  Created by huangfulei on 14-3-15.
//  Copyright (c) 2014年 CandyWearables. All rights reserved.
//

#define  IntorViewTag       10000
#define  IntorMaleViewTag   1
#define  IntorfemaleViewTag 2
#define  IntorAnimationTime 0.3

#import "IntroduceViewController.h"
#import "SportSetViewController.h"

@interface IntroduceViewController () <UIScrollViewDelegate>
{
    SportSetViewController *_goalVC;
    DetailTextView *_heightLB;
    DetailTextView *_weightLB;
    
    UIScrollView *_heightScrollView;
    UIScrollView *_weightScrollView;
    
    IBOutlet UIButton *_nextButton;
    IBOutlet UIButton *_preButton;
}

@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) CGFloat offsetY;

@end

@implementation IntroduceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.currentPage = 0;
}

- (CGFloat)offsetY {
    if (IsIOS7) {
        return 20;
    } else {
        return 0;
    }
}

- (void)setCurrentPage:(NSInteger)currentPage {
    _currentPage = currentPage;
    for (UIView *view in [self.view subviews]) {
        if (view.tag >= IntorViewTag) {
            [UIView animateWithDuration:IntorAnimationTime animations:^{
                view.alpha = 0.0;
            } completion:^(BOOL finished) {
                [view removeFromSuperview];
            }];
        }
    }
    
    switch (_currentPage) {
        case 0:
            _preButton.hidden = YES;
            _nextButton.hidden = YES;
            [self addchoiceSexView];
            break;
        case 1:
            _preButton.hidden = NO;
            _nextButton.hidden = NO;
            [self addHeightView];
            break;
        case 2:
            [_nextButton setTitle:@"下一页" forState:UIControlStateNormal];
            [self addWeightView];
            break;
        case 3:
            [_nextButton setTitle:@"完成" forState:UIControlStateNormal];
            [self addGoalView];
            break;
        default:
            break;
    }
    
    for (UIView *view in [self.view subviews]) {
        if (view.tag >= IntorViewTag) {
            [UIView animateWithDuration:IntorAnimationTime animations:^{
                view.alpha = 1.0;
            } completion:^(BOOL finished) {
            }];
        }
    }

}

- (IBAction)prePageButtonClickedHander:(UIButton *)sender {
    if (self.currentPage > 0) {
        self.currentPage -= 1;
    }
}
- (IBAction)nextPageButtonClickedHander:(UIButton *)sender {
    if (self.currentPage < 3) {
        self.currentPage+= 1;
    } else {
        if ([_delegate respondsToSelector:@selector(introduceViewDidFinish)]) {
            [_delegate introduceViewDidFinish];
        }

//        [UIView animateWithDuration:IntorAnimationTime animations:^{
//            self.view.alpha = 0.0;
//        } completion:^(BOOL finished) {
//            if ([_delegate respondsToSelector:@selector(introduceViewDidFinish)]) {
//                [_delegate introduceViewDidFinish];
//            }
//        }];
    }
}

- (void)addchoiceSexView {
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:18];
    label.textColor = kContentNormalColor;
    label.text = @"个人资料";
    CGSize size = [label.text sizeWithFont:label.font];
    label.frame = CGRectMake((self.view.width - size.width)/2, 15 + self.offsetY, size.width, size.height);
    label.tag = IntorViewTag;
    label.alpha = 0.0;
    [self.view addSubview:label];
    
    label = [[UILabel alloc] init];
    label.textColor = kContentNormalColor;
    label.font = [UIFont systemFontOfSize:14];
    label.text = @"输入你的资料设定运动目标";
    size = [label.text sizeWithFont:label.font];
    label.frame = CGRectMake((self.view.width - size.width)/2, 41 + self.offsetY, size.width, size.height);
    label.tag = IntorViewTag;
    label.alpha = 0.0;
    [self.view addSubview:label];
    
    UIButton *maleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *bgImage = [UIImage imageNamed:@"intro_sex_male"];
    maleButton.frame = CGRectMake((self.view.width - bgImage.size.width)/2, 91 + self.offsetY, bgImage.size.width, bgImage.size.height);
    [maleButton setBackgroundImage:bgImage forState:UIControlStateNormal];
    maleButton.tag = IntorViewTag + IntorMaleViewTag;
    maleButton.alpha = 0.0;
    [maleButton addTarget:self action:@selector(sexButtonClickedHander:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:maleButton];
    
    UIButton *femaleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    bgImage = [UIImage imageNamed:@"intro_sex_female"];
    femaleButton.frame = CGRectMake((self.view.width - bgImage.size.width)/2, 271 + self.offsetY, bgImage.size.width, bgImage.size.height);
    [femaleButton setBackgroundImage:bgImage forState:UIControlStateNormal];
    femaleButton.tag = IntorViewTag + IntorfemaleViewTag;
    femaleButton.alpha = 0.0;
    [femaleButton addTarget:self action:@selector(sexButtonClickedHander:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:femaleButton];
}

- (void)sexButtonClickedHander:(UIButton *)sender {
    self.currentPage++;
    if (sender.tag == IntorfemaleViewTag + IntorViewTag) {
        NSLog(@"sdfs");
    } else {
        
    }
}

- (void)addHeightView {
    UIImage *image = [UIImage imageNamed:@"intro_male"];
    UIImageView *peopleImagView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 31 + self.offsetY, image.size.width, image.size.height)];
    peopleImagView.image = image;
    peopleImagView.alpha = 0.0;
    peopleImagView.tag = IntorViewTag;
    [self.view addSubview:peopleImagView];
    
    image  = [UIImage imageNamed:@"intro_height"];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    imageView.image = image;
    _heightScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(self.view.width - image.size.width - 48, 31 + self.offsetY, image.size.width,300)];
    _heightScrollView.contentSize = CGSizeMake(image.size.width, image.size.height + 161.5);
    _heightScrollView.showsHorizontalScrollIndicator = NO;
    _heightScrollView.showsVerticalScrollIndicator = NO;
    _heightScrollView.delegate = self;
    [_heightScrollView addSubview:imageView];
    _heightScrollView.tag = IntorViewTag;
    _heightScrollView.alpha = 0.0;
    [self.view addSubview:_heightScrollView];
    
    CGFloat height = [[NSUserDefaults standardUserDefaults] floatForKey:kUserHeight];
    if (height == 0) {
        height = 1.70;
    }
    CGFloat offsetY = (2.30 - height)*800;
    CGPoint offset = CGPointMake(0, offsetY);
    _heightScrollView.contentOffset = offset;
    
    image = [UIImage imageNamed:@"intro_height_line"];
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(_heightScrollView.width + _heightScrollView.x - image.size.width/2, _heightScrollView.y + 68, image.size.width, image.size.height)];
    imageView.image = image;
    imageView.tag = IntorViewTag;
    imageView.alpha = 0.0;
    [self.view addSubview:imageView];
    
    _heightLB = [[DetailTextView alloc] initWithFrame:CGRectMake((self.view.width - 100)/2, 350 + self.offsetY , 100, 40)]
    ;
    NSString *str = [NSString stringWithFormat:@"%.2fm",height];
    [_heightLB setText:str WithFont:[UIFont systemFontOfSize:30] AndColor:kContentHighlightColor];
    [_heightLB setKeyWordTextArray:@[@"m"] WithFont:[UIFont systemFontOfSize:17] AndColor:kContentNormalColor];
    _heightLB.textAlignment = NSTextAlignmentCenter;
    _heightLB.backgroundColor = [UIColor clearColor];
    _heightLB.tag = IntorViewTag;
    _heightLB.alpha = 0.0;
    [self.view addSubview:_heightLB];
}

- (void)addWeightView {
    UIImage *image = [UIImage imageNamed:@"intro_male_small"];
    UIImageView *peopleImagView = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.width - image.size.width)/2, 3 + self.offsetY, image.size.width, image.size.height)];
    peopleImagView.image = image;
    peopleImagView.alpha = 0.0;
    peopleImagView.tag = IntorViewTag;
    [self.view addSubview:peopleImagView];
    
    image  = [UIImage imageNamed:@"intro_weight"];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(120, 0, image.size.width, image.size.height)];
    imageView.image = image;
    _weightScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake((self.view.width - 300)/2,340 + self.offsetY, 300,image.size.height)];
    _weightScrollView.contentSize = CGSizeMake(image.size.width + 120 + 121.5, image.size.height);
    _weightScrollView.showsHorizontalScrollIndicator = NO;
    _weightScrollView.showsVerticalScrollIndicator = NO;
    _weightScrollView.delegate = self;
    [_weightScrollView addSubview:imageView];
    _weightScrollView.tag = IntorViewTag;
    _weightScrollView.alpha = 0.0;
    [self.view addSubview:_weightScrollView];
    
    NSInteger weight = [[NSUserDefaults standardUserDefaults] integerForKey:kUserWeight];
    if (weight == 0) {
        weight = 60;
    }
    CGFloat offsetX = (weight - 30)*8;
    CGPoint offset = CGPointMake(offsetX, 0);
    _weightScrollView.contentOffset = offset;

    _weightLB = [[DetailTextView alloc] initWithFrame:CGRectMake((self.view.width - 70)/2, 279 + self.offsetY, 70, 40)]
    ;
    NSString *str = [NSString stringWithFormat:@"%dkg",weight];
    [_weightLB setText:str WithFont:[UIFont systemFontOfSize:30] AndColor:kContentHighlightColor];
    [_weightLB setKeyWordTextArray:@[@"kg"] WithFont:[UIFont systemFontOfSize:17] AndColor:kContentNormalColor];
    _weightLB.tag = IntorViewTag;
    _weightLB.alpha = 0.0;
    [self.view addSubview:_weightLB];

    
    image = [UIImage imageNamed:@"intro_weight_line"];
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.width - image.size.width)/2 - 1, _weightScrollView.y - image.size.height/2, image.size.width, image.size.height)];
    imageView.image = image;
    imageView.tag = IntorViewTag;
    imageView.alpha = 0.0;
    [self.view addSubview:imageView];

}

- (void)addGoalView {
    _goalVC = [[SportSetViewController alloc] initWithNibName:@"SportSetViewController" bundle:nil];
    _goalVC.isView = YES;
    _goalVC.view.frame = CGRectMake(0, 0, self.view.width, self.view.height - 49);
    _goalVC.view.tag = IntorViewTag;
    _goalVC.view.alpha = 0.0;
    [self.view addSubview:_goalVC.view];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _weightScrollView) {
        NSInteger weight = 30 + (scrollView.contentOffset.x)/80 * 10;
        [_weightLB setText:[NSString stringWithFormat:@"%dkg",weight] WithFont:[UIFont systemFontOfSize:30] AndColor:kContentHighlightColor];
        [_weightLB setKeyWordTextArray:@[@"kg"] WithFont:[UIFont systemFontOfSize:17] AndColor:kContentNormalColor];
        
    } else {
        CGFloat height = (2.30 - (scrollView.contentOffset.y)/80 * 0.1);
        [_heightLB setText:[NSString stringWithFormat:@"%.2fm",height] WithFont:[UIFont systemFontOfSize:30] AndColor:kContentHighlightColor];
        [_heightLB setKeyWordTextArray:@[@"m"] WithFont:[UIFont systemFontOfSize:17] AndColor:kContentNormalColor];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == _weightScrollView) {
        NSInteger weight = 30 + (scrollView.contentOffset.x)/80 * 10;
        [[NSUserDefaults standardUserDefaults] setInteger:weight forKey:kUserWeight];
    } else {
        CGFloat height = (2.30 - (scrollView.contentOffset.y)/80 * 0.1);
        [[NSUserDefaults standardUserDefaults] setFloat:height forKey:kUserHeight];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        if (scrollView == _weightScrollView) {
            NSInteger weight = 30 + (scrollView.contentOffset.x)/80 * 10;
            [[NSUserDefaults standardUserDefaults] setInteger:weight forKey:kUserWeight];
        } else {
            CGFloat height = (2.30 - (scrollView.contentOffset.y)/80 * 0.1);
            [[NSUserDefaults standardUserDefaults] setFloat:height forKey:kUserHeight];
        }
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
