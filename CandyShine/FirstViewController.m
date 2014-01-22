//
//  FirstViewController.m
//  CandyShine
//
//  Created by huangfulei on 14-1-20.
//  Copyright (c) 2014年 CandyWearables. All rights reserved.
//

#import "FirstViewController.h"
#import "DragView.h"
#import "GridPathView.h"

#define GapCircleAndPath 300

@interface FirstViewController () <UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_circleTableView;
    UITableView *_pathTableView;
    UITableView *_friendsTableView;
    
    CGFloat _prePointY;
    CGFloat _offset1;
    CGFloat _offset2;
    CGFloat _offset3;
    
    BOOL _isInPathTableView;
}
@end

@implementation FirstViewController

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
    
    _circleTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.width) style:UITableViewStylePlain];
    _circleTableView.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    [_circleTableView.layer setAnchorPoint:CGPointMake(0.5, 0.5)];
    _circleTableView.transform = CGAffineTransformMakeRotation(-M_PI_2);
    _circleTableView.rowHeight = self.view.frame.size.width;
    _circleTableView.delegate = self;
    _circleTableView.dataSource = self;
    _circleTableView.rowHeight = self.view.frame.size.width;
    _circleTableView.showsVerticalScrollIndicator = NO;
    _circleTableView.pagingEnabled = YES;
    _circleTableView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_circleTableView];
    
    _pathTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,self.view.height, self.view.width) style:UITableViewStylePlain];
    _pathTableView.center = CGPointMake(self.view.width/2,self.view.height/2 + GapCircleAndPath);
    [_pathTableView.layer setAnchorPoint:CGPointMake(0.5, 0.5)];
    _pathTableView.transform = CGAffineTransformMakeRotation(-M_PI_2);
    _pathTableView.rowHeight = self.view.frame.size.width;
    _pathTableView.delegate = self;
    _pathTableView.dataSource = self;
    _pathTableView.rowHeight = self.view.frame.size.width;
    _pathTableView.showsVerticalScrollIndicator = NO;
    _pathTableView.pagingEnabled = YES;
    _pathTableView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_pathTableView];
    _pathTableView.scrollEnabled = YES;
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(receivePanGestureRecognizer:)];
    [self.view addGestureRecognizer:panGestureRecognizer];
    
}

- (void)receivePanGestureRecognizer:(UIPanGestureRecognizer *)recognizer {
    CGPoint touchPoint = [recognizer locationInView:self.view];
    CGFloat offset = touchPoint.y - _prePointY;
    _prePointY = touchPoint.y;
    _offset1 = _offset2;
    _offset2 = _offset3;
    _offset3 = offset;
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        if (touchPoint.y < _pathTableView.y) {
            _isInPathTableView = NO;
        } else {
            _isInPathTableView = YES;
        }
        
    } else if (recognizer.state == UIGestureRecognizerStateEnded){
        if (_isInPathTableView) {
            if ((0<=_pathTableView.y && _pathTableView.y <=0 + 20) ||  ((_pathTableView.y > 0 +20 && _pathTableView.y < GapCircleAndPath - 20) && ((_offset1 + _offset2 + _offset3) < 0)) ) {
                [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    _pathTableView.y = 0;
                } completion:^(BOOL finished) {
                    
                }];
            } else if ((_pathTableView.y >=GapCircleAndPath - 20) || ((_pathTableView.y > 0 +20 && _pathTableView.y < GapCircleAndPath - 20) && ((_offset1 + _offset2 + _offset3) >= 0))) {
                [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    _pathTableView.y = GapCircleAndPath;
                } completion:^(BOOL finished) {
                    
                }];
            }

        }
    } else if (recognizer.state == UIGestureRecognizerStateCancelled){
        
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        if (_isInPathTableView) {
            CGFloat y = _pathTableView.y + offset;
            y = y<0 ? 0 : y;
            _pathTableView.y = y;
        }

    }

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    CGPoint offset = CGPointMake(0, _circleTableView.contentSize.height - self.view.frame.size.width);
    _circleTableView.contentOffset = offset;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifer = @"CellIdentifer";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
        cell.transform = CGAffineTransformMakeRotation(M_PI_2);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        
        GridPathView *pathView =[[GridPathView alloc] initWithFrame:CGRectMake(0, 0, 320, 150)];
        
        DragView *dragView = [[DragView alloc] initWithFrame:CGRectMake(0, 300, 320, 600) fromPointY:300 toPointY:0];
        dragView.backgroundColor = [UIColor grayColor];
        [dragView addSubview:pathView];
        [cell.contentView addSubview:pathView];
        if (_pathTableView == tableView) {
            cell.contentView.backgroundColor = [UIColor orangeColor];
        }
    }
    
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    _pathTableView.contentOffset = scrollView.contentOffset;
    _circleTableView.contentOffset = scrollView.contentOffset;
}

- (void)initNavigationItem {
    [self.navigationItem setCustomeLeftBarButtonItem:@"TabMeSelected" target:self action:@selector(back)];
}

- (IBAction)go {
    UIViewController *vc = [[UIViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
