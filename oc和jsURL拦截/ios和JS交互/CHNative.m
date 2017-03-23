//
//  CHNative.m
//  ios和JS交互
//
//  Created by weiguang on 2017/3/23.
//  Copyright © 2017年 weiguang. All rights reserved.
//

#import "CHNative.h"


@implementation CHNative

- (void)printInfo:(NSObject *)obj {
    NSString *_info = [NSString stringWithFormat:@"%@",obj];
    
    NSLog(@"打印JS传递的info:%@",_info);
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"确定要拨打电话？\n%@",_info] preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"http://www.baidu.com"]];
        
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击取消");
    }]];

    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
    
}



@end
