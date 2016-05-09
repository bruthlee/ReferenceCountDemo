//
//  WebViewController.m
//  ReferenceCountDemo
//
//  Created by bruthlee on 16/5/6.
//  Copyright © 2016年 demo.study. All rights reserved.
//

#import "WebViewController.h"

#import "Constants.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface WebViewController () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (weak, nonatomic) IBOutlet UIButton *runButton;
@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reloadWebview)];
    
    [self reloadWebview];
}

- (void)reloadWebview {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
    NSError *error;
    NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    [self.webView loadHTMLString:content baseURL:nil];
    DLOG(@"%@",error);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)touchRunOCAndJavascriptInteraction:(id)sender {
    //OC调用Javascript
    //同步机制
    NSString *result = [self.webView stringByEvaluatingJavaScriptFromString:@"ocInteraction('test .. you got this?');"];
    DLOG(@"result : %@",result);
    if (result) {
        [[[UIAlertView alloc] initWithTitle:result message:nil delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil] show];
    }
}

- (void)addJavascriptListener {
    //Javascript调用OC
    //异步机制
    JSContext *context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    context[@"jsTest"] = ^(){
        NSArray *params = [JSContext currentArguments];
        DLOG(@"jsTest params : %@",params);
        if (params && params.count > 0) {
            JSValue *value = [params firstObject];
            NSString *msg = [value toString];
            if (msg) {
                //因为是异步调用，所以UI类的操作放到主线程
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[[UIAlertView alloc] initWithTitle:msg message:nil delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil] show];
                });
            }
        }
    };
    context[@"jsTestInteraction"] = ^(){
        NSArray *params = [JSContext currentArguments];
        DLOG(@"jsTestInteraction params : %@",params);
        if (params && params.count > 0) {
            NSString *param = [[params firstObject] toString];
            NSArray *list = [param componentsSeparatedByString:@","];
            NSString *first = [list firstObject];
            NSString *second = [list lastObject];
            DLOG(@"param 1 = %@ , 2 = %@",first,second);
            int sum = [first intValue] + [second intValue];
            return sum;
        }
        return 0;
    };
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    DLOG(@"");
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    DLOG(@"");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self addJavascriptListener];
    DLOG(@"");
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    DLOG(@"");
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
