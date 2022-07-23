//
//  WHSearchViewController.m
//  Weather
//
//  Created by shoujian on 2021/3/13.
//

#import "WHSearchViewController.h"
#import "WHSearchTableViewCell.h"

#import "WHSearchResultController.h"
#import "WHPositionStorage.h"
#import "WHRealtimeInfoViewModel.h"
#import "UITableViewCell+Extensions.h"

@interface WHSearchViewController () <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@end

@interface WHSearchViewController ()
@property (nonatomic, strong) NSMutableArray *positionArr;
@property (nonatomic, strong) WHPositionModel *currentPostion;
@property (nonatomic, strong) WHPositionManager *positionManager;
@end

@implementation WHSearchViewController

- (void)dealloc
{
    NSLog(@"delloc %@",self);
}

- (BOOL)showsNavigationBar
{
    return NO;
}

- (NSMutableArray *)positionArr
{
    if (!_positionArr) {
        _positionArr = [NSMutableArray new];
    }
    return _positionArr;
}

- (WHPositionManager *)positionManager
{
    if (!_positionManager) {
        _positionManager = [[WHPositionManager alloc] init];
    }
    return _positionManager;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupUI];
    [self bind];
}

- (void)setupUI
{
    _editBtn.backgroundColor = [UIColor colorWithHex:0xFFFFFF alpha:0.67];
    _editBtn.layer.borderColor = [UIColor colorWithHex:0x3370FF alpha:0.67].CGColor;
    _editBtn.layer.borderWidth = 1.f;
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerNib:WHSearchTableViewCell.nib forCellReuseIdentifier:WHSearchTableViewCell.identifier];

    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 20)];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 20)];
    
    [self.positionArr addObjectsFromArray:WHPositionStorage.sharedStorage.storedPostions];
    
    [self freshTableView];
}

- (void)bind
{
    @weakify(self)
    
    [[self.backBtn rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [[self.editBtn rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        self.tableView.editing = !self.tableView.editing;
        if (self.tableView.editing) {
            [self.editBtn setTitle:@"完成" forState:(UIControlStateNormal)];
        }else{
            [self.editBtn setTitle:@"编辑" forState:(UIControlStateNormal)];
        }
    }];
    
    _textField.delegate = self;
    [[self rac_signalForSelector:@selector(textFieldShouldBeginEditing:) fromProtocol:@protocol(UITextFieldDelegate)] subscribeNext:^(RACTuple * _Nullable x) {
        @strongify(self)
        [WHRouter.sharedRouter open:routesInit(WHRoutePostionSearchResult, nil) completion:^(BOOL success, id position) {
            @strongify(self)
            WHPositionModel *model = position;
            __block id existedModel = nil;
            [self.positionArr enumerateObjectsUsingBlock:^(WHPositionModel *obj, NSUInteger idx, BOOL *stop) {
                if ([obj.id isEqualToString:model.id]) { existedModel = obj; *stop = YES; }
            }];
            if (existedModel) [self.positionArr removeObject:existedModel];
            [self.positionArr insertObject:model atIndex:0];
            [self freshTableView];
            [WHPositionStorage.sharedStorage storePositions:self.positionArr];
        }];
    }];
    
    [self.positionManager.rac_positionChanged subscribeNext:^(WHPositionModel * _Nullable x) {
        @strongify(self)
        self.currentPostion = x;
        [self freshTableView];
    }];
}

//刷新列表
- (void)freshTableView
{
    [self.tableView reloadData];
    [self.tableView layoutIfNeeded];
    
    CGFloat safeNum = 0;
    if (@available(iOS 11.0, *)) {
        UIEdgeInsets safeArea = [[UIApplication sharedApplication] keyWindow].safeAreaInsets;
        safeNum = safeArea.bottom;
    }
    CGFloat max = UIScreen.mainScreen.bounds.size.height - 202 - safeNum;
    CGFloat height = self.tableView.contentSize.height;
    if (height < 86) {
        height = height + 40;
    }
    self.tableViewHeight.constant = MIN(height,max);
    if (self.positionArr.count == 0 && !self.currentPostion) {
        self.tableViewHeight.constant = 0;
    }
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (self.currentPostion ? 1 : 0) + self.positionArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WHSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:WHSearchTableViewCell.identifier forIndexPath:indexPath];
    WHPositionModel *position;
    if (self.currentPostion) {
        if (indexPath.row == 0) {
            position = self.currentPostion;
        } else {
            position = [self.positionArr objectAtIndex:indexPath.row - 1];
        }
    } else {
        position = [self.positionArr objectAtIndex:indexPath.row];
    }
    cell.pathLabel.text = [position.path substringFromIndex:position.name.length + 1];
    cell.nameLabel.text = position.name;
    
    cell.locationIgvWidth.constant = position == self.currentPostion ? 10 : 0;
    
    @weakify(cell)
    [cell setRealtimeWeatherWithPosition:position before:^{
        @strongify(cell)
        cell.codeImageView.image = nil;
        cell.descLabel.text = nil;
        cell.temoeratureLabel.text = nil;
    } completion:^(WHRealtimeInfoModel *model) {
        @strongify(cell)
        cell.codeImageView.image = [UIImage weatherLineWithCode:model.code];
        cell.descLabel.text = model.text;
        cell.temoeratureLabel.text = [model.temperature stringByAppendingString:@"℃"];
    }];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 86;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WHPositionModel *position;
    if (self.currentPostion) {
        if (indexPath.row == 0) {
            position = self.currentPostion;
        } else {
            position = [self.positionArr objectAtIndex:indexPath.row - 1];
        }
    } else {
        position = [self.positionArr objectAtIndex:indexPath.row];
    }
    if (self.routesCompletion) {
        self.routesCompletion(YES, position);
        [WHPositionStorage.sharedStorage storePosition:position];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.currentPostion && indexPath.row == 0) {
        return NO;
    } else {
        return YES;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    WHPositionModel *position;
    if (self.currentPostion) {
        position = [self.positionArr objectAtIndex:indexPath.row - 1];
    } else {
        position = [self.positionArr objectAtIndex:indexPath.row];
    }
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.positionArr removeObject:position];
        [self freshTableView];
        [WHPositionStorage.sharedStorage storePositions:self.positionArr];
    }
    if (self.positionArr.count == 0) {
        self.tableView.editing = NO;
        [self.editBtn setTitle:@"编辑" forState:(UIControlStateNormal)];
    }
}

@end
