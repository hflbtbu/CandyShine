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

@interface MeSetViewController () <UITableViewDataSource, UITableViewDelegate, UMSocialUIDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate, PickerViewDelegate>
{
    IBOutlet UITableView *_tableView;
    
    IBOutlet UISwitch *_sexSwitch;
    
    UIImageView *_thumberImage;
    
    UIImageView *_image;
    
    PickerView *_pickerView;
    
    UITableViewCell *_selectedCell;
    PickerViewType _pickerType;
    
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
    
    _tableView.contentInset = UIEdgeInsetsMake(-15, 0, 0, 0);
    
    _image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 200, 120, 120)];
    [self.view addSubview:_image];
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
    if (indexPath.section == 0 && indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:thumberCellIdentifer];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:thumberCellIdentifer];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            _thumberImage = [[UIImageView alloc] initWithFrame:CGRectMake(cell.width - 100, 5, 60, 60)];
            _thumberImage.backgroundColor = [UIColor orangeColor];
            _thumberImage.layer.cornerRadius = 30;
            _thumberImage.layer.masksToBounds = YES;
            _thumberImage.image = [UIImage imageNamed:@"IMG_0005.JPG"];
            [cell.contentView addSubview:_thumberImage];
        }
        cell.textLabel.text = @"头像";
        return cell;
    } else if (indexPath.section == 1 && indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sexCellIdentifer];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:sexCellIdentifer];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            UIView *view = [[[NSBundle mainBundle] loadNibNamed:@"SexView" owner:self options:nil] objectAtIndex:0];
            view.x = 180;
            [cell.contentView addSubview:view];
        }
        cell.textLabel.text = @"性别";
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
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
        return cell;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册选择", nil];
            as.actionSheetStyle = UIActionSheetStyleBlackOpaque;
            as.tapBlock = ^(UIActionSheet *actionSheet, NSInteger buttonIndex){
                UIImagePickerController *image = [[UIImagePickerController alloc] init];
                if (buttonIndex == 0) {
                    image.sourceType = UIImagePickerControllerSourceTypeCamera;
                    image.cameraDevice = UIImagePickerControllerCameraDeviceFront;
                } else {
                    image.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                }
                image.allowsEditing = YES;
                image.delegate = self;
                [self presentViewController:image animated:YES completion:^{
                    
                }];
            };
            [as showInView:[UIApplication sharedApplication].keyWindow];
        } else if (indexPath.row == 1) {
            
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
    UIImage *image= [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    UIImage *erw = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    
    CGRect fame  = [[info objectForKey:@"UIImagePickerControllerCropRect"] CGRectValue];
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }

    _thumberImage.image = erw;
    [self dismiss];
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
