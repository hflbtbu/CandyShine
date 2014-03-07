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
    _dataManager = [CSDataManager sharedInstace];
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
        return 70;
    }
    return 44;
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
            _thumberImage =[[CircleImageView alloc] initWithFrame:CGRectMake(originX, 5, 60, 60) image:@"IMG_0005.JPG"];
            if (_dataManager.isLogin) {
                NSString * url = [NSString stringWithFormat:@"%@%@",kPortraitURL,[CSDataManager sharedInstace].userId];
                [_thumberImage.imageView setImageWithURL:[NSURL URLWithString:url]];
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
                cell.detailTextLabel.text = @"CandyWearables";
            } else {
                cell.textLabel.text = @"修改密码";
            }
        } else {
            if (indexPath.row == 1) {
                cell.textLabel.text = @"身高";
                cell.detailTextLabel.text = @"170m";
            } else if (indexPath.row == 2) {
                cell.textLabel.text = @"体重";
                cell.detailTextLabel.text = @"58kg";
            } else {
                cell.textLabel.text = @"出生日期";
                cell.detailTextLabel.text = @"1990年8月";
            }
        }
    }
    cell.textLabel.textColor = kContentNormalColor;
    cell.textLabel.font = kContentFont3;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 0) {
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
                    UITextField *textField  = [alertView textFieldAtIndex:0];
                    NSLog(@"%@",textField.text);
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
        } else {
            _selectedCell = [tableView cellForRowAtIndexPath:indexPath];
            _pickerType =  PickerViewBirthday;
            _pickerView = [[PickerView alloc] initWithFrame:CGRectMake(0, 0, 320, 260) :PickerViewBirthday];
            _pickerView.delegate = self;
            [_pickerView show];
        }
        
    }

}

- (void)pickerViewDidSelectedWithVlaue:(NSDictionary *)dic {
    NSLog(@"%@",_selectedCell.detailTextLabel.text);
    NSString *str;
    if (_pickerType == PickerViewHeight) {
        str = [NSString stringWithFormat:@"%.1fm",[[dic objectForKey:kPickerHeight] floatValue]];
    } else if (_pickerType == PickerViewWeight) {
        str = [NSString stringWithFormat:@"%.1fkg",[[dic objectForKey:kPickerWeight] floatValue]];
    } else {
        str = [NSString stringWithFormat:@"%d年%d月%d日",[[dic objectForKey:kPickerYear] integerValue],[[dic objectForKey:kPickerMonth] integerValue],[[dic objectForKey:kPickerDay] integerValue]];
    }
    _selectedCell.detailTextLabel.text = str;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    _thumberImage.imageView.image = image;
    MeViewController *vc = (MeViewController *)[self.navigationController.viewControllers objectAtIndex:0];
    if ([vc isKindOfClass:[MeViewController class]]) {
        vc.thumberImage.imageView.image = image;
    }
    [self dismissViewControllerAnimated:YES completion:^{
        NSData *imageData = UIImageJPEGRepresentation(image,0.01);
        [[CandyShineAPIKit sharedAPIKit] requestModifyPortraitWithImage:imageData Success:^(NSDictionary *result) {
            
        } fail:^(NSError *error) {
            
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
