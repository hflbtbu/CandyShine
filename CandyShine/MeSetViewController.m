//
//  MeViewController.m
//  CandyShine
//
//  Created by huangfulei on 14-2-16.
//  Copyright (c) 2014年 CandyWearables. All rights reserved.
//

#import "MeSetViewController.h"
#import "LogInViewController.h"
#import "ModifyCodeViewController.h"
#import "PickerView.h"
#import "MeViewController.h"

@interface MeSetViewController () <UITableViewDataSource, UITableViewDelegate, UMSocialUIDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate, PickerViewDelegate>
{
    IBOutlet UITableView *_tableView;
    
    IBOutlet UISwitch *_sexSwitch;
    
    CircleImageView *_thumberImage;
    
    PickerView *_pickerView;
    
    UITableViewCell *_selectedCell;
    PickerViewType _pickerType;
    CSDataManager *_dataManager;
    
}

@property (nonatomic, retain) PickerView *pickerView;

@end

@implementation MeSetViewController

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
    
    if (IsIOS7) {
        _tableView.contentInset = UIEdgeInsetsMake(-15, 0, 0, 0);
    }
    _tableView.backgroundColor = [UIColor convertHexColorToUIColor:0xf2f0ed];
    _tableView.backgroundView = nil;    _dataManager = [CSDataManager sharedInstace];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    } else if (section == 1){
        return 4;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 82;
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 1) {
        return 60;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 1) {
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, self.view.width)];
        bgView.backgroundColor = [UIColor clearColor];
        UIButton *logoutButton = [[UIButton alloc] initWithFrame:CGRectMake(8, 8, 304, 44)];
        [logoutButton setTitle: [CSDataManager sharedInstace].isLogin ? @"退出登陆" : @"登陆" forState:UIControlStateNormal];
        [logoutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        UIImage *bgImage = [[UIImage imageNamed:[CSDataManager sharedInstace].isLogin ? @"button_bg_logout" : @"button_bg_login"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 3, 0, 4)];
        [logoutButton setBackgroundImage:bgImage forState:UIControlStateNormal];
        [logoutButton addTarget:self action:@selector(logoutButtonClickerHander) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:logoutButton];
        return bgView;
    }
    return nil;
}

