//
//  MHViewController.m
//  WKWebView
//
//  Created by weiguang on 2017/3/16.
//  Copyright © 2017年 weiguang. All rights reserved.
//

#import "MHViewController.h"
#import <WebKit/WebKit.h>

@interface MHViewController ()<WKScriptMessageHandler,WKUIDelegate>
@property (nonatomic,strong) WKWebView *webView;
@end

@implementation MHViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"MessageHandler方法";
    
    [self initWKWebView];
}
    
/*
 window.webkit.messageHandlers.<name>.postMessage(<messageBody>)
 其中<name>，就是上面方法里的第二个参数`name`。
 例如我们调用API的时候第二个参数填@"Share"，那么在JS里就是:
 window.webkit.messageHandlers.Share.postMessage(<messageBody>)
 <messageBody>是一个键值对，键是body，值可以有多种类型的参数。
 在`WKScriptMessageHandler`协议中，我们可以看到mssage是`WKScriptMessage`类型，有一个属性叫body。
 而注释里写明了body 的类型：
 Allowed types are NSNumber, NSString, NSDate, NSArray, NSDictionary, and NSNull.
 */

- (void)initWKWebView{
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    configuration.userContentController = [WKUserContentController new];
    [configuration.userContentController addScriptMessageHandler:self name:@"ScanAction"];
    [configuration.userContentController addScriptMessageHandler:self name:@"Location"];
    [configuration.userContentController addScriptMessageHandler:self name:@"Color"];
    [configuration.userContentController addScriptMessageHandler:self name:@"Pay"];
    [configuration.userContentController addScriptMessageHandler:self name:@"Share"];
    
    WKPreferences *preference = [[WKPreferences alloc] init];
    preference.javaScriptCanOpenWindowsAutomatically = YES;
    preference.minimumFontSize = 40.0;
    configuration.preferences = preference;
    
    self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:configuration];
    NSString *urlStr = [[NSBundle mainBundle] pathForResource:@"WHindex.html" ofType:nil];
    NSURL *fileURL = [NSURL fileURLWithPath:urlStr];
    [self.webView loadFileURL:fileURL allowingReadAccessToURL:fileURL];
    
    self.webView.UIDelegate = self;
    
    [self.view addSubview:self.webView];
    
}
   


#pragma mark - private method
- (void)getLocation
{
        // 获取位置信息
        
        // 将结果返回给js
        NSString *jsStr = [NSString stringWithFormat:@"setLocation('%@')",@"四川省成都市高新区天府四街XXXX号"];
        [self.webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            NSLog(@"%@----%@",result, error);
        }];
        
}

- (void)shareWithParams:(NSDictionary *)tempDic
{
        if (![tempDic isKindOfClass:[NSDictionary class]]) {
            return;
        }
        
        NSString *title = [tempDic objectForKey:@"title"];
        NSString *content = [tempDic objectForKey:@"content"];
        NSString *url = [tempDic objectForKey:@"url"];
        // 在这里执行分享的操作
        
        // 将分享结果返回给js
        NSString *jsStr = [NSString stringWithFormat:@"shareResult('%@','%@','%@')",title,content,url];
        [self.webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            NSLog(@"%@----%@",result, error);
        }];
}

- (void)changeBGColor:(NSArray *)params
{
    if (![params isKindOfClass:[NSArray class]]) {
        return;
    }
        
    if (params.count < 4) {
        return;
    }
        
    CGFloat r = [params[0] floatValue];
    CGFloat g = [params[1] floatValue];
    CGFloat b = [params[2] floatValue];
    CGFloat a = [params[3] floatValue];
        
    self.webView.backgroundColor = [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a];
    
    NSString *jsStr = [NSString stringWithFormat:@"changeColor(%f,%f,%f)",r,g,b];
    [self.webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        NSLog(@"改变字体颜色");
    }];
}
    
- (void)payWithParams:(NSDictionary *)tempDic
    {
        if (![tempDic isKindOfClass:[NSDictionary class]]) {
            return;
        }
        NSString *orderNo = [tempDic objectForKey:@"order_no"];
        long long amount = [[tempDic objectForKey:@"amount"] longLongValue];
        NSString *subject = [tempDic objectForKey:@"subject"];
        NSString *channel = [tempDic objectForKey:@"channel"];
        NSLog(@"%@---%lld---%@---%@",orderNo,amount,subject,channel);
        
        // 支付操作
        
        // 将支付结果返回给js
        NSString *jsStr = [NSString stringWithFormat:@"payResult('%@')",@"支付成功"];
        [self.webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            NSLog(@"%@----%@",result, error);
        }];
    }
    
    
#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    //message.body  --  Allowed types are NSNumber, NSString, NSDate, NSArray,NSDictionary, and NSNull.
    if ([message.name isEqualToString:@"ScanAction"]) {
        NSLog(@"扫一扫");
    } else if ([message.name isEqualToString:@"Location"]) {
        [self getLocation];
    } else if ([message.name isEqualToString:@"Share"]) {
        [self shareWithParams:message.body];
    }else if ([message.name isEqualToString:@"Color"]) {
        [self changeBGColor:message.body];
    }else if ([message.name isEqualToString:@"Pay"]) {
        [self payWithParams:message.body];
    }
}
    
#pragma mark - WKUIDelegate
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}
    
    

@end
