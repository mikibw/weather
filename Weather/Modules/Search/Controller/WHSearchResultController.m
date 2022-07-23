//
//  WHSearchResultController.m
//  Weather
//
//  Created by shoujian on 2021/3/13.
//

#import "WHSearchResultController.h"
#import "WHSearchCityViewModel.h"
#import "WHSearchFieldView.h"

static NSString *cellID = @"searchResultCellID";

@interface WHSearchResultController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) WHSearchFieldView *searchView;

@property (nonatomic,strong) WHSearchCityViewModel *searchViewModel;
@property (nonatomic,strong) NSArray *resultArr;

@end

@implementation WHSearchResultController

- (void)dealloc{
    NSLog(@"delloc %@",self);
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.searchView.bounds = CGRectMake(0, 0, self.view.bounds.size.width - 40, 44);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] init];
    
    self.navigationItem.titleView = self.searchView = [[WHSearchFieldView alloc] init];
    
    [self.searchView.textField becomeFirstResponder];
    self.searchView.textField.delegate = self;
    
    @weakify(self)
    [[self.searchView.textField rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
        @strongify(self)
        if (x.length>1) {
            [self.searchViewModel.searchCityCommand execute:x];
        }
    }];
    //获取到搜索后的结果
    [self.searchViewModel.searchCityCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        self.resultArr = x;
        [self.tableView reloadData];
    }];
    //键盘按钮搜索
    [[self rac_signalForSelector:@selector(textFieldShouldReturn:) fromProtocol:@protocol(UITextFieldDelegate)] subscribeNext:^(RACTuple * _Nullable x) {
        @strongify(self)
        //键盘点完成
        if (self.resultArr.count) {
            if (self.routesCompletion) {
                self.routesCompletion(YES, self.resultArr.firstObject);
            }
            [self.navigationController popViewControllerAnimated:NO];
        }
    }];
    
    [[self.searchView.cancelBtn rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self.navigationController popViewControllerAnimated:NO];
    }];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = UIView.new;
    [_tableView registerClass:UITableViewCell.class forCellReuseIdentifier:cellID];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.resultArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.backgroundColor = UIColor.clearColor;
    WHPositionModel *model = [self.resultArr objectAtIndex:indexPath.row];
    cell.textLabel.text = model.path;
    cell.textLabel.font = [UIFont systemFontOfSize:13 weight:(UIFontWeightLight)];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 32;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.navigationController popViewControllerAnimated:NO];
    if (self.routesCompletion) {
        self.routesCompletion(YES, [self.resultArr objectAtIndex:indexPath.row]);
    }
}

- (WHSearchCityViewModel *)searchViewModel{
    if (!_searchViewModel) {
        _searchViewModel = WHSearchCityViewModel.new;
    }
    return _searchViewModel;
}

- (NSArray *)resultArr{
    if (!_resultArr) {
        _resultArr = [NSArray new];
    }
    return _resultArr;
}
@end
