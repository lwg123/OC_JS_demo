//
//  ViewController.m
//  ios和JS交互
//
//  Created by weiguang on 2017/3/7.
//  Copyright © 2017年 weiguang. All rights reserved.
//

#import "ViewController.h"
#import <SVProgressHUD.h>
#import "CHNative.h"

@interface ViewController ()<UIWebViewDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic,strong) NSString *info; // 存储网页上的手机号
@end

@implementation ViewController
{
    CHNative *_native;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;
    
    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"testWebPage.html" ofType:nil];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:htmlPath]];
   [self.webView loadRequest:request];
    
    _native = [[CHNative alloc] init];
}

#pragma mark UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView{
    [SVProgressHUD show];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [SVProgressHUD dismiss];
    
    // 修改底部文字颜色
    NSString *jsStr = @"document.getElementById('test').style.color='red';";
    [webView stringByEvaluatingJavaScriptFromString:jsStr];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [SVProgressHUD dismiss];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    

    // 1.获取加载网页的url
    NSURL *url = request.URL;
    if (url == nil) {
        return YES;
    }
    
    // 2.获取URL中的字符串
    NSString *urlStr = url.absoluteString;
    NSLog(@"%@",urlStr);
    
    // 3.判断该字符串中是否包含特殊字段
    NSString *checkStr = @"http://www.testwebpage/?";
    if ([urlStr rangeOfString:checkStr].location == NSNotFound) {
        return YES;
    }
    
    // 4.将特殊字段截取出来,分割字符串得到参数数据
    NSString *linkStr = [urlStr componentsSeparatedByString:@"?"][1];
    NSLog(@"%@",linkStr);
    
    NSArray *params = [linkStr componentsSeparatedByString:@"&&"];
    //取出第一个参数：与h5协商好的方法名 printInfo:
    NSString *funcName = [params[0] componentsSeparatedByString:@"="][1];
    //取出第二个参数：信息字符串 18513239626
    NSString *info = [params[1] componentsSeparatedByString:@"="][1];
    NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
    [dicParam setValue:info forKey:@"info"];
    
    //5. 调起iOS原生方法
    SEL selector = NSSelectorFromString(funcName);
    
    NSMethodSignature *methodSig = [_native methodSignatureForSelector:selector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
    invocation.selector = selector;
    invocation.target = _native;
    int i = 0;
    if (dicParam) {
        [invocation setArgument:&dicParam atIndex:i + 2];
    }
    [invocation invoke];

    
//    if ([self respondsToSelector:selector]) {
//        
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
//        
//        [self performSelector:selector withObject:info];
//#pragma clang diagnostic pop
//    }
    
    //返回NO是为了不再执行点击原链接的跳转
    return NO;

}

// 本地调用
- (void)printInfo:(NSObject *)obj {
    _info = [NSString stringWithFormat:@"%@",obj];
    
    NSLog(@"打印JS传递的info:%@",_info);
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"确定要拨打电话？\n%@",_info] preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"http://www.baidu.com"]];
        
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击取消");
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}



@end
