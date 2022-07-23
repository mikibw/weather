//
//  WHSubscribeGuideViewController.m
//  Weather
//
//  Created by shoujian on 2021/3/10.
//

#import "WHSubscribeGuideViewController.h"
#import "WHSubscribeCommentCell.h"
#import "WHTimerCountDownView.h"
#import "WHSubscribeManager.h"
#import "WHGrandientButton.h"
#import "STRIAPManager.h"

#define maxSection 10000

@interface WHSubscribeGuideViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIView *timerView;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet WHGrandientButton *subcribeBtn;
@property (weak, nonatomic) IBOutlet UILabel *recommendLabel;

@property (nonatomic,strong) NSTimer *timer;

@property (nonatomic,assign) BOOL presentedStayPage;

@end

@implementation WHSubscribeGuideViewController
- (BOOL)showsNavigationBar{
    return NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [WHEventTracker.sharedTracker enterSellPage];
    
    [WHSubscribeManager.sharedInstance stopPopUpTimer];
    
    [self setupUI];
    [self createTimerView];
    
    NSMutableAttributedString *mutableAttStr = [NSMutableAttributedString new];
    NSAttributedString *attGrayBegin = [[NSAttributedString alloc]initWithString:@"已有" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0x666666 alpha:1],NSFontAttributeName:[UIFont systemFontOfSize:13]}];
    [mutableAttStr appendAttributedString:attGrayBegin];
    NSAttributedString *attBlue = [[NSAttributedString alloc]initWithString:@" 397299 " attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0x00A3FF alpha:1],NSFontAttributeName:[UIFont systemFontOfSize:13]}];
    [mutableAttStr appendAttributedString:attBlue];
    NSAttributedString *attGrayEnd = [[NSAttributedString alloc]initWithString:@"位正在使用天气预报的伙伴向你推荐" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0x666666 alpha:1],NSFontAttributeName:[UIFont systemFontOfSize:13]}];
    [mutableAttStr appendAttributedString:attGrayEnd];

    self.recommendLabel.attributedText = mutableAttStr;
    
}

- (void)setupUI{
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass(WHSubscribeCommentCell.class) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass(WHSubscribeCommentCell.class)];
    
    _layout.minimumLineSpacing = 0;
    _layout.minimumInteritemSpacing = 0;
    
    _layout.itemSize = CGSizeMake(UIScreen.mainScreen.bounds.size.width, 180);
    _closeBtn.hidden = YES;
    
    @weakify(self)
    
    [WHSubscribeManager.sharedInstance.getVersion subscribeNext:^(WHSubscribeVersionModel *x) {
        @strongify(self)
        id subscribeButtonTitle = x.is_onlie ? x.button_desc_online : x.button_desc;
        [self.subcribeBtn setTitle:subscribeButtonTitle forState:UIControlStateNormal];
    }];
    
    //订阅按钮
    [[_subcribeBtn rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [WHEventTracker.sharedTracker clickSubscribeButton];
        [SVProgressHUD show];
        [WHSubscribeManager.sharedInstance subscribe:^(WHSubscribeResult result) {
            @strongify(self)
            [SVProgressHUD dismiss];
            switch (result) {
                case WHSubscribeResultSuccess: {
                    [WHEventTracker.sharedTracker subscribeSuccess];
                    [SVProgressHUD showSuccessWithStatus:@"订阅成功"];
                    if (self.routesCompletion) {
                        self.routesCompletion(YES, nil);
                    } else {
                        [self dismissViewControllerAnimated:YES completion:nil];
                    }
                    break;
                }
                case WHSubscribeResultFailure: {
                    [SVProgressHUD showInfoWithStatus:@"订阅失败"];
                    break;
                }
                case WHSubscribeResultCancelled: {
                    [SVProgressHUD showInfoWithStatus:@"订阅取消"];
                    [WHSubscribeManager.sharedInstance.getVersion subscribeNext:^(WHSubscribeVersionModel *x) {
                        @strongify(self)
                        if (!x.is_onlie) return;
                        [self dismissViewControllerAnimated:YES completion:^{
                            @strongify(self)
                            [WHRouter.sharedRouter open:routesInit(WHRouteSubscribeStay, nil)
                                             completion:self.routesCompletion];
                        }];
                    }];
                    break;
                }
            }
        }];
        
    }];
    
    [self shakeToShow:self.subcribeBtn];
    
    [self addTimer];
}
- (void)shakeToShow:(UIView *)aView{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 1.2;
    animation.repeatCount = MAXFLOAT;
    animation.removedOnCompletion = NO;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.05, 1.05, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.05, 1.05, 1.0)]];
    animation.values = values;
    [aView.layer addAnimation:animation forKey:nil];
}
#pragma mark - private
- (void)createTimerView{
    WHTimerCountDownView *countDownView = [[WHTimerCountDownView alloc]initTimeNum:5 frame:CGRectMake(0, 0, 40, 40) completion:^{
        self.closeBtn.hidden = NO;
    }];
    [_timerView addSubview:countDownView];
}
#pragma mark - event

