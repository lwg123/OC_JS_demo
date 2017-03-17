//
//  MainViewController.m
//  WKWebView
//
//  Created by weiguang on 2017/3/16.
//  Copyright © 2017年 weiguang. All rights reserved.
//

#import "MainViewController.h"
#import "ViewController.h"
#import "MHViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)WKbtnClick:(id)sender {
    
    ViewController *WKvc = [[ViewController alloc] init];
    [self.navigationController pushViewController:WKvc animated:YES];
}

- (IBAction)MHbtnClick:(id)sender {
    MHViewController *MHvc = [[MHViewController alloc] init];
    [self.navigationController pushViewController:MHvc animated:YES];
}
    
    
    
    
@end
