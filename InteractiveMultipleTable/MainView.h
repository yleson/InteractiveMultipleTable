//
//  MainView.h
//  InteractiveMultipleTable
//
//  Created by yleson on 2020/8/23.
//

#import <UIKit/UIKit.h>
@class MainDataModel;

NS_ASSUME_NONNULL_BEGIN


/**
 代理方法
 */
@protocol InteractiveDelegate <NSObject>


@end


@interface MainView : UIView

/// 数据;
@property (nonatomic, strong) MainDataModel *model;
/// 刷新数据
- (void)refreshDatas;

@end

NS_ASSUME_NONNULL_END
