

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
#import "Masonry.h"
#import "MeUserInfoCell.h"
@interface MeViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) UITableView *myTableView;

@property (nonatomic, strong) NSArray *datasourceArray;

@property (nonatomic, weak) UIButton *myHeaderImageButton;

@property (nonatomic, weak) MeUserInfoCell *headerView;
@end

@implementation MeViewController

-(void)dealloc
{
    NSLog(@"MeViewController dealloc");
}

-(void)loadView
{
    [super loadView];
    
    [self updateHeaderInfo];
    _headerView = [self creatHeaderView];
    self.myTableView.tableHeaderView = _headerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _datasourceArray = @[@"清除缓存",@"删除历史搜索记录",@"满意度调查",@"意见反馈",@"当前版本",@"关于"];
    [self myTableView];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateHeaderInfo];
}

- (void)updateHeaderInfo
{
    
    NSData *data = [[NSUserDefaults standardUserDefaults] valueForKey:@"userImageData"];
    if (data) {
        self.headerView.myHeaderImageView.image = [UIImage imageWithData:data];
    }else
        self.headerView.myHeaderImageView.image = [UIImage imageWithData:data];
    
}

- (MeUserInfoCell *)creatHeaderView
{
    MeUserInfoCell *view = [[NSBundle mainBundle] loadNibNamed:@"MeUserInfoCell" owner:self options:nil][0];
    view.cotroller = self;
    _headerView = view;
    
    return _headerView;
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
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *visuaEffectView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"backgroundView3"]];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        visuaEffectView.frame = imageView.frame = self.view.frame;
        
        [imageView addSubview:visuaEffectView];
        tb.backgroundView = imageView;
        tb.backgroundColor = [UIColor clearColor];
        tb.tableHeaderView = self.headerView;
        tb.tableFooterView = [[UIView alloc]init];
        
        _myTableView = tb;
    }
    return _myTableView;
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.backgroundColor = [UIColor clearColor];
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
    if (indexPath.row == 4) {
        cell.detailTextLabel.text = @"v_1.0_Beta";
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item == 0) {
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"清理缓存" delegate:self cancelButtonTitle:@"清理" otherButtonTitles:@"取消", nil] show];
    }
    if (indexPath.item == 1) {
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"清理历史搜索记录" delegate:self cancelButtonTitle:@"清理" otherButtonTitles:@"取消", nil] show];
     
        
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView.message isEqualToString:@"清理缓存"]) {
        if (buttonIndex == 0) {
            [[SDImageCache sharedImageCache] clearDisk];
            [self.myTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            _headerView = [self creatHeaderView];
            self.myTableView.tableHeaderView = _headerView;
            [self updateHeaderInfo];
        }
    }
    if ([alertView.message isEqualToString:@"清理历史搜索记录"]) {
        if (buttonIndex == 0) {
            NSMutableArray *arr = [NSMutableArray array];
            [[NSUserDefaults standardUserDefaults] setObject:arr forKey:@"SearchHistory"];
            [self.myTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            
            for (int i =0 ; i < 1000; i++) {
                _headerView = [self creatHeaderView];
            }
            
            
            self.myTableView.tableHeaderView = _headerView;
            [self updateHeaderInfo];
        }
    }
    
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
