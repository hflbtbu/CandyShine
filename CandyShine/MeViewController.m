//
//  MeViewController.m
//  CandyShine
//
//  Created by huangfulei on 14-2-16.
//  Copyright (c) 2014年 CandyWearables. All rights reserved.
//

#import "MeViewController.h"

@interface MeViewController () <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView *_tableView;
    
    IBOutlet UISwitch *_sexSwitch;
}
@end

@implementation MeViewController

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
            UIImageView *thumber = [[UIImageView alloc] initWithFrame:CGRectMake(cell.width - 100, 5, 60, 60)];
            thumber.backgroundColor = [UIColor orangeColor];
            thumber.layer.cornerRadius = 30;
            thumber.layer.masksToBounds = YES;
            thumber.image = [UIImage imageNamed:@"IMG_0005.JPG"];
            [cell.contentView addSubview:thumber];
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
//            UIImagePickerController *image = [[UIImagePickerController alloc] init];
//            image.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//            [self presentViewController:image animated:YES completion:^{
//                
//            }];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
