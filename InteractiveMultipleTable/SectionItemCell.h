//
//  SectionItemCell.h
//  InteractiveMultipleTable
//
//  Created by yleson on 2020/8/23.
//

#import <UIKit/UIKit.h>
@class SectionDataModel;
@class SectionListView;

NS_ASSUME_NONNULL_BEGIN

@interface SectionItemCell : UICollectionViewCell

/// 任务列表视图
@property (readonly) SectionListView *taskListView;
/// 项目详情任务组数据
@property (nonatomic, strong) SectionDataModel *section;
/// 代理
//@property (nonatomic, weak) id<HSXProjectDetailTaskCollectionCellDelegate> delegate;
/// CollectionViewCell所在的indexPath
@property (nonatomic, strong) NSIndexPath *indexPath;

@end

NS_ASSUME_NONNULL_END
