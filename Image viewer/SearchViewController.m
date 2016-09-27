//
//  SearchViewController.m
//  Image viewer
//
//  Created by ZC on 2016/9/27.
//  Copyright © 2016年 zc. All rights reserved.
//

#import "SearchViewController.h"
#import "AFNetworking.h"
#import "TitleViewCell.h"
#import "Config.h"
#import "SearchPreviewController.h"
#import "SearchResultController.h"

@interface SearchViewController () <UISearchResultsUpdating,UISearchBarDelegate,UICollectionViewDelegate, UICollectionViewDataSource>
{
    //搜索结果界面
    SearchPreviewController *_searchPreviewController;
    
    
}
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, weak) UILabel *hotSearchLabel;
@property (nonatomic, weak) UILabel *searchHistoryLabel;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *searchResultArray;
@property (nonatomic, strong) NSMutableArray *historyArray;
@property (nonatomic, strong) NSArray *pinyinHistoryArray;
@end


@implementation SearchViewController


-(instancetype)initWithString:(NSString *)string
{
    self = [super init];
    if (self) {
        
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self searchController];
    [self requestDataFromeNetorking:kHotSearchUrlString];
    
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hotSearchLabel];
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"SearchHistory"] count] > 0) {
        [self searchHistoryLabel];
    }
    
}

- (void)requestDataFromeNetorking:(NSString *)urlStr
{
    [[AFHTTPSessionManager manager] GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self handleDataObjectWithReponseObject:responseObject];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self historyArray];
            [self pinyinHistoryArray];
            
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"网络错误" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:@"刷新", nil] show];
    }];
    
    
}

- (void)handleDataObjectWithReponseObject:(id)responseObject
{
    
    self.dataSource = responseObject[@"res"][@"keyword"][0][@"items"];
    for (NSString *str in _dataSource) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self saveHotSearch:str];
        });
    }
    [self.collectionView reloadData];
    
}

-(UISearchController *)searchController
{
    if (!_searchController) {
        SearchPreviewController *searchPreviewController = [[SearchPreviewController alloc]init];
        searchPreviewController.backToLastController = ^(SearchResultController *vc){
            [self.navigationController pushViewController:vc animated:YES];
        };
        _searchPreviewController = searchPreviewController;
        _searchController = [[UISearchController alloc]initWithSearchResultsController:searchPreviewController];
        _searchController.searchBar.placeholder = @"请输入要搜索的内容";
        _searchController.searchResultsUpdater = self;
        _searchController.searchBar.delegate = self;
        UIView *searchBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 , SCREEN_WIDTH,_searchController.searchBar.frame.size.height)];
        [searchBarView addSubview: _searchController.searchBar];
        [self.collectionView addSubview:searchBarView];
        
    }
    return _searchController;
}


- (UICollectionView *)collectionView
{
    if (!_collectionView)
    {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        
        layout.sectionInset = UIEdgeInsetsMake(80, 20, 10, 20);
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        collectionView.backgroundColor = [UIColor whiteColor];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        
        [self.view addSubview:collectionView];
        
        [collectionView registerNib:[UINib nibWithNibName:@"TitleViewCell" bundle:nil] forCellWithReuseIdentifier:@"TitleViewCell"];
        _collectionView = collectionView;
        
        
    }
    
    return _collectionView;
}

-(UILabel *)hotSearchLabel
{
    if (!_hotSearchLabel) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 35)];
        label.text = @"大家都在搜(点击搜索)";
        label.textColor = [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1];
        label.textAlignment = NSTextAlignmentCenter;
        [self.collectionView addSubview:label];
        _hotSearchLabel = label;
    }
    return _hotSearchLabel;
}

