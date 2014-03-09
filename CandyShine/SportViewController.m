//
//  FirstViewController.m
//  CandyShine
//
//  Created by huangfulei on 14-1-20.
//  Copyright (c) 2014年 CandyWearables. All rights reserved.
//

#import "SportViewController.h"
#import "DragView.h"
#import "GridPathView.h"
#import "CirclePathView.h"
#import "CircleTableViewCell.h"
#import "PathTableViewCell.h"
#import "FriendCell.h"
#import "MenuView.h"
#import "AddFriendViewController.h"
#import "Sport.h"
#import "CSFreiend.h"

#define GapCircleAndPath 300

@interface SportViewController () <UITableViewDelegate,UITableViewDataSource,MenuViewDelegate>
{
    UITableView *_circleTableView;
    UITableView *_pathTableView;
    UITableView *_friendsTableView;
    
    UIButton *_titleButton;
    MenuView *_menuView;
    UILabel *_freshTimeLB;
    
    UIImageView *_leftImage;
    UIImageView *_rightImage;
    
    
    CGFloat _prePointY;
    CGFloat _offset1;
    CGFloat _offset2;
    CGFloat _offset3;
    
    DataPattern _currentPattern;
    PageMoveType _moveType;
    
    BOOL _isOpen;
    BOOL _isInPathTableView;
    int _currentPage;
    int _requestedPage;
    NSIndexPath *_currentIndexPath;
    
    
    NSArray *_testArray;
    NSArray *_friendArray;
    NSArray *_sportItemsArray;
    NSMutableDictionary *_friendDataDic;
}

@end

@implementation SportViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        if (IsIOS7) {
            UIImage *image = [UIImage imageNamed:@"tabBarIcon_sport"];
            image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            UIImage *imageSelected = [UIImage imageNamed:@"tabBarIcon_sport_selected"];
            imageSelected = [imageSelected imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            self.tabBarItem  = [[UITabBarItem alloc] initWithTitle:@"运动" image:image selectedImage:imageSelected];
        } else {
            [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"tabBarIcon_sport_selected"] withFinishedUnselectedImage:[UIImage imageNamed:@"tabBarIcon_sport"]];
            self.tabBarItem.title = @"运动";
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _requestedPage = -1;
    _friendDataDic = [NSMutableDictionary dictionaryWithCapacity:0];
    _moveType = PageMoveDown;
    
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
    _circleTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_circleTableView];
    
    _freshTimeLB = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, 0, 0)];
    _freshTimeLB.backgroundColor = [UIColor clearColor];
    _freshTimeLB.font = [UIFont systemFontOfSize:12];
    _freshTimeLB.text = @"2014.01.02 11:47";
    _freshTimeLB.textColor = [UIColor convertHexColorToUIColor:0xccc8c2];
    CGSize size = [_freshTimeLB.text sizeWithFont:_freshTimeLB.font];
    _freshTimeLB.frame = CGRectMake((self.view.width - size.width)/2, 15, size.width, size.height);
    [self.view addSubview:_freshTimeLB];
    
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
    _pathTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_pathTableView];
    _pathTableView.scrollEnabled = YES;
    
    _leftImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TabMeSelected"]];
    _leftImage.origin = CGPointMake(10, 125);
    _leftImage.hidden = YES;
    [self.view addSubview:_leftImage];
    _rightImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TabMeSelected"]];
    _rightImage.origin = CGPointMake(self.view.width - 10 - _rightImage.width, 125);
    _rightImage.hidden = YES;
    [self.view addSubview:_rightImage];

    
    _menuView = [[MenuView alloc] initWithFrame:CGRectMake((self.view.width - 100)/2, 10, 100, 100)];
    _menuView.delegate = self;
    _menuView.hidden = YES;
    [self.view addSubview:_menuView];
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(receivePanGestureRecognizer:)];
    [self.view addGestureRecognizer:panGestureRecognizer];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(receiveTapGestureRecognizer:)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    