- (void)logoutButtonClickerHander {
    if ([[CSDataManager sharedInstace] isLogin]) {
        UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"退出后不会删除你的任何数据", @"")
                                                        delegate:nil
                                               cancelButtonTitle:NSLocalizedString(@"取消", @"")
                                          destructiveButtonTitle:NSLocalizedString(@"退出登陆", @"")
                                               otherButtonTitles:nil];
        as.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        as.tapBlock = ^(UIActionSheet *actionSheet, NSInteger buttonIndex){
            if (buttonIndex == 0) {
                [CSDataManager sharedInstace].isLogin = NO;
                [_tableView reloadData];
                [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:kLogoutFinishNotification object:nil]];
            }
        };
        [as showInView:[UIApplication sharedApplication].keyWindow];
        
    } else {
        LogInViewController *logInVC = [[LogInViewController alloc] initWithNibName:@"LogInViewController" bundle:nil];
        logInVC.hidesBottomBarWhenPushed = YES;
        BaseNavigationController *logIn = [[BaseNavigationController alloc] initWithRootViewController:logInVC];
        [self presentViewController:logIn animated:YES completion:^{
            
        }];
    }
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 0;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    return 0;
//}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    return @"fdsf";
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifer = @"CellIdentifer";
    static NSString *thumberCellIdentifer = @"CellIdentifer";
    static NSString *sexCellIdentifer = @"CellIdentifer";
    UITableViewCell *cell;
    if (indexPath.section == 0 && indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:thumberCellIdentifer];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:thumberCellIdentifer];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            NSInteger originX = IsIOS7 ? 226:212;
            _thumberImage =[[CircleImageView alloc] initWithFrame:CGRectMake(originX, 11, 60, 60) image:@"portrait_holder"];
            if (_dataManager.isLogin && _dataManager.portrait.length != 0) {
                [_thumberImage.imageView setImageWithURL:[NSURL URLWithString:_dataManager.portrait]];
            }
            [cell.contentView addSubview:_thumberImage];
        }
        cell.textLabel.text = @"头像";
    } else if (indexPath.section == 1 && indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:sexCellIdentifer];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:sexCellIdentifer];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            UIView *view = [[[NSBundle mainBundle] loadNibNamed:@"SexView" owner:self options:nil] objectAtIndex:0];
            UISwitch *sex = (UISwitch *)[view viewWithTag:100];
            BOOL isMale = [[NSUserDefaults standardUserDefaults] boolForKey:kUserIsMale];
            sex.on = isMale ? NO : YES;
            [sex addTarget:self action:@selector(sexSwitchHandler:) forControlEvents:UIControlEventValueChanged];
            NSInteger originX = IsIOS7 ? cell.contentView.width - view.width :  cell.contentView.width - view.width - 9;
            view.x = originX;
            [cell.contentView addSubview:view];
        }
        cell.textLabel.text = @"性别";
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifer];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        if (indexPath.section == 0) {
            if (indexPath.row == 1) {
                cell.textLabel.text = @"用户名";
                cell.detailTextLabel.text = _dataManager.isLogin ? _dataManager.userName : @"游客";
            } else {
                cell.textLabel.text = @"修改密码";
            }
        } else {
            if (indexPath.row == 1) {
                cell.textLabel.text = @"身高";
                CGFloat heitht = [[NSUserDefaults standardUserDefaults] floatForKey:kUserHeight];
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2fm",heitht];
            } else if (indexPath.row == 2) {
                cell.textLabel.text = @"体重";
                NSInteger weitht = [[NSUserDefaults standardUserDefaults] integerForKey:kUserWeight];
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%dkg",weitht];
            } else {
                cell.textLabel.text = @"出生日期";
                NSString *birthDay = [[NSUserDefaults standardUserDefaults] stringForKey:kUserBirthDay];
                if (birthDay == nil) {
                    birthDay = @"1990年8月";
                }
                cell.detailTextLabel.text = birthDay;
            }
        }
    }
    cell.textLabel.textColor = kContentNormalColor;
    cell.textLabel.font = kContentFont3;
    cell.detailTextLabel.textColor = kContentNormalShallowColorA;
    cell.detailTextLabel.font = kContentFont3;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 0) {
        if (!_dataManager.isLogin) {
            [MBProgressHUDManager showTextWithTitle:@"请先登录" inView:self.view];
            return;
        }
        if (indexPath.row == 0) {
            UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册选择", nil];
            as.actionSheetStyle = UIActionSheetStyleBlackOpaque;
            as.tapBlock = ^(UIActionSheet *actionSheet, NSInteger buttonIndex){
                if (buttonIndex < 2) {
                    UIImagePickerController *image = [[UIImagePickerController alloc] init];
                    if (buttonIndex == 0) {
                        image.sourceType = UIImagePickerControllerSourceTypeCamera;
                        image.cameraDevice = UIImagePickerControllerCameraDeviceFront;
                    } else if (buttonIndex == 1){
                        image.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                    }
                    image.allowsEditing = YES;
                    image.delegate = self;
                    [self presentViewController:image animated:YES completion:^{
                        
                    }];
                }
            };
            [as showInView:[UIApplication sharedApplication].keyWindow];
        } else if (indexPath.row == 1) {
                [UIAlertView showWithTitle:@"输入用户名" message:nil style:UIAlertViewStylePlainTextInput cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                    if (buttonIndex == 1) {
                        UITextField *textField  = [alertView textFieldAtIndex:0];
                        if (textField.text == nil) {
                            [MBProgressHUDManager showTextWithTitle:@"用户名不能为空" inView:self.view];
                        } else {
                            [MBProgressHUDManager showIndicatorWithTitle:@"正在请求" inView:self.view];
                            [[CandyShineAPIKit sharedAPIKit] requestModifyUserNameWithName:textField.text Success:^(NSDictionary *result) {
                                [MBProgressHUDManager hideMBProgressInView:self.view];
                                CSResponceCode code = [[result objectForKey:@"code"] integerValue];
                                if (code == CSResponceCodeSuccess) {
                                    [CSDataManager sharedInstace].userName = [[result objectForKey:@"user_info"] objectForKey:@"custom_name"];
                                    [_tableView reloadData];
                                    [MBProgressHUDManager showTextWithTitle:@"修改成功" inView:self.view];
                                } else {
                                    [MBProgressHUDManager showTextWithTitle:@"修改失败" inView:self.view];
                                }
                            } fail:^(NSError *error) {
                                [MBProgressHUDManager hideMBProgressInView:self.view];
                                [MBProgressHUDManager showTextWithTitle:error.localizedDescription inView:self.view];
                            }];
                        }
                    }
                }];
        } else {
            ModifyCodeViewController *modifyCode = [[ModifyCodeViewController alloc] initWithNibName:@"ModifyCodeViewController" bundle:nil];
            [self.navigationController pushViewController:modifyCode animated:YES];
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 1) {
            _selectedCell = [tableView cellForRowAtIndexPath:indexPath];
            _pickerType =  PickerViewHeight;
            _pickerView = [[PickerView alloc] initWithFrame:CGRectMake(0, 0, 320, 260) :PickerViewHeight];
            _pickerView.delegate = self;
            [_pickerView show];
        } else  if (indexPath.row == 2) {
            _selectedCell = [tableView cellForRowAtIndexPath:indexPath];
            _pickerType =  PickerViewWeight;
            _pickerView = [[PickerView alloc] initWithFrame:CGRectMake(0, 0, 320, 260) :PickerViewWeight];
            _pickerView.delegate = self;
            [_pickerView show];
        } else if (indexPath.row == 3)  {
            _selectedCell = [tableView cellForRowAtIndexPath:indexPath];
            _pickerType =  PickerViewBirthday;
            _pickerView = [[PickerView alloc] initWithFrame:CGRectMake(0, 0, 320, 260) :PickerViewBirthday];
            _pickerView.delegate = self;
            [_pickerView show];
        }
        
    }

}