-(UILabel *)searchHistoryLabel
{
    if (!_searchHistoryLabel) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 230, SCREEN_WIDTH, 35)];
        label.text = @"历史搜索记录";
        label.textColor = [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1];
        label.textAlignment = NSTextAlignmentCenter;
        [self.collectionView addSubview:label];
        _searchHistoryLabel = label;
    }
    return _searchHistoryLabel;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.dataSource.count;
    }
    NSArray *arr = [[NSUserDefaults standardUserDefaults] valueForKey:@"SearchHistory"];
    return arr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TitleViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TitleViewCell" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        cell.titleLabel.text = self.dataSource[indexPath.item];
        return cell;
    }
    
    NSArray *arr = [[NSUserDefaults standardUserDefaults] valueForKey:@"SearchHistory"];
    cell.titleLabel.text = arr[arr.count - 1 - indexPath.item];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *title = [NSString string];
    if (indexPath.section == 0) {
        title = self.dataSource[indexPath.item];
    }
    else{
        NSArray *arr = [[NSUserDefaults standardUserDefaults] valueForKey:@"SearchHistory"];
        title = arr[arr.count - 1 -indexPath.item];
    }
    
    
    CGSize size = [title boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 60, 50) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size;
    
    return CGSizeMake(size.width + 30, size.height + 10);
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SearchResultController *searchResultController = nil;
    if (indexPath.section == 0) {
        [self saveSearchHistory:_dataSource[indexPath.item]];
        searchResultController = [[SearchResultController alloc]initWithString:_dataSource[indexPath.item]];
    }else {
        NSArray *arr = [[NSUserDefaults standardUserDefaults] valueForKey:@"SearchHistory"];
        [self saveSearchHistory:arr[arr.count - 1 - indexPath.item]];
        searchResultController = [[SearchResultController alloc]initWithString:arr[arr.count - 1 - indexPath.item]];
    }
    
    
    [self.navigationController pushViewController:searchResultController animated:YES];

    [self.collectionView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    _searchResultArray = [NSMutableArray array];
    NSString *searchText = searchController.searchBar.text;
    for (int i = 0 ; i < self.historyArray.count; i++) {
        if ([self.historyArray[i] rangeOfString:searchText].location != NSNotFound||[self.pinyinHistoryArray[i] rangeOfString:[searchText lowercaseString]].location != NSNotFound) {
            [_searchResultArray addObject:self.historyArray[i]];
        }
    }

    if (_searchResultArray.count > 0) {
        
    }
    _searchPreviewController.searchResultArray = _searchResultArray;
    
}


- (NSArray *)converToPinyin:(NSArray *)arr
{
    NSMutableArray *arrM = [NSMutableArray array];
    
    for (NSMutableString *str in arr) {
        NSMutableString *mutaleString = [str mutableCopy];
        CFStringTransform((CFMutableStringRef)mutaleString, NULL, kCFStringTransformMandarinLatin, false);
        CFStringTransform((CFMutableStringRef)mutaleString, NULL, kCFStringTransformStripDiacritics, false);
        NSArray *arr = [mutaleString componentsSeparatedByString:@" "];
        NSString *string = [arr componentsJoinedByString:@""];
        [arrM addObject:string];
    }
    return arrM;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.searchController dismissViewControllerAnimated:NO completion:nil];
    [self saveSearchHistory:searchBar.text];

    SearchResultController *searchResultController = [[SearchResultController alloc]initWithString:searchBar.text];
    [self.navigationController pushViewController:searchResultController animated:YES];
    self.collectionView = nil;
    [self.collectionView reloadData];
}

- (void)saveSearchHistory:(NSString *)string
{
    NSMutableArray *arrM = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] valueForKey:@"SearchHistory"]];
    [arrM enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isEqualToString:string]) {
            [arrM removeObject:string];
        }
    }];
    [arrM addObject:string];
    [[NSUserDefaults standardUserDefaults] setObject:arrM forKey:@"SearchHistory"];
}

- (void)saveHotSearch:(NSString *)string
{
    NSMutableArray *arrM = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] valueForKey:@"HotSearch"]];
    [arrM enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isEqualToString:string]) {
            [arrM removeObject:string];
        }
    }];
    [arrM addObject:string];
    [[NSUserDefaults standardUserDefaults] setObject:arrM forKey:@"HotSearch"];
}

-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
    
}

-(NSMutableArray *)historyArray
{
    if (!_historyArray) {
        
        NSMutableArray *arr1 = [[NSUserDefaults standardUserDefaults] valueForKey:@"SearchHistory"];
        NSMutableArray *arr2 = [[NSUserDefaults standardUserDefaults] valueForKey:@"HotSearch"];
        _historyArray = [NSMutableArray array];
        [_historyArray addObjectsFromArray:arr1];
        [_historyArray addObjectsFromArray:arr2];
        
        for (int i = 0; i < _historyArray.count - 1; i++) {
            for (int j = i+1; j < _historyArray.count; j++) {
                if ([_historyArray[i] isEqualToString:_historyArray[j]]) {
                    [_historyArray removeObjectAtIndex:j];
                    j--;
                }
                
            }
        }
    
        
    }
    return _historyArray;
}


-(NSArray *)pinyinHistoryArray
{
    if (!_pinyinHistoryArray) {
        _pinyinHistoryArray = [self converToPinyin:self.historyArray];
    }
    return _pinyinHistoryArray;
}

@end