//    for (int i = -2; i<1; i++) {
//        NSDate *date = [DateHelper getDayBegainWith:i];
//        for (int j = 0; j < 288; j++) {
//            date = [date dateByAddingTimeInterval:5*60];
//            NSNumber *value = [NSNumber numberWithInt:arc4random() % 30];
//            [[CSDataManager sharedInstace] insertSportItemWithBlock:^(Sport *item) {
//                item.value = value;
//                item.date = date;
//            }];
//        }
//        [[CSDataManager sharedInstace] saveData];
//    }
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
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 - _currentPage inSection:0];
            PathTableViewCell *cell = (PathTableViewCell *)[_pathTableView cellForRowAtIndexPath:indexPath];
            
            CellPosition cellPosition;
            if (indexPath.row == 2) {
                cellPosition = CellPositionTop;
            } else if (indexPath.row == 1) {
                cellPosition = CellPositionMiddle;
            } else {
                cellPosition = CellPositionBottom;
            }

            
            if ((0<=_pathTableView.y && _pathTableView.y <=0 + 20) ||  ((_pathTableView.y > 0 +20 && _pathTableView.y < GapCircleAndPath - 20) && ((_offset1 + _offset2 + _offset3) < 0)) ) {
                [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    _pathTableView.y = 0;
                } completion:^(BOOL finished) {
                    _moveType = PageMoveUp;
                    cell.moveType = _moveType;
                    cell.cellPosition = cellPosition;
                    [self requestFriendData];
                }];
            } else if ((_pathTableView.y >=GapCircleAndPath - 20) || ((_pathTableView.y > 0 +20 && _pathTableView.y < GapCircleAndPath - 20) && ((_offset1 + _offset2 + _offset3) >= 0))) {
                [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    _pathTableView.y = GapCircleAndPath;
                } completion:^(BOOL finished) {
                   // _pathTableView.scrollEnabled = NO;
                    _moveType = PageMoveDown;
                    cell.moveType = _moveType;
                    cell.cellPosition = cellPosition;
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
    if (tableView == _circleTableView || tableView == _pathTableView) {
        return 1;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _circleTableView) {
        return 3;
    } else if (tableView == _pathTableView) {
        return 3;
    } else {
        if (section == 0) {
            return _friendArray.count + 1;
        }
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *circleCellIdentifer = @"CircleCellIdentifer";
    static NSString *pathCellIdentifer = @"PathCellIdentifer";
    static NSString *friendCellIdentifer = @"FriendCellIdentifer";
    static NSString *friendCellIdentiferAddFriend = @"FriendCellIdentiferAddFriend";
    if (tableView == _circleTableView) {
        CircleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:circleCellIdentifer];
        if (cell == nil) {
            cell = [[CircleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:circleCellIdentifer];
        }
        CellPosition cellPosition;
        if (indexPath.row == 2) {
            cellPosition = CellPositionTop;
        } else if (indexPath.row == 1) {
            cellPosition = CellPositionMiddle;
        } else {
            cellPosition = CellPositionBottom;
        }
        cell.currentPage = cellPosition;
        cell.runNumbers = [self calculateTotalValueByDay:indexPath];
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
        CellPosition cellPosition;
        if (indexPath.row == 2) {
            cellPosition = CellPositionTop;
        } else if (indexPath.row == 1) {
            cellPosition = CellPositionMiddle;
        } else {
            cellPosition = CellPositionBottom;
        }
        cell.moveType = _moveType;
        cell.cellPosition = cellPosition;
        
        cell.valueArray = [self sportItemsArrayWith:indexPath];
        [cell refresh];
        
        return cell;
    } else {
        if (indexPath.row == _friendArray.count) {
            UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:friendCellIdentiferAddFriend];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:friendCellIdentiferAddFriend];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UIButton *addFriendButton = [[UIButton alloc] initWithFrame:CGRectMake((cell.width - 120)/2, (kTableViewRowHeith - 44)/2, 120, 44)];
                UIImage *image = [[UIImage imageNamed:@"button_bg_login"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 4.5, 0, 4.5)];
                [addFriendButton setBackgroundImage:image forState:UIControlStateNormal];
                [addFriendButton setTitle:@"添加好友" forState:UIControlStateNormal];
                [addFriendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [addFriendButton addTarget:self action:@selector(go) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:addFriendButton];
                cell.selectionStyle = UITableViewCellEditingStyleNone;
            }
            return cell;
        }
        
        
        FriendCell *cell = [tableView dequeueReusableCellWithIdentifier:friendCellIdentifer];
        if (cell == nil) {
            cell = [[FriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:friendCellIdentifer];
            cell.selectionStyle = UITableViewCellEditingStyleNone;
        }
        CSFreiend *item;
        if (indexPath.row < _friendArray.count) {
            item = [_friendArray objectAtIndex:indexPath.row];
        }
        cell.frinendThumberImage.imageView.image = [UIImage imageNamed:@"IMG_0005.JPG"];
        if (item.portrait.length != 0) {
            [cell.frinendThumberImage.imageView setImageWithURL:[NSURL URLWithString:item.portrait]];
        }
        
        NSString *str = [NSString stringWithFormat:@"%@今天消耗 : %d 卡路里",item.name,item.sorce];
        CGSize size =[str sizeWithFont:kTitleFont1];
        cell.friendRunLB.frame = CGRectMake(cell.friendRunLB.x, cell.friendRunLB.y, cell.width, size.height);
        [cell.friendRunLB setText:str WithFont:kContentFont1 AndColor:kContentNormalColor];
        [cell.friendRunLB setKeyWordTextArray:@[[NSString stringWithFormat:@"%d",item.sorce]] WithFont:kContentFont1 AndColor:kContentHighlightColor];
        if (indexPath.row == 0) {
            [cell setCellPosition:CellPositionTop];
        } else if (indexPath.row == _friendArray.count - 1) {
            [cell setCellPosition:CellPositionBottom];
        } else {
            [cell setCellPosition:CellPositionMiddle];
        }
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
    _currentPage = 3 - scrollView.contentOffset.y/self.view.width - 1;
    [_titleButton setTitle:[DateHelper getDayStringWith:_currentPage] forState:UIControlStateNormal];
    //[_titleButton setEdgeCenterWithSpace:0];
    if (_moveType == PageMoveUp) {
        [self requestFriendData];
    }
}

- (NSInteger)calculateTotalValueByDay:(NSIndexPath *)indexPath {
    NSInteger value = 0;
    for (Sport *item in [self sportItemsArrayWith:indexPath]) {
        value += [item.value integerValue];
    }
    return value;
}

- (NSArray *)sportItemsArrayWith:(NSIndexPath *)indexPath {
    if (![indexPath isEqual:_currentIndexPath]) {
        _currentIndexPath = indexPath;
        _sportItemsArray = [[CSDataManager sharedInstace] fetchSportItemsByDay:indexPath.row - 2];
    }
    return _sportItemsArray;
}

- (void)initNavigationItem {
    //[self.navigationItem setCustomeLeftBarButtonItem:@"TabMeSelected" target:self action:@selector(go)];
    
    _titleButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 300, 44)];
    //_titleButton.backgroundColor = [UIColor grayColor];
    [_titleButton setTitle:[DateHelper getDayStringWith:0] forState:UIControlStateNormal];
//    [_titleButton setImage:[UIImage imageNamed:@"TabMeSelected"] forState:UIControlStateNormal];
//    [_titleButton setImage:[UIImage imageNamed:@"TabMeSelected"] forState:UIControlStateSelected];
//    [_titleButton setImage:[UIImage imageNamed:@"TabMeSelected"] forState:UIControlStateHighlighted];
    [_titleButton setTitleColor:[UIColor convertHexColorToUIColor:0x8c8377] forState:UIControlStateNormal];
//    [_titleButton setEdgeCenterWithSpace:0];
    //[_titleButton addTarget:self action:@selector(showMenuView) forControlEvents:UIControlEventTouchUpInside];
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

- (void)requestFriendData {
    if ([CSDataManager sharedInstace].isLogin) {
        _friendArray = [_friendDataDic objectForKey:[NSString stringWithFormat:@"%d",_currentPage]];
        if (_friendArray == nil) {
            //[MBProgressHUDManager showIndicatorWithTitle:@"正在加载" inView:self.view];
            [[CandyShineAPIKit sharedAPIKit] requestFriednListSuccess:^(NSMutableArray *result) {
                //[MBProgressHUDManager hideMBProgressInView:self.view];
                _friendArray = result;
                [_friendDataDic setObject:_friendArray forKey:[NSString stringWithFormat:@"%d",_currentPage]];
                [self reloadFeiendData];
            } fail:^(NSError *error) {
                
            }];
        }
        [self reloadFeiendData];
    }
}

- (IBAction)go {
    if ([CSDataManager sharedInstace].isLogin) {
        AddFriendViewController *vc = [[AddFriendViewController alloc] initWithNibName:@"AddFriendViewController" bundle:nil];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        [MBProgressHUDManager showTextWithTitle:@"请先登录" inView:self.view];
    }
}


- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    _circleTableView.frame = CGRectMake(0, 0, self.view.width, self.view.height);
    _circleTableView.width = self.view.width;
    _circleTableView.height = self.view.height;
    _circleTableView.center = CGPointMake(self.view.width/2, self.view.height/2);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addFriendDidFinishHandler) name:kAddFriendFinishNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginDidFinishHandler) name:kLoginFinishNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutDidFinishHandler) name:kLogoutFinishNotification object:nil];
    
}

- (void)addFriendDidFinishHandler {
    [_friendDataDic removeAllObjects];
    if (_moveType == PageMoveUp) {
        [self requestFriendData];
    }
}

- (void)loginDidFinishHandler {
    [_friendDataDic removeAllObjects];
    if (_moveType == PageMoveUp) {
        [self requestFriendData];
    }
}

- (void)logoutDidFinishHandler {
    _friendArray = nil;
    [_friendDataDic removeAllObjects];
    [self reloadFeiendData];
}

- (void)reloadFeiendData {
    if (_moveType == PageMoveUp) {
        PathTableViewCell *pathCell = (PathTableViewCell *)[_pathTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_pathTableView.contentOffset.y/self.view.width inSection:0]];
        [pathCell.friensTableView reloadData];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kAddFriendFinishNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kLoginFinishNotification object:nil];
}
@end
