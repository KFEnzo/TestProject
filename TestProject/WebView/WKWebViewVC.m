//
//  WKWebViewVC.m
//  TestProject
//
//  Created by jiaHS on 2019/2/14.
//  Copyright © 2019 Jia. All rights reserved.
//

#import "WKWebViewVC.h"
#import <WebKit/WebKit.h>

@interface WKWebViewVC ()
@property(nonatomic, strong) WKWebView *wkWebView;
@property(nonatomic, strong) NSString *html;
@end

@implementation WKWebViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.wkWebView = [[WKWebView alloc] init];
    [self.view addSubview:self.wkWebView];
    self.wkWebView.frame = self.view.bounds;
    self.wkWebView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    NSString *url = @"http://card-test5.dushu.io/requirement/redeemCode";
    [self.wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
//    [self.wkWebView loadHTMLString:self.html baseURL:nil];
}

- (NSString *)html {
//    return @"";
    NSString *path = [[NSBundle mainBundle] pathForResource:@"aa" ofType:@"txt"];
    return [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
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