- (IBAction)serviceBtn:(id)sender
{
    NSLog(@"服务条款");
    [WHRouter.sharedRouter open:routesInit(WHRouteServiceItem, nil)];
}

- (IBAction)privacyBtn:(id)sender
{
    NSLog(@"隐私协议");
    [WHRouter.sharedRouter open:routesInit(WHRoutePravicy, nil)];
}

- (IBAction)resumeBuyBtn:(id)sender
{
    [SVProgressHUD show];
    @weakify(self)
    [WHSubscribeManager.sharedInstance restore:^(BOOL success) {
        @strongify(self)
        [SVProgressHUD dismiss];
        success ? [SVProgressHUD showSuccessWithStatus:@"恢复购买成功"] : [SVProgressHUD showInfoWithStatus:@"您没有任何订阅内容"];
        if (!success) return;
        if (self.routesCompletion) {
            self.routesCompletion(YES, nil);
        } else {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

- (IBAction)closeBtnClick:(id)sender
{
    //关闭后开启自动弹框订阅
    [WHSubscribeManager.sharedInstance startPopUpTimer];
    if (self.routesCompletion) {
        self.routesCompletion(NO, nil);
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return maxSection;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 3;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WHSubscribeCommentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(WHSubscribeCommentCell.class) forIndexPath:indexPath];
    NSString *nickName = @"";
    NSString *avartarName = @"";
    NSString *commentStr = @"";
    switch (indexPath.row) {
        case 0:
            nickName = @"黄甜甜";
            commentStr = @"用这款天气软件很长时间了，预测很准，说下雨就下雨，平时做户外活动都要先查一下这个app，基本没误过事儿，感谢开发者";
            avartarName = @"weather_shouqian_tx1";
            break;
        case 1:
            nickName = @"多面鱼";
            commentStr = @"天气查询功能很强大，信息很丰富，界面简洁美观，同类型的app里面这个是我用过的最好的，很良心的软件";
            avartarName = @"weather_shouqian_tx2";
            break;
        case 2:
            nickName = @"海王";
            commentStr = @"天气实时播报很准确，里面查限号什么的也很方便，我一般早上起来先看这个软件，下雨就马上去开车，没下雨就再睡十分钟，生活已经离不开它了，推荐给大家";
            avartarName = @"weather_shouqian_tx3";
            break;
            
        default:
            break;
    }
    cell.nickNameLabel.text = nickName;
    cell.commentLabel.text = commentStr;
    cell.avartarIgv.image = [UIImage imageNamed:avartarName];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.pageControl.currentPage = indexPath.row;
}

#pragma mark 添加定时器

- (void)addTimer
{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(nextpage) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    self.timer = timer;
}

- (void)removeTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self removeTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self addTimer];
}

#pragma mark 设置页码

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int page = (int) (scrollView.contentOffset.x/scrollView.frame.size.width+0.5)%3;
    self.pageControl.currentPage = page;
}

- (void)nextpage
{
    NSIndexPath *currentIndexPath = [[self.collectionView indexPathsForVisibleItems] lastObject];

    NSIndexPath *currentIndexPathReset = [NSIndexPath indexPathForItem:currentIndexPath.item inSection:maxSection/2];
    [self.collectionView scrollToItemAtIndexPath:currentIndexPathReset atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];

    NSInteger nextItem = currentIndexPathReset.item + 1;
    NSInteger nextSection = currentIndexPathReset.section;
    if (nextItem==3) {
        nextItem=0;
        nextSection++;
    }
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:nextItem inSection:nextSection];
    
    [self.collectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
}

@end
