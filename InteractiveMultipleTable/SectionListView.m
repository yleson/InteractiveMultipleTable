//
//  SectionListView.m
//  InteractiveMultipleTable
//
//  Created by yleson on 2020/8/23.
//

#import "SectionListView.h"
#import "MainDataModel.h"
#import <Masonry.h>

@interface SectionListView () <UITableViewDelegate, UITableViewDataSource>

/// 有任务列表数据时显示的任务列表
@property (nonatomic, strong) UITableView *taskContentView;

@end

@implementation SectionListView

- (void)setSection:(SectionDataModel *)section {
    _section = section;
    
    [self.taskContentView reloadData];
    
    CGFloat height = [section loadContentHeight];
    [self.taskContentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height > 500 ? 500 : height);
    }];
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.taskContentView];
        [self.taskContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.inset(0);
            make.height.mas_equalTo(120);
        }];
        
    }
    return self;
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.section.items.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SectionListItemCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SectionListItemCell class])];
    if (!cell) {
        cell = [[SectionListItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([SectionListItemCell class])];
    }
    cell.item = self.section.items[indexPath.section];
//    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    if ([self.delegate respondsToSelector:@selector(projectDetailTaskListViewDidShowTaskDetail:)]) {
//        [self.delegate projectDetailTaskListViewDidShowTaskDetail:self.taskGroupModel.taskList[indexPath.section]];
//    }
}

#pragma mark - 懒加载
- (UITableView *)taskContentView {
    if (!_taskContentView) {
        _taskContentView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _taskContentView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.15];
        _taskContentView.bounces = NO;
        _taskContentView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _taskContentView.estimatedRowHeight = 48;
        _taskContentView.rowHeight = UITableViewAutomaticDimension;
        _taskContentView.delegate = self;
        _taskContentView.dataSource = self;
    }
    return _taskContentView;
}


@end












/**
 项目详情任务组cell
 */
@interface SectionListItemCell ()

/// 容器层
@property (nonatomic, strong) UIView *containerView;
/// 完成按钮
@property (nonatomic, strong) UIButton *completeButton;
/// 任务名称
@property (nonatomic, strong) UILabel *nameLabel;

@end

@implementation SectionListItemCell

- (void)setItem:(ItemDataModel *)item {
    _item = item;
    
    self.containerView.hidden = item.isHidden;
    
    NSDictionary *attribtDic = @{NSForegroundColorAttributeName: [[UIColor blackColor] colorWithAlphaComponent:0.9]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc] initWithString:item.iName attributes:attribtDic];
    self.nameLabel.attributedText = attribtStr;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:self.containerView];
        [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.inset(10);
            make.top.inset(0);
            make.bottom.inset(6);
        }];
        
        [self.containerView addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.inset(11);
            make.bottom.inset(12);
            make.left.right.inset(12);
        }];
        
        [self layoutIfNeeded];
    }
    return self;
}

#pragma mark - 懒加载
- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = [UIColor whiteColor];
        _containerView.layer.masksToBounds = YES;
        _containerView.layer.cornerRadius = 4;
    }
    return _containerView;
}
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
    }
    return _nameLabel;
}


@end
