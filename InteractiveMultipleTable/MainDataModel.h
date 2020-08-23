//
//  MainDataModel.h
//  InteractiveMultipleTable
//
//  Created by yleson on 2020/8/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SectionDataModel;
/**
 主模型
 */
@interface MainDataModel : NSObject

/// 主键
@property (nonatomic, assign) NSInteger mId;
/// 名称
@property (nonatomic, copy) NSString *mName;
/// 任务组列表数据
@property (nonatomic, strong) NSMutableArray<SectionDataModel *> *sections;

@end



@class ItemDataModel;
/**
 单组模型
 */
@interface SectionDataModel : NSObject

/// 组id
@property (nonatomic, assign) NSInteger sId;
/// 序号
@property (nonatomic, assign) NSInteger seq;
/// 名称
@property (nonatomic, copy) NSString *sName;
/// 任务列表
@property (nonatomic, strong) NSMutableArray<ItemDataModel *> *items;


/// 计算列表高度
- (CGFloat)loadContentHeight;

@end



/**
 任务模型
 */
@interface ItemDataModel : NSObject

/// 任务id
@property (nonatomic, assign) NSInteger iId;
/// 任务名称
@property (nonatomic, copy) NSString *iName;

/// 是否隐藏，拖动业务使用
@property (nonatomic, assign) BOOL isHidden;

@end





NS_ASSUME_NONNULL_END
