//
//  WHLifeIndexViewController.m
//  Weather
//
//  Created by Liang Tang on 2021/3/11.
//

#import "WHLifeIndexViewController.h"
#import "WHLifeIndexViewModel.h"
#import "WHLifeIndexCell.h"

@interface WHLifeIndexViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (nonatomic, assign) int selectedIndex;
@property (nonatomic, strong) WHLifeIndexViewModel *viewModel;
@end

@interface WHLifeIndexViewController ()
@property (nonatomic, assign) int colums;
@property (nonatomic, assign) CGFloat padding;
@property (nonatomic, assign) CGFloat itemHeight;
@property (weak, nonatomic) IBOutlet UIStackView *categoryView;
@property (weak, nonatomic) IBOutlet UICollectionView *lifeIndexView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lifeIndexViewHeightConstraint;
@property (strong, nonatomic) NSLayoutConstraint *heightConstraint;
@end

@implementation WHLifeIndexViewController

@synthesize refresh = _refresh;
- (RACReplaySubject *)refresh
{
    if (!_refresh) {
        _refresh = [RACReplaySubject replaySubjectWithCapacity:1];
    }
    return _refresh;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupUI];
    [self bind];
}

- (void)setupUI
{
    self.view.hidden = YES;
    
    self.heightConstraint = [self.view.heightAnchor constraintEqualToConstant:398];
    self.heightConstraint.active = YES;
    
    [self.lifeIndexView registerNib:WHLifeIndexCell.nib forCellWithReuseIdentifier:WHLifeIndexCell.identifier];
}

- (void)bind
{
    self.selectedIndex = 0;
    self.colums = 3;
    self.padding = 8;
    self.itemHeight = 122;
    
    _viewModel = [[WHLifeIndexViewModel alloc] init];
    
    @weakify(self)
    [self.refresh subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.viewModel.fetchLifeIndex execute:x];
    }];
    
    [self.viewModel.fetchLifeIndex.executionSignals.switchToLatest subscribeNext:^(NSArray * _Nullable x) {
        @strongify(self)
        if (x.count) {
            self.view.hidden = NO;
        } else {
            self.view.hidden = YES;
            self.lifeIndexView.dataSource = nil;
            self.lifeIndexView.delegate = nil;
        }
        [self setupCategoryButtons];
    }];
    
    [RACObserve(self, selectedIndex) subscribeNext:^(NSNumber * _Nullable x) {
        @strongify(self)
        if (self.viewModel.groups.count == 0) return;
        [self changeCategory:[self.categoryView.arrangedSubviews objectAtIndex:x.intValue]];
        [self reloadLifeIndexView];
    }];
}

- (void)setupCategoryButtons
{
    NSArray *subviews = self.categoryView.arrangedSubviews.copy;
    for (UIView *subview in subviews) [subview removeFromSuperview];
    
    [self.viewModel.groups enumerateObjectsUsingBlock:^(WHLifeIndexGroupModel *group, NSUInteger index, BOOL *stop) {
        UIButton *button = [[UIButton alloc] init];
        button.layer.cornerRadius = 8;
        button.layer.borderColor = UIColor.mainBorderColor.CGColor;
        button.titleLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightLight];
        [button setTitle:group.category forState:UIControlStateNormal];
        [button addTarget:self action:@selector(selectCategory:) forControlEvents:UIControlEventTouchUpInside];
        [self.categoryView addArrangedSubview:button];
    }];
    
    self.selectedIndex = 0;
}

- (void)selectCategory:(UIButton *)button
{
    if (WHSubscribeManager.sharedInstance.isSubscribed) {
        self.selectedIndex = (int)[self.categoryView.arrangedSubviews indexOfObject:button];
    } else {
        [WHRouter.sharedRouter open:routesInit(WHRouteSubscribeGuide, nil)];
    }
}

- (void)changeCategory:(UIButton *)button
{
    NSArray *buttons = self.categoryView.arrangedSubviews;
    for (UIButton *button in buttons) {
        button.layer.borderWidth = 0;
        [button setTitleColor:UIColor.darkTextColor forState:UIControlStateNormal];
    }
    button.layer.borderWidth = 1;
    [button setTitleColor:UIColor.mainBorderColor forState:UIControlStateNormal];
}

- (void)reloadLifeIndexView
{
    NSInteger count = self.viewModel.groups[self.selectedIndex].items.count;
    NSInteger rows = (count + self.colums - 1) / self.colums;
    rows = MAX(1, rows);
    self.lifeIndexViewHeightConstraint.constant = rows * self.itemHeight + (rows - 1) * self.padding;
    
    self.lifeIndexView.dataSource = self;
    self.lifeIndexView.delegate = self;
    
    [self.view layoutIfNeeded];
    [self.lifeIndexView layoutIfNeeded];
    [self.lifeIndexView reloadData];
    
    self.heightConstraint.constant = self.lifeIndexViewHeightConstraint.constant + 145;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.viewModel.groups[self.selectedIndex].items.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WHLifeIndexCell *cell = [self.lifeIndexView dequeueReusableCellWithReuseIdentifier:WHLifeIndexCell.identifier forIndexPath:indexPath];
    cell.lifeIndexItem = self.viewModel.groups[self.selectedIndex].items[indexPath.item];
    return cell;
}

#pragma mark - UICollectionViewDataSource
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (WHSubscribeManager.sharedInstance.isSubscribed) {
        WHLifeIndexItemModel *item = self.viewModel.groups[self.selectedIndex].items[indexPath.item];
        [WHRouter.sharedRouter open:routesInit(WHRouteLifeIndexPopUp, item)];
    } else {
        [WHRouter.sharedRouter open:routesInit(WHRouteSubscribeGuide, nil)];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((self.lifeIndexView.bounds.size.width - (self.colums - 1) * self.padding) / self.colums, self.itemHeight);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return self.padding;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return self.padding;
}


@end
