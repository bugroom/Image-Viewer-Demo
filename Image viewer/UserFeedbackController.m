//
//  UserFeedbackController.m
//  Image Viewer Demo
//
//  Created by ZC on 16/9/29.
//  Copyright © 2016年 zc. All rights reserved.
//

#import "UserFeedbackController.h"
#import "Masonry.h"
#import "Config.h"
#import "SVProgressHUD.h"
#import "Reachability.h"
@interface UserFeedbackController () <UITextViewDelegate>
{
    UITextView *_textView;
    UILabel *_label;
    Reachability *_reach;

}
@end

@implementation UserFeedbackController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}

- (void)setUI
{
    self.title = @"意见反馈";
    UITextView *textView = [[UITextView alloc]initWithFrame:self.view.frame];
    [textView becomeFirstResponder];
    textView.font = [UIFont systemFontOfSize:20];
    textView.delegate = self;
    _textView = textView;
    [self.view addSubview:textView];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 44)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"您的反馈是我们前进的方向";
    label.textColor = [UIColor lightGrayColor];
    _label = label;
    [self.view addSubview:label];
    

    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc]initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(sendClick)];
    self.navigationItem.rightBarButtonItem = buttonItem;
    
    
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length > 0) {
        _label.hidden = YES;
    }else{
        _label.hidden = NO;
    }
}

- (void)sendClick
{
    if (_textView.text.length >0) {
        [self networkingTest];
    }else
    {
        [SVProgressHUD setMinimumDismissTimeInterval:1];
        [SVProgressHUD showErrorWithStatus:@"请输入文字后再发送"];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
