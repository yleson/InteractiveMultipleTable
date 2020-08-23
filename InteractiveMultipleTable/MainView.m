//
//  MainView.m
//  InteractiveMultipleTable
//
//  Created by yleson on 2020/8/23.
//

#import "MainView.h"
#import "MainDataModel.h"
#import "SectionItemCell.h"
#import "SectionListView.h"
#import <TYCyclePagerView.h>
#import <TYPageControl.h>
#import <Masonry.h>

@interface MainView() <TYCyclePagerViewDelegate, TYCyclePagerViewDataSource>

/// 切换视图
@property (nonatomic, strong) TYCyclePagerView *pageView;
/// 分页指示器
@property (nonatomic, strong) TYPageControl *controlView;

/// 当前拖动是哪种cell：[1-UICollectionViewCell; 2-UITableViewCell]
@property (nonatomic, assign) NSInteger moveCellType;
///当前长按选中cell截图
@property (nonatomic, strong) UIView *snapshotView;

/// 当前长按选中cell所在TableView上的位置
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
/// 长按开始时选中cell所在TableView上的位置
@property (nonatomic, assign) NSInteger originalSelectedIndexPathSection;
/// 长按开始时选中cell所在TableView上的位置
@property (nonatomic, assign) NSInteger originalCollectionViewCellRow;
/// 当前长按选中cell所在的CollectionViewCell的行数
@property (nonatomic, assign) NSInteger selectedCollectionViewCellRow;
/// 边缘滚动触发范围，默认120
@property (nonatomic, assign) CGFloat edgeScrollRange;
/// 定时器
@property (nonatomic, strong) CADisplayLink *edgeScrollTimer;
/// 长按手势
@property (nonatomic, strong) UILongPressGestureRecognizer *longPress;
/// 长按时上一次手指所在的位置
@property (nonatomic, assign) CGPoint previousPoint;


@end

@implementation MainView


#pragma mark - 懒加载
- (TYCyclePagerView *)pageView {
    if (!_pageView) {
        _pageView = [[TYCyclePagerView alloc]init];
        _pageView.isInfiniteLoop = NO;
        _pageView.autoScrollInterval = 0;
        _pageView.delegate = self;
        _pageView.dataSource = self;
        [_pageView registerClass:[SectionItemCell class] forCellWithReuseIdentifier:NSStringFromClass([SectionItemCell class])];
    }
    return _pageView;
}

- (TYPageControl *)controlView {
    if (!_controlView) {
        _controlView = [[TYPageControl alloc] init];
        _controlView.currentPageIndicatorSize = CGSizeMake(6, 6);
        _controlView.pageIndicatorSize = CGSizeMake(6, 6);
        _controlView.currentPageIndicatorTintColor = [UIColor lightGrayColor];
        _controlView.pageIndicatorTintColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.6];
    }
    return _controlView;
}

- (UILongPressGestureRecognizer *)longPress {
    if (!_longPress) {
        _longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognized:)];
    }
    return _longPress;
}



- (void)setModel:(MainDataModel *)model {
    _model = model;
    self.controlView.numberOfPages = model.sections.count;
    [self.pageView reloadData];
}

/// 刷新数据
- (void)refreshDatas {
    [self.pageView reloadData];
}

- (instancetype)init {
    if (self = [super init]) {
        _edgeScrollRange = 120;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:self.controlView];
        [self.controlView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.inset(0);
            make.bottom.inset(32);
            make.height.mas_equalTo(20);
        }];
        
        [self addSubview:self.pageView];
        [self.pageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.inset(0);
            make.bottom.mas_equalTo(self.controlView.mas_top).inset(20);
        }];
        
        [self.pageView.collectionView addGestureRecognizer:self.longPress];
    }
    return self;
}



#pragma mark - TYCyclePagerViewDelegate, TYCyclePagerViewDataSource
- (TYCyclePagerViewLayout *)layoutForPagerView:(TYCyclePagerView *)pageView {
    TYCyclePagerViewLayout *layout = [[TYCyclePagerViewLayout alloc] init];
    layout.itemSize = CGSizeMake(self.bounds.size.width - 16 * 4, CGRectGetHeight(pageView.frame));
    layout.itemSpacing = 16;
    layout.sectionInset = UIEdgeInsetsMake(0, 16, 0, 16 * 2);
    return layout;
}

