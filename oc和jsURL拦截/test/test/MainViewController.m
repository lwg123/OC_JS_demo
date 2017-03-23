//
//  MainViewController.m
//  test
//
//  Created by weiguang on 2017/3/14.
//  Copyright © 2017年 weiguang. All rights reserved.
//

#import "MainViewController.h"
#import "WebViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"主页";
   
}


- (IBAction)UIBtn:(id)sender {
    
    WebViewController *webVC = [[WebViewController alloc] init];
    [self.navigationController pushViewController:webVC animated:YES];
}


@end
