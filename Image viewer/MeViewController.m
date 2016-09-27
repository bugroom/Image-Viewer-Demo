

//
//  MeViewController.m
//  Image viewer
//
//  Created by ZC on 2016/9/26.
//  Copyright © 2016年 zc. All rights reserved.
//

#import "MeViewController.h"
#import "SDImageCache.h"
#import "UserInfoController.h"
@interface MeViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) UITableView *myTableView;

@property (nonatomic, strong) NSArray *datasourceArray;

@property (nonatomic, weak) UIButton *myHeaderImageButton;

@end

@implementation MeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _datasourceArray = @[@"图片缓存(点击清理)",@"清理历史搜索记录"];
    [self myTableView];
}


- (UITableView *)myTableView
{
    if (!_myTableView)
    {
        UITableView *tb = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        tb.delegate = self;
        tb.dataSource = self;
        tb.rowHeight = 70;
        [self.view addSubview:tb];
        
        tb.tableHeaderView = [self headerView];
        tb.tableFooterView = [[UIView alloc]init];
        
        
        _myTableView = tb;
    }
    
    return _myTableView;
}

- (UIView *)headerView
{
    int buttonWidth = 60;
    int buttonHeight = buttonWidth;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 80)];
    
    UIButton *myHeaderImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    myHeaderImageButton.frame = CGRectMake(20, view.frame.size.height/2 - buttonHeight/2, buttonWidth, buttonHeight);
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"userIcon"]) {
        [myHeaderImageButton setBackgroundImage:[[NSUserDefaults standardUserDefaults] valueForKey:@"userIcon"] forState:UIControlStateNormal];
    }else
    [myHeaderImageButton setBackgroundImage:[UIImage imageNamed:@"defaultHeaderImage"] forState:UIControlStateNormal];
    myHeaderImageButton.layer.cornerRadius = buttonWidth/2;
    myHeaderImageButton.clipsToBounds = YES;
    [myHeaderImageButton addTarget:self action:@selector(enterSetUserInfoController) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:myHeaderImageButton];
    
    _myHeaderImageButton = myHeaderImageButton;
    
    
    return view;
}

- (void)enterSetUserInfoController
{
    UserInfoController *userinfoController = [[UserInfoController alloc]initWithNibName:@"UserInfoController" bundle:nil];
    [self.navigationController pushViewController:userinfoController animated:YES];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _datasourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
         UITableViewCell *cel = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
        cell =cel;
    }
    cell.imageView.image = [UIImage imageNamed:@"baidu_wallet_bsc"];
    cell.textLabel.text = _datasourceArray[indexPath.row];
    if (indexPath.row == 0) {
        cell.detailTextLabel.text = @"大小计算中...";
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *string = [NSString stringWithFormat:@"%.02fM",[[SDImageCache sharedImageCache] getSize] /1024.0/1024.0];
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.detailTextLabel.text = string;
            });
        });
    }
    
    if (indexPath.row == 1) {
        cell.detailTextLabel.text = @"计算中...";
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *string = [NSString stringWithFormat:@"%ld条",[[[NSUserDefaults standardUserDefaults] valueForKey:@"SearchHistory"] count]];
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.detailTextLabel.text = string;
            });
        });
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item == 0) {
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"清理缓存" delegate:self cancelButtonTitle:@"清理" otherButtonTitles:@"取消", nil] show];
    }
    if (indexPath.item == 1) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"清理历史搜索记录" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction1 = [UIAlertAction actionWithTitle:@"清理" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            NSMutableArray *arr = [NSMutableArray array];
            [[NSUserDefaults standardUserDefaults] setObject:arr forKey:@"SearchHistory"];
            [self.myTableView reloadData];
        }];
        UIAlertAction *alertAction2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:alertAction1];
        [alertController addAction:alertAction2];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [[SDImageCache sharedImageCache] clearDisk];
        [self.myTableView reloadData];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
