//
//  MainViewController.m
//  InteractiveMultipleTable
//
//  Created by yleson on 2020/8/23.
//

#import "MainViewController.h"
#import "MainView.h"
#import "MainDataModel.h"
#import <Masonry.h>

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"多列表交互拖动";
    self.view.backgroundColor = UIColor.whiteColor;
    
    MainView *mainView = [[MainView alloc] init];
    
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
    
    mainView.model = model;
    
    [self.view addSubview:mainView];
    [mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(140);
        make.left.right.bottom.inset(0);
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
