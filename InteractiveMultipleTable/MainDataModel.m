//
//  MainDataModel.m
//  InteractiveMultipleTable
//
//  Created by yleson on 2020/8/23.
//

#import "MainDataModel.h"

@implementation MainDataModel

@end


/**
 项目任务组数据模型
 */
@interface SectionDataModel ()

/// 计算列表高度
@property (nonatomic, assign) CGFloat conenteHeight;
/// 上一次有多少条数据
@property (nonatomic, assign) NSInteger lastContentCount;

@end

@implementation SectionDataModel

- (CGFloat)loadContentHeight {
    if (!self.items.count) return 0.0;
    if (self.items.count && (self.items.count == self.lastContentCount) && self.conenteHeight > 0) return self.conenteHeight;
    
    __block CGFloat height = 0.0;
    self.lastContentCount = self.items.count;
    [self.items enumerateObjectsUsingBlock:^(ItemDataModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        height += 32;
        
        NSDictionary *attrs = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
        CGSize maxSize = CGSizeMake(240, MAXFLOAT);
        NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
        // 计算文字占据的宽高
        CGSize size = [model.iName boundingRectWithSize:maxSize options:options attributes:attrs context:nil].size;
        height += size.height;
    }];
    self.conenteHeight = height;
    return height;
}

@end

@implementation ItemDataModel

@end
