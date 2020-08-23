//
//  SectionItemCell.m
//  InteractiveMultipleTable
//
//  Created by yleson on 2020/8/23.
//

#import "SectionItemCell.h"
#import "SectionListView.h"
#import <Masonry.h>

@interface SectionItemCell ()

/// 任务列表视图
@property (nonatomic, strong) SectionListView *taskListView;

@end

@implementation SectionItemCell

#pragma mark - 懒加载
- (SectionListView *)taskListView {
    if (!_taskListView) {
        _taskListView = [[SectionListView alloc] init];
//        _taskListView.delegate = self;
    }
    return _taskListView;
}




- (void)setSection:(SectionDataModel *)section {
    _section = section;
    
    self.taskListView.section = section;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.selectedBackgroundView = [[UIView alloc] init];
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 2;
        self.layer.masksToBounds = YES;
        
        [self addSubview:self.taskListView];
        [self.taskListView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.inset(0);
        }];
    }
    return self;
}

@end