- (void)sexSwitchHandler:(UISwitch *)sender {
    BOOL isMale = sender.isOn ? NO : YES;
    [[NSUserDefaults standardUserDefaults] setBool:isMale forKey:kUserIsMale];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)pickerViewDidSelectedWithVlaue:(NSDictionary *)dic {
    NSString *str;
    if (_pickerType == PickerViewHeight) {
        str = [NSString stringWithFormat:@"%.2fm",[[dic objectForKey:kPickerHeight] floatValue]];
        [[NSUserDefaults standardUserDefaults] setFloat:[[dic objectForKey:kPickerHeight] floatValue] forKey:kUserHeight];
    } else if (_pickerType == PickerViewWeight) {
        str = [NSString stringWithFormat:@"%dkg",[[dic objectForKey:kPickerWeight] integerValue]];
        [[NSUserDefaults standardUserDefaults] setInteger:[[dic objectForKey:kPickerWeight] floatValue] forKey:kUserWeight];
    } else {
        str = [NSString stringWithFormat:@"%d年%d月%d日",[[dic objectForKey:kPickerYear] integerValue],[[dic objectForKey:kPickerMonth] integerValue],[[dic objectForKey:kPickerDay] integerValue]];
        [[NSUserDefaults standardUserDefaults] setObject:str forKey:kUserBirthDay];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    _selectedCell.detailTextLabel.text = str;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    _thumberImage.imageView.image = image;
    [self dismissViewControllerAnimated:YES completion:^{
        NSData *imageData = UIImageJPEGRepresentation(image,0.01);
        //[[CSDataManager sharedInstace] savePortrait:imageData];
        [MBProgressHUDManager showTextWithTitle:@"正在请求" inView:self.view];
        [[CandyShineAPIKit sharedAPIKit] requestModifyPortraitWithImage:imageData Success:^(NSDictionary *result) {
            [MBProgressHUDManager hideMBProgressInView:self.view];
            CSResponceCode code = [[result objectForKey:@"code"] integerValue];
            if (code == CSResponceCodeSuccess) {
                [MBProgressHUDManager showTextWithTitle:@"修改成功" inView:self.view];
                NSString *portrait = [[result objectForKey:@"user_info"] objectForKey:@"portrait"];
                [CSDataManager sharedInstace].portrait = [NSString stringWithFormat:@"%@%@",kBaseURL,portrait];
            } else {
                [MBProgressHUDManager showTextWithTitle:@"修改失败" inView:self.view];
            }
        } fail:^(NSError *error) {
            [MBProgressHUDManager hideMBProgressInView:self.view];
            [MBProgressHUDManager showTextWithTitle:error.localizedDescription inView:self.view];
        }];
    }];
}

//压缩图片
- (UIImage*)imageWithImageSimple:(UIImage*)image scaledToRect:(CGRect)rect
{
    UIGraphicsBeginImageContext(CGSizeMake(rect.size.width, rect.size.height));
    [image drawInRect:rect];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void) initNavigationItem {
    [super initNavigationItem];
    self.navigationItem.title = @"我的信息";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
