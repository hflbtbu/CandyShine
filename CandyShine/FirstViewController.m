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
#import "CirclePathView.h"
#import "CircleTableViewCell.h"
#import "PathTableViewCell.h"
#import "MenuView.h"

#define GapCircleAndPath 300

@interface FirstViewController () <UITableViewDelegate,UITableViewDataSource,MenuViewDelegate>
{
    UITableView *_circleTableView;
    UITableView *_pathTableView;
    UITableView *_friendsTableView;
    
    UIButton *_titleButton;
    MenuView *_menuView;
    
    
    CGFloat _prePointY;
    CGFloat _offset1;
    CGFloat _offset2;
    CGFloat _offset3;
    
    DataPattern _currentPattern;
    
    BOOL _isInPathTableView;
    int _currentPage;
    
    
    NSArray *_testArray;
    NSArray *_pathTest;
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
    
    _menuView = [[MenuView alloc] initWithFrame:CGRectMake((self.view.width - 100)/2, 10, 100, 100)];
    _menuView.delegate = self;
    _menuView.hidden = YES;
    [self.view addSubview:_menuView];
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(receivePanGestureRecognizer:)];
    [self.view addGestureRecognizer:panGestureRecognizer];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(receiveTapGestureRecognizer:)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    
    _testArray = @[[NSNumber numberWithInt:100],[NSNumber numberWithInt:400],[NSNumber numberWithInt:900]];
    
    NSArray *array1 = @[[NSNumber numberWithInt:0],[NSNumber numberWithInt:30],[NSNumber numberWithInt:10],[NSNumber numberWithInt:20],[NSNumber numberWithInt:0],[NSNumber numberWithInt:50],[NSNumber numberWithInt:40],[NSNumber numberWithInt:30],[NSNumber numberWithInt:30],[NSNumber numberWithInt:60],[NSNumber numberWithInt:40],[NSNumber numberWithInt:10],[NSNumber numberWithInt:30],[NSNumber numberWithInt:40],[NSNumber numberWithInt:60],[NSNumber numberWithInt:80]];
    
    NSArray *array2 = @[[NSNumber numberWithInt:0],[NSNumber numberWithInt:30],[NSNumber numberWithInt:40],[NSNumber numberWithInt:60],[NSNumber numberWithInt:00],[NSNumber numberWithInt:50],[NSNumber numberWithInt:40],[NSNumber numberWithInt:30],[NSNumber numberWithInt:30],[NSNumber numberWithInt:60],[NSNumber numberWithInt:80],[NSNumber numberWithInt:40],[NSNumber numberWithInt:30],[NSNumber numberWithInt:20],[NSNumber numberWithInt:10],[NSNumber numberWithInt:0]];
    
    NSArray *array3 = @[[NSNumber numberWithInt:0],[NSNumber numberWithInt:30],[NSNumber numberWithInt:40],[NSNumber numberWithInt:60],[NSNumber numberWithInt:00],[NSNumber numberWithInt:50],[NSNumber numberWithInt:40],[NSNumber numberWithInt:30],[NSNumber numberWithInt:30],[NSNumber numberWithInt:60],[NSNumber numberWithInt:40],[NSNumber numberWithInt:10],[NSNumber numberWithInt:30],[NSNumber numberWithInt:40],[NSNumber numberWithInt:60],[NSNumber numberWithInt:80]];
    _pathTest = @[array1,array2,array3];
    
    
}

- (void)receivePanGestureRecognizer:(UIPanGestureRecognizer *)recognizer {
    CGPoint touchPoint = [recognizer locationInView:self.view];
    CGFloat offset = touchPoint.y - _prePointY;
    _prePointY = touchPoint.y;
    _offset1 = _offset2;
    _offset2 = _offset3;
    _offset3 = offset;
    _menuView.hidden = YES;
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
                    //_pathTableView.scrollEnabled = NO;
                    
                }];
            } else if ((_pathTableView.y >=GapCircleAndPath - 20) || ((_pathTableView.y > 0 +20 && _pathTableView.y < GapCircleAndPath - 20) && ((_offset1 + _offset2 + _offset3) >= 0))) {
                [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    _pathTableView.y = GapCircleAndPath;
                } completion:^(BOOL finished) {
                   // _pathTableView.scrollEnabled = NO;
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //self.navigationItem.titleView.x = (self.navigationController.navigationBar.width - self.navigationItem.titleView.width);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _circleTableView) {
        return _testArray.count;
    } else if (tableView == _pathTableView) {
        return _pathTest.count;
    } else {
        return [[_pathTest objectAtIndex:0] count] - 10;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *circleCellIdentifer = @"CircleCellIdentifer";
    static NSString *pathCellIdentifer = @"PathCellIdentifer";
    static NSString *friendCellIdentifer = @"FriendCellIdentifer";
    if (tableView == _circleTableView) {
        CircleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:circleCellIdentifer];
        if (cell == nil) {
            cell = [[CircleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:circleCellIdentifer];
        }
        
        cell.runNumbers = [[_testArray objectAtIndex:indexPath.row] intValue];
        [cell refresh];
        
        return cell;
    } else if (tableView == _pathTableView) {
        PathTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:pathCellIdentifer];
        if (cell == nil) {
            cell = [[PathTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:pathCellIdentifer];
            cell.friensTableView.delegate = self;
            cell.friensTableView.dataSource = self;
            cell.friensTableView.tag = 1000;
        }
        cell.valueArray = [_pathTest objectAtIndex:indexPath.row];
        [cell refresh];
        
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:friendCellIdentifer];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:friendCellIdentifer];
        }
        
        cell.textLabel.text = [NSString stringWithFormat:@"%d",[[[_pathTest objectAtIndex:_currentPage] objectAtIndex:indexPath.row] intValue]];
        
        return cell;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    _menuView.hidden = YES;
    if (scrollView == _pathTableView || scrollView == _circleTableView) {
        _pathTableView.contentOffset = scrollView.contentOffset;
        _circleTableView.contentOffset = scrollView.contentOffset;
    } else {
        //_pathTableView.scrollEnabled = NO;
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _currentPage = _testArray.count - scrollView.contentOffset.y/self.view.width - 1;
    PathTableViewCell *pathCell = (PathTableViewCell *)[_pathTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:scrollView.contentOffset.y/self.view.width inSection:0]];
    [pathCell.friensTableView reloadData];
}

- (void)initNavigationItem {
    //[self.navigationItem setCustomeLeftBarButtonItem:@"TabMeSelected" target:self action:@selector(back)];
    
    _titleButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 300, 44)];
    //_titleButton.backgroundColor = [UIColor grayColor];
    [_titleButton setTitle:@"今天eoirtut5etet545y4" forState:UIControlStateNormal];
    [_titleButton setImage:[UIImage imageNamed:@"TabMeSelected"] forState:UIControlStateNormal];
    [_titleButton setImage:[UIImage imageNamed:@"TabMeSelected"] forState:UIControlStateSelected];
    [_titleButton setImage:[UIImage imageNamed:@"TabMeSelected"] forState:UIControlStateHighlighted];
    [_titleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
   // [_titleButton setEdgeCenterWithSpace:2];
    [_titleButton addTarget:self action:@selector(showMenuView) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = _titleButton;
}

- (void)showMenuView {
    _menuView.hidden = _menuView.hidden ? NO : YES;
}

- (void)menuViewDidSelectedDataPattern:(DataPattern)dataPattern {
    _menuView.hidden = YES;
}

- (void)receiveTapGestureRecognizer:(UIPanGestureRecognizer *)recognizer {
    _menuView.hidden = YES;
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
