//
//  SatisfactionController.m
//  Image Viewer Demo
//
//  Created by ZC on 16/9/29.
//  Copyright © 2016年 zc. All rights reserved.
//

#import "SatisfactionController.h"
#import "SVProgressHUD.h"
#import "Reachability.h"
@interface SatisfactionController ()

{
    NSInteger _lastSelectRow;
    Reachability *_reach;

}

@end

@implementation SatisfactionController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"满意度调查";
    self.tableView.rowHeight = 50;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    _lastSelectRow = -1;
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc]initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(sendClick)];
    self.navigationItem.rightBarButtonItem = buttonItem;
    
}

- (void)sendClick
{
    if (_lastSelectRow >= 0) {
        [self networkingTest];
    }
    else {
        [SVProgressHUD setMinimumDismissTimeInterval:1];
        [SVProgressHUD showErrorWithStatus:@"请选择后发送"];
    }
    
}

- (void)networkingTest
{
    Reachability* reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    
    
    reach.reachableBlock = ^(Reachability*reach)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self networkingSuccessAlert];
        });
    };
    
    reach.unreachableBlock = ^(Reachability*reach)
    {
        [self networkingErrorAlert];
    };
    
    
    [reach startNotifier];
    _reach = reach;
}

- (void)networkingSuccessAlert
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(arc4random() % 10 / 10.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD setMinimumDismissTimeInterval:1];
        [SVProgressHUD showSuccessWithStatus:@"发送成功"];
        
    });
    [self.navigationController popViewControllerAnimated:YES];
    
    [_reach stopNotifier];
}

- (void)networkingErrorAlert
{
    [SVProgressHUD setMinimumDismissTimeInterval:1];
    [SVProgressHUD showErrorWithStatus:@"发送失败，请检查网络"];
    [_reach stopNotifier];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.textLabel.text = [NSString stringWithFormat:@"    ❤️ %ld分",10 - indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    if (_lastSelectRow >= 0) {
        UITableViewCell *lastSelectCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_lastSelectRow inSection:0]];
        lastSelectCell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    _lastSelectRow = indexPath.row;
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
