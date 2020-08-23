//
//  SectionCreateItemView.m
//  InteractiveMultipleTable
//
//  Created by yleson on 2020/8/23.
//

#import "SectionCreateItemView.h"
#import <Masonry.h>

@interface SectionCreateItemView ()

/// 添加按钮
@property (nonatomic, strong) UIButton *insertListButton;
/// 输入保存视图
@property (nonatomic, strong) UIView *saveView;
/// 输入框
@property (nonatomic, strong) UITextField *nameField;

@end

@implementation SectionCreateItemView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.insertListButton];
        [self.insertListButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.inset(0);
            make.height.mas_equalTo(40);
        }];
        
        [self addSubview:self.saveView];
        [self.saveView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.inset(0);
            make.height.mas_equalTo(94);
        }];
        // 默认隐藏保存
        self.saveView.hidden = YES;
    }
    return self;
}


#pragma mark - 懒加载
- (UIButton *)insertListButton {
    if (!_insertListButton) {
        _insertListButton = [[UIButton alloc] init];
        _insertListButton.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);
        _insertListButton.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.4];
        [_insertListButton setImage:[UIImage imageNamed:@"home_project_detail_insert"] forState:UIControlStateNormal];
        [_insertListButton setTitle:@"新建任务列表" forState:UIControlStateNormal];
        [_insertListButton setTitleColor:[[UIColor blackColor] colorWithAlphaComponent:0.8] forState:UIControlStateNormal];
        [_insertListButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_insertListButton addTarget:self action:@selector(insertDidClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _insertListButton;
}

- (UIView *)saveView {
    if (!_saveView) {
        _saveView = [[UIView alloc] init];
        _saveView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.4];
        
        self.nameField = [[UITextField alloc] init];
        self.nameField.backgroundColor = [UIColor whiteColor];
        self.nameField.placeholder = @"请输入任务列表名称";
        self.nameField.font = [UIFont systemFontOfSize:14];
        self.nameField.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        self.nameField.returnKeyType = UIReturnKeyDone;
        self.nameField.delegate = self;
        [_saveView addSubview:self.nameField];
        [self.nameField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.inset(14);
            make.right.inset(10);
            make.height.mas_equalTo(30);
        }];
        
//        UIButton *saveButton = [[UIButton alloc] init];
//        [saveButton setTitle:@"保存" forState:UIControlStateNormal];
//        [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [saveButton.titleLabel setFont:[UIFont systemFontOfSize:kSizeRateNumber(14)]];
//        [saveButton setBackgroundImage:[UIImage createImageWithColor:[UIColor hsx_colorFromHexValue:0x1EAFFF]] forState:UIControlStateNormal];
//        [saveButton setBackgroundImage:[UIImage createImageWithColor:[UIColor hsx_colorFromHexValue:0x1EAFFF alpha:0.4]] forState:UIControlStateDisabled];
//        [saveButton addTarget:self action:@selector(saveDidClick) forControlEvents:UIControlEventTouchUpInside];
//        [_saveView addSubview:saveButton];
//        [saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(self.nameField.mas_bottom).inset(kSizeRateNumber(10));
//            make.right.inset(kSizeRateNumber(10));
//            make.width.mas_equalTo(kSizeRateNumber(52));
//            make.height.mas_equalTo(kSizeRateNumber(26));
//        }];
//        [saveButton masksWithCornerRadius:kSizeRateNumber(13)];
//        
//        UIButton *cancelButton = [[UIButton alloc] init];
//        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
//        [cancelButton setTitleColor:[UIColor hsx_colorFromHexValue:0x979797] forState:UIControlStateNormal];
//        [cancelButton.titleLabel setFont:[UIFont systemFontOfSize:kSizeRateNumber(14)]];
//        [cancelButton addTarget:self action:@selector(cancelDidClick) forControlEvents:UIControlEventTouchUpInside];
//        [_saveView addSubview:cancelButton];
//        [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.width.height.mas_equalTo(saveButton);
//            make.right.mas_equalTo(saveButton.mas_left).inset(kSizeRateNumber(4));
//        }];
//        
//        [[self.nameField rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
//            saveButton.enabled = [x length];
//        }];
    }
    return _saveView;
}

@end
