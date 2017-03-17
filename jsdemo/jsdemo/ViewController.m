//
//  ViewController.m
//  jsdemo
//
//  Created by weiguang on 2017/3/16.
//  Copyright © 2017年 weiguang. All rights reserved.
//

#import "ViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "Person.h"

@interface ViewController ()<UIWebViewDelegate>
@property (nonatomic,strong) UIWebView *webView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    self.webView.scalesPageToFit = YES;
    _webView.delegate = self;
    
    NSURL *url = [[NSURL alloc] initWithString:@"https://www.google.com"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //[_webView loadRequest:request];
    //[self.view addSubview:_webView];
    
    //[self JavaScriptCoreTest];
    [self JSExportTest];
}

    
//JavaScriptCore
- (void)JavaScriptCoreTest{
    JSContext *context = [[JSContext alloc] init];
    [context evaluateScript:@"var num = 5 + 5"];
    [context evaluateScript:@"var names = ['Grace', 'Ada', 'Margint']"];
    [context evaluateScript:@"var triple = function(value) {return value * 3}"];
    JSValue *tripleNum = [context evaluateScript:@"triple(num)"];
    NSLog(@"Tripled: %d",[tripleNum toInt32]);
    
    //对 JSContext 和 JSValue 实例使用下标的方式我们可以很容易地访问我们之前创建的 context 的任何值。JSContext 需要一个字符串下标，而 JSValue 允许使用字符串或整数标来得到里面的对象和数组：
    JSValue *names = context[@"names"];
    JSValue *firstName = names[0];
    NSLog(@"The first name: %@", [firstName toString]);
    NSLog(@"%d",[context[@"num"] toInt32]);
    
    //调用方法 JSValue 包装了一个 JavaScript 函数，我们可以从 Objective-C / Swift 代码中使用 Foundation 类型作为参数来直接调用该函数
    JSValue *tripleFunction = context[@"triple"];
    JSValue *result = [tripleFunction callWithArguments:@[@5]];
    NSLog(@"Five tripled: %d",[result toInt32]);
    
    // 错误处理 JSContext 还有另外一个有用的招数：通过设置上下文的 exceptionHandler 属性，你可以观察和记录语法，类型以及运行时错误。 exceptionHandler 是一个接收一个 JSContext 引用和异常本身的回调处理
    context.exceptionHandler = ^(JSContext *context, JSValue *exception){
        NSLog(@"JS Error: %@",exception);
    };
   // [context evaluateScript:@"function multiply(value1, value2) { return value1 * value2 "];
    
    
    // JavaScript 调用OC
    // 让 JSContext 访问我们的本地客户端代码的方式主要有两种：block 和 JSExport 协议
    // 1.Blocks
    context[@"simplifyString"] = ^(NSString *input){
        NSMutableString *mutableString = [input mutableCopy];
        CFStringTransform((__bridge CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin, NO);
        CFStringTransform((__bridge CFMutableStringRef)mutableString, NULL, kCFStringTransformStripCombiningMarks, NO);
        return mutableString;
    };
    NSLog(@"%@", [context evaluateScript:@"simplifyString('안녕하새요!')"]);
    
    //内存管理
    /*
     由于 block 可以保有变量引用，而且 JSContext 也强引用它所有的变量，为了避免强引用循环需要特别小心。避免保有你的 JSContext 或一个 block 里的任何 JSValue。相反，使用 [JSContext currentContext] 得到当前上下文，并把你需要的任何值用参数传递。
     */
}
    
// JSExport 协议
- (void)JSExportTest {
    JSContext *context = [[JSContext alloc] init];
    context[@"Person"] = [Person class];
    
    // load Mustache.js
    NSString *mustacheJSString = [NSString stringWithContentsOfFile:@"" encoding:NSUTF8StringEncoding error:nil];
    [context evaluateScript:mustacheJSString];
    
    //JavaScript 数据和进程
}

    
- (void)webViewDidFinishLoad:(UIWebView *)webView{

    //1、获取当前页面的url
    NSString *currentURL = [webView stringByEvaluatingJavaScriptFromString:@"document.location.href"];
    NSLog(@"%@",currentURL);
    // 2、获取页面title：
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    NSLog(@"%@",title);
    //3、修改界面元素的值
    NSString *js_result = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByName('q')[0].value='ios笔记';"];
    NSLog(@"%@",js_result);
    // 4、表单提交
    NSString *js_result2 = [webView stringByEvaluatingJavaScriptFromString:@"document.forms[0].submit(); "];
    NSLog(@"%@",js_result2);
    
    //5、插入js代码
    
    
}

@end