- (NSInteger)numberOfItemsInPagerView:(TYCyclePagerView *)pageView {
    return self.model.sections.count;
}

- (UICollectionViewCell *)pagerView:(TYCyclePagerView *)pagerView cellForItemAtIndex:(NSInteger)index {
    SectionItemCell *cell = [pagerView dequeueReusableCellWithReuseIdentifier: NSStringFromClass([SectionItemCell class]) forIndex:index];
    cell.section = self.model.sections[index];
//    cell.delegate = self;
    cell.indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    return cell;
}

- (void)pagerViewWillBeginDragging:(TYCyclePagerView *)pageView {
    [self endEditing:YES];
}

- (void)pagerView:(TYCyclePagerView *)pageView didSelectedItemCell:(__kindof UICollectionViewCell *)cell atIndex:(NSInteger)index {
    
}

- (void)pagerView:(TYCyclePagerView *)pageView didScrollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    self.controlView.currentPage = toIndex;
}

- (BOOL)pagerViewDidMoveItem:(TYCyclePagerView *)pageView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.row < self.model.sections.count - 1;
}

- (void)pagerViewDidMoveItem:(TYCyclePagerView *)pageView sourceIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    [self.model.sections exchangeObjectAtIndex:sourceIndexPath.item withObjectAtIndex:destinationIndexPath.item];
    [pageView scrollToItemAtIndex:destinationIndexPath.row animate:YES];
//    if ([self.delegate respondsToSelector:@selector(projectDetailTaskCollectionViewDidMoveTaskGroup)]) {
//        [self.delegate projectDetailTaskCollectionViewDidMoveTaskGroup];
//    }
}




#pragma mark - 处理长按拖动
//长按cell事件
- (void)longPressGestureRecognized:(UILongPressGestureRecognizer *)sender {
    CGPoint location = [sender locationInView:sender.view];
    
    UIGestureRecognizerState state = sender.state;
    switch (state) {
        case UIGestureRecognizerStateBegan: {
            [self handleLongPressStateBeganWithLocation:location];
            break;
        }
        case UIGestureRecognizerStateChanged: {
            [self handleLongPressStateChangedWithLocation:location];
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            [self longGestureEndedOrCancelledWithLocation:location];
            break;
        }
        default:
            break;
    }
}

- (void)handleLongPressStateBeganWithLocation:(CGPoint)location {
    SectionItemCell *currentCell = [self currentTouchedCollectionCellWithLocation:location];
    NSIndexPath *touchIndexPath = [self longGestureBeganIndexPathForRowAtPoint:location atTableView:currentCell.taskListView.taskContentView];
    if (!currentCell || !touchIndexPath) {
        if (currentCell) {
            self.moveCellType = 1;
            if (@available(iOS 9.0, *)) {
                [self.pageView.collectionView beginInteractiveMovementForItemAtIndexPath:currentCell.indexPath];
            }
        }
        return;
    }
    self.moveCellType = 2;
    self.selectedCollectionViewCellRow = [self.pageView.collectionView indexPathForCell:currentCell].row;
    
    ItemDataModel *itemModel = currentCell.section.items[touchIndexPath.section];
    itemModel.isHidden = YES;
    
    self.snapshotView = [self snapshotViewWithTableView:currentCell.taskListView.taskContentView atIndexPath:touchIndexPath];
    [self.pageView.collectionView addSubview:self.snapshotView];
    
    self.selectedIndexPath = touchIndexPath;
    self.originalSelectedIndexPathSection = touchIndexPath.section;
    self.originalCollectionViewCellRow = self.selectedCollectionViewCellRow;
    self.previousPoint = CGPointZero;
    
    [self startPageEdgeScroll];
}

- (void)handleLongPressStateChangedWithLocation:(CGPoint)location {
    if (self.moveCellType != 1) return;
    
    if (@available(iOS 9.0, *)) {
        NSInteger KNavigationHeight = 88;
        location.y = KNavigationHeight + KNavigationHeight + 20 + 86;
        if ([UIScreen mainScreen].bounds.size.width > 375) {
            location.y += 38;
        }
        [self.pageView.collectionView updateInteractiveMovementTargetPosition:location];
    }
}

