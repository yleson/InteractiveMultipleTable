//
//  ViewController.m
//  InteractiveMultipleTable
//
//  Created by yleson on 2020/8/23.
//

#import "ViewController.h"
#import "MainViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    MainViewController *mainVc = [[MainViewController alloc] init];
    [self.navigationController pushViewController:mainVc animated:YES];
}

@end
