//
//  SearchPreviewController.m
//  Image viewer
//
//  Created by ZC on 2016/9/27.
//  Copyright © 2016年 zc. All rights reserved.
//

#import "SearchPreviewController.h"

@interface SearchPreviewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) UITableView *resultTableView;
@end

@implementation SearchPreviewController

- (UITableView *)resultTableView
{
    if (!_resultTableView)
    {
        UITableView *tb = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        tb.delegate = self;
        tb.dataSource = self;
        tb.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
        tb.separatorStyle = UITableViewCellSeparatorStyleNone;
        tb.tableHeaderView = [[UIView alloc]init];
        tb.backgroundColor = [UIColor clearColor];
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        tb.backgroundView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
        [self.view addSubview:tb];
        
        [tb registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
        
        _resultTableView = tb;
    }
    
    return _resultTableView;
}

- (void)setSearchResultArray:(NSArray *)searchResultArray
{
    _searchResultArray = searchResultArray;
    
    [self.resultTableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _searchResultArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.backgroundColor = [UIColor clearColor];

    cell.textLabel.text = _searchResultArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    SearchResultController *searchResultController = [[SearchResultController alloc]initWithString:cell.textLabel.text];
    [self dismissViewControllerAnimated:NO completion:nil];
    if (_backToLastController) {
        _backToLastController(searchResultController);
    }

    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