- (void)longGestureEndedOrCancelledWithLocation:(CGPoint)location {
    if (self.moveCellType == 1) {
        if (@available(iOS 9.0, *)) {
            [self.pageView.collectionView endInteractiveMovement];
        }
        return;
    }
    
    SectionItemCell *currentCell = [self currentTouchedCollectionCellWithLocation:location];
    [self.pageView scrollToItemAtIndex:currentCell.indexPath.row animate:YES];
    
    [self stopEdgeScrollTimer];
    
    SectionListItemCell *targetCell = (SectionListItemCell *)[[self selectedCollectionViewCellTableView] cellForRowAtIndexPath:self.selectedIndexPath];
    ItemDataModel *itemModel = self.model.sections[self.selectedCollectionViewCellRow].items[self.selectedIndexPath.section];
    
    // 是否需要请求改变
    if ([self canAdjustPlanRanking]) {
//        if ([self.delegate respondsToSelector:@selector(projectDetailTaskCollectionViewDidMoveTask:seq:targetGroupId:)]) {
//            [self.delegate projectDetailTaskCollectionViewDidMoveTask:selectedModel seq:@(self.selectedIndexPath.section + 1) targetGroupId:@(self.projectDetail.list[self.selectedCollectionViewCellRow].groupId)];
//        }
    }
    CGRect frame = [self snapshotViewFrameWithCell:targetCell];
    frame.origin.x += 10;
    frame.size.width -= 20;
    [UIView animateWithDuration:0.25 animations:^{
        self.snapshotView.transform = CGAffineTransformIdentity;
        self.snapshotView.frame = frame;
    } completion:^(BOOL finished) {
        targetCell.containerView.hidden = NO;
        itemModel.isHidden = NO;
        [self.snapshotView removeFromSuperview];
        self.snapshotView = nil;
    }];
}

