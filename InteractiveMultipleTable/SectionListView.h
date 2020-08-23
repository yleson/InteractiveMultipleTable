//
//  SectionListView.h
//  InteractiveMultipleTable
//
//  Created by yleson on 2020/8/23.
//

#import <UIKit/UIKit.h>
@class SectionDataModel;
@class ItemDataModel;

NS_ASSUME_NONNULL_BEGIN

@interface SectionListView : UIView

/// 有任务列表数据时显示的任务列表
@property (readonly) UITableView *taskContentView;
/// 项目详情任务组数据
@property (nonatomic, strong) SectionDataModel *section;
/// 代理
//@property (nonatomic, weak) id<HSXProjectDetailTaskListViewDelegate> delegate;

@end





@interface SectionListItemCell : UITableViewCell

/// 容器层
@property (readonly) UIView *containerView;
/// 任务列中的任务数据
@property (nonatomic, strong) ItemDataModel *item;
/// 代理
//@property (nonatomic, strong) id<HSXProjectDetailTaskListCellDelegate> delegate;

@end





NS_ASSUME_NONNULL_END
