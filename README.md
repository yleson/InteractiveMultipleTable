# InteractiveMultipleTable
##多列表交互拖动，做完公司项目后觉得功能挺有意思便扒下来了

![Simulator Screen Shot - iPhone 12 - 2022-05-06 at 13 59 07](https://user-images.githubusercontent.com/39610531/167077515-1b29a739-7e4f-4f6f-b2e7-f4a52fbefdb4.png)
![Simulator Screen Shot - iPhone 12 - 2022-05-06 at 13 59 55](https://user-images.githubusercontent.com/39610531/167077547-46234a0f-e844-46d5-93ab-0ef2a850b5c9.png)


```objective-c

/**
整一个视图，包含分页拖动和指示器
*/
@interface MainView : UIView

/// 数据;
@property (nonatomic, strong) MainDataModel *model;
/// 刷新数据
- (void)refreshDatas;

@end

```

根据需要构建模型数据
```objective-c

MainDataModel *model = [[MainDataModel alloc] init];
model.mId = 1;
model.mName = @"1";
    
NSMutableArray<SectionDataModel *> *sections = [NSMutableArray array];
for (int j = 0; j < 6; j++) {
    SectionDataModel *section = [[SectionDataModel alloc] init];
    section.sId = j;
    section.sName = [NSString stringWithFormat:@"10%d", j];
        
    NSMutableArray<ItemDataModel *> *items = [NSMutableArray array];
    for (int i = 0; i < (12 + j); i++) {
        ItemDataModel *item = [[ItemDataModel alloc] init];
        item.iId = i;
        item.iName = [NSString stringWithFormat:@"%d%d", 10000 * j, i];
        [items addObject: item];
    }
    section.items = items;
    [sections addObject:section];
}
model.sections = sections;

```

Demo只显示一个简单文本，自定义则修改 SectionListView.m 中的 SectionListItemCell，并重新计算每组列表的高度
```objective-c

@implementation SectionDataModel

- (CGFloat)loadContentHeight {
    CGFloat height = 0.0;
    
    // 其他高度计算
     
    return height;
}

@end
```