- (void)longGestureChanged:(UILongPressGestureRecognizer *)sender {
    CGPoint currentPoint = [sender locationInView:sender.view];
    
    SectionItemCell *currentCell = [self currentTouchedCollectionCellWithLocation:currentPoint];
    if (!currentCell) {
        currentCell = [self collectionViewCellAtRow:self.selectedCollectionViewCellRow];
    }
    SectionItemCell *lasetSelectedCollectionViewCell = [self collectionViewCellAtRow:self.selectedCollectionViewCellRow];
    
    BOOL isTargetTableViewChanged = NO;
    if (self.selectedCollectionViewCellRow != currentCell.indexPath.row) {
        isTargetTableViewChanged = YES;
        self.selectedCollectionViewCellRow = currentCell.indexPath.row;
    }
    
    NSIndexPath *targetIndexPath = [self longGestureChangeIndexPathForRowAtPoint:currentPoint collectionViewCell:currentCell];
    
    NSIndexPath *lastSelectedIndexPath = self.selectedIndexPath;
    SectionItemCell *selectedCollectionViewCell = [self collectionViewCellAtRow:self.selectedCollectionViewCellRow];
    if (isTargetTableViewChanged) {
        if ([[self selectedCollectionViewCellTableView] numberOfSections] > targetIndexPath.section) {
            [[self selectedCollectionViewCellTableView] scrollToRowAtIndexPath:targetIndexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
        }
        
        ItemDataModel *moveModel = self.model.sections[lasetSelectedCollectionViewCell.indexPath.row].items[lastSelectedIndexPath.section];
        SectionDataModel *removeTaskGroupModel = self.model.sections[lasetSelectedCollectionViewCell.indexPath.row];
        [removeTaskGroupModel.items removeObject:moveModel];
        SectionDataModel *insertTaskGroupModel = self.model.sections[self.selectedCollectionViewCellRow];
        [insertTaskGroupModel.items insertObject:moveModel atIndex:targetIndexPath.section];
        [lasetSelectedCollectionViewCell.taskListView.taskContentView deleteSections:[NSIndexSet indexSetWithIndex:lastSelectedIndexPath.section] withRowAnimation:UITableViewRowAnimationNone];
        [selectedCollectionViewCell.taskListView.taskContentView insertSections:[NSIndexSet indexSetWithIndex:targetIndexPath.section] withRowAnimation:UITableViewRowAnimationNone];
    } else {
        BOOL isSameSection = lastSelectedIndexPath.section == targetIndexPath.section;
        UITableViewCell *targetCell = [self tableView:[self selectedCollectionViewCellTableView]
                                selectedCellAtSection:targetIndexPath.section];
        if (isSameSection || !targetCell ) {
            [self modifySnapshotViewFrameWithTouchPoint:currentPoint];
            return;
        }
        
        ItemDataModel *moveModel = self.model.sections[self.selectedCollectionViewCellRow].items[lastSelectedIndexPath.section];
        SectionDataModel *moveTaskGroupModel = self.model.sections[self.selectedCollectionViewCellRow];
        [moveTaskGroupModel.items removeObject:moveModel];
        [moveTaskGroupModel.items insertObject:moveModel atIndex:targetIndexPath.section];
        [selectedCollectionViewCell.taskListView.taskContentView moveSection:lastSelectedIndexPath.section toSection:targetIndexPath.section];
    }
    
    self.selectedIndexPath = targetIndexPath;
    
    [self modifySnapshotViewFrameWithTouchPoint:currentPoint];
}

/// 根据手势坐标，获取当前手势所在的collectionViewCell
- (SectionItemCell *)currentTouchedCollectionCellWithLocation:(CGPoint)location {
    SectionItemCell *currentCollectionViewCell = nil;
    for (SectionItemCell *collectionViewCell in self.pageView.collectionView.visibleCells) {
        CGRect frame = [collectionViewCell convertRect:collectionViewCell.taskListView.taskContentView.frame toView:self.pageView.collectionView];
        if (location.x> CGRectGetMinX(frame) && location.x < CGRectGetMaxX(frame)) {
            currentCollectionViewCell = collectionViewCell;
            break;
        }
    }
    return currentCollectionViewCell;
}

/// 获取长按开始时cell在tableview上的位置
- (NSIndexPath *)longGestureBeganIndexPathForRowAtPoint:(CGPoint)touchPoint atTableView:(UITableView *)tableView {
    CGPoint point = [self.pageView.collectionView convertPoint:touchPoint toView:tableView];
    NSIndexPath *indexPath = [tableView indexPathForRowAtPoint:point];
    return indexPath;
}

/// 获取长按位置改变时cell在tableview上的位置
- (NSIndexPath *)longGestureChangeIndexPathForRowAtPoint:(CGPoint)touchPoint collectionViewCell:(SectionItemCell *)collectionViewCell {
    
    CGPoint point = [self.pageView.collectionView convertPoint:touchPoint toView:collectionViewCell.taskListView.taskContentView];
    __block NSIndexPath *indexPath = [collectionViewCell.taskListView.taskContentView indexPathForRowAtPoint:point];
    
    if (!indexPath) {
        NSInteger numberOfSections = [collectionViewCell.taskListView.taskContentView numberOfSections];
        if (numberOfSections == 0) {
            indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        } else {
            NSIndexPath *maxVisibleIndexPath = [collectionViewCell.taskListView.taskContentView.indexPathsForVisibleRows lastObject];
            CGRect maxSectionRect = [collectionViewCell.taskListView.taskContentView rectForRowAtIndexPath:maxVisibleIndexPath];
            if (point.y > CGRectGetMaxY(maxSectionRect)) {
                indexPath = maxVisibleIndexPath;
            } else {
                BOOL isInVisibleCell = NO;
                for (NSIndexPath *visibleIndexPath  in collectionViewCell.taskListView.taskContentView.indexPathsForVisibleRows) {
                    CGRect sectionRect = [collectionViewCell.taskListView.taskContentView rectForSection:visibleIndexPath.section];
                    if (point.y>CGRectGetMinY(sectionRect) && point.y<CGRectGetMaxY(sectionRect)) {
                        indexPath = visibleIndexPath;
                        isInVisibleCell = YES;
                    }
                }
                if (!isInVisibleCell) {
                    indexPath = [collectionViewCell.taskListView.taskContentView.indexPathsForVisibleRows firstObject];
                }
            }
        }
    }
    return indexPath;
}

/// 修改截屏cell的frame
- (void)modifySnapshotViewFrameWithTouchPoint:(CGPoint)touchPoint {
    if (!CGPointEqualToPoint(self.previousPoint,CGPointZero)) {
        CGPoint newCenter = self.snapshotView.center;
        newCenter.x += (touchPoint.x-self.previousPoint.x);
        newCenter.y += (touchPoint.y-self.previousPoint.y);
        self.snapshotView.center = newCenter;
    }
    self.previousPoint = touchPoint;
}

/// 处理选中的cell快照
- (UIView *)snapshotViewWithTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    SectionListItemCell *selectedCell = (SectionListItemCell *)[tableView cellForRowAtIndexPath:indexPath];
    UIView *snapshotView = [self currentSnapshotViewWithCell:selectedCell];
    selectedCell.containerView.hidden = YES;
    return snapshotView;
}
- (UIView *)currentSnapshotViewWithCell:(SectionListItemCell *)cell {
    UIGraphicsBeginImageContextWithOptions(cell.containerView.bounds.size, NO, 0);
    [cell.containerView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIView *snapshotView = [[UIImageView alloc] initWithImage:image];
    snapshotView.layer.shadowColor = [UIColor grayColor].CGColor;
    snapshotView.layer.masksToBounds = NO;
    snapshotView.layer.cornerRadius = 0;
    snapshotView.layer.shadowOffset = CGSizeMake(-5, 0);
    snapshotView.layer.shadowOpacity = 0.4;
    snapshotView.layer.shadowRadius = 5;
    CGRect frame = [self snapshotViewFrameWithCell:cell];
    frame.origin.x += 10;
    frame.size.width -= 20;
    frame.size.height -= 6;
    snapshotView.frame = frame;
    return snapshotView;
}
- (CGRect)snapshotViewFrameWithCell:(UITableViewCell *)cell {
    return [[self selectedCollectionViewCellTableView] convertRect:cell.frame toView:self.pageView.collectionView];
}
- (UITableView *)selectedCollectionViewCellTableView {
    return [self collectionViewCellAtRow:self.selectedCollectionViewCellRow].taskListView.taskContentView;
}
- (SectionItemCell *)collectionViewCellAtRow:(NSInteger)row {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    return (SectionItemCell *)[self.pageView.collectionView cellForItemAtIndexPath:indexPath];
}
- (UITableViewCell *)tableView:(UITableView *)tableView selectedCellAtSection:(NSInteger)section {
    return  [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
}

/// 初始化定时器
- (void)startPageEdgeScroll {
    self.edgeScrollTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(pageEdgeScrollEvent)];
    [self.edgeScrollTimer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}
/// 响应定时器
- (void)pageEdgeScrollEvent {
    [self longGestureChanged:self.longPress];
    CGFloat snapshotViewCenterOffsetX =  [self touchSnapshotViewCenterOffsetX];
    
    if (fabs(snapshotViewCenterOffsetX) > (45 - 20)) {
        //横向滚动
        [self handleScrollViewHorizontalScroll:self.pageView.collectionView viewCenterOffsetX:snapshotViewCenterOffsetX];
    } else {
        //垂直滚动
        [self handleScrollViewVerticalScroll:[self selectedCollectionViewCellTableView]];
    }
}
/// 销毁定时器
- (void)stopEdgeScrollTimer {
    if (self.edgeScrollTimer) {
        [self.edgeScrollTimer invalidate];
        self.edgeScrollTimer = nil;
    }
}
/// 垂直方向滚动
- (void)handleScrollViewVerticalScroll:(UIScrollView *)scrollView {
    CGFloat contentOffsetY = scrollView.contentOffset.y;
    CGFloat tableViewHeight = CGRectGetHeight(scrollView.bounds);
    //最小偏移量
    CGFloat minOffsetY = contentOffsetY + self.edgeScrollRange;
    //最大偏移量
    CGFloat maxOffsetY = contentOffsetY + tableViewHeight - self.edgeScrollRange;
    //转换坐标
    CGPoint touchPoint = [self.pageView.collectionView convertPoint:self.snapshotView.center toView:scrollView];
    if (touchPoint.y < self.edgeScrollRange) {
        //在顶部的滚动范围内
        //已滚动到最顶部，直接返回
        if (contentOffsetY < 1){
            return;
        }
        [self handleTableView:scrollView isScrollToTop:YES];
        return;
    }
    if (touchPoint.y > (scrollView.contentSize.height-self.edgeScrollRange)) {
        //在底部的滚动范围内
        if (contentOffsetY > (scrollView.contentSize.height-tableViewHeight+CGRectGetHeight(self.snapshotView.frame))) {
            return;
        }
        
        [self handleTableView:scrollView isScrollToTop:NO];
        return;
    }
    BOOL isNeedScrollToTop = touchPoint.y < minOffsetY;
    BOOL isNeedScrollToBottom = touchPoint.y > maxOffsetY;
    
    if (isNeedScrollToTop) {
        //tableView往上滚动
        [self handleTableView:scrollView isScrollToTop:YES];
    } else if (isNeedScrollToBottom) {
        //tableView往下滚动
        [self handleTableView:scrollView isScrollToTop:NO];
    } else {
    }
}
/// 水平方向滚动
- (void)handleScrollViewHorizontalScroll:(UIScrollView *)scrollView viewCenterOffsetX:(CGFloat)viewCenterOffsetX {
    CGFloat contentOffsetX = scrollView.contentOffset.x;
    CGFloat scrollViewWidth = CGRectGetWidth(scrollView.bounds);
    if (viewCenterOffsetX > 0) {
        // 向右边滚动
        // 最后一组不能移动，所以是 - scrollViewWidth * 2
        // 需要保留边距，所以 + kSizeRateNumber(16) * 3
        if (contentOffsetX >= (scrollView.contentSize.width - scrollViewWidth * 2 + 16 * 3)) {
            return;
        }
    } else {
        //向左边滚动
        if (contentOffsetX < 1){
            return;
        }
    }
    CGFloat scrollViewContentOffsetX = scrollView.contentOffset.x + [self scrollDistanceWithOffsetX:viewCenterOffsetX];
    [scrollView setContentOffset:CGPointMake(scrollViewContentOffsetX, scrollView.contentOffset.y) animated:NO];
    return;
}
/// 设置偏移
- (CGFloat)scrollDistanceWithOffsetX:(CGFloat)offsetX {
    CGFloat maxMoveDistance = 20;
    CGFloat maxDistance = ((CGRectGetWidth(self.pageView.collectionView.frame)-20)/2);
    return  maxMoveDistance * (offsetX / maxDistance);
}


- (void)handleTableView:(UIScrollView *)tableView isScrollToTop:(BOOL)isScrollToTop {
    CGFloat distance = 2.0;
    if (isScrollToTop) {
        distance = -distance;
    } else {
//        NSIndexPath *indexPath = [[self selectedCollectionViewCellTableView].indexPathsForVisibleRows lastObject];
//        ItemDataModel *taskModel = self.model.sections[self.selectedCollectionViewCellRow].items[indexPath.section];
//        if (taskModel.state) {
//            return;
//        }
    }
    [tableView setContentOffset:CGPointMake(tableView.contentOffset.x, tableView.contentOffset.y + distance) animated:NO];
}

- (CGFloat)touchSnapshotViewCenterOffsetX {
    CGPoint touchSnapshotViewCenter = [self.pageView.collectionView convertPoint:self.snapshotView.center toView:self];
    CGPoint viewCenter = self.center;
    return touchSnapshotViewCenter.x - viewCenter.x;
}

- (BOOL)canAdjustPlanRanking {
    if (!self.selectedIndexPath) {
        return NO;
    }
    if (self.originalCollectionViewCellRow == self.selectedCollectionViewCellRow && self.selectedIndexPath.section == self.originalSelectedIndexPathSection) {
        return NO;
    }
    return YES;
}

@end
