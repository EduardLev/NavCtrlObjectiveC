//
//  WebViewController.m
//  NavCtrl
//
//  Created by Eduard Lev on 3/2/18.
//  Copyright © 2018 Aditya Narayan. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@property (nonatomic, retain) UIProgressView *progressView;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createWebBrowser];
    
    // call dealloc - NOT YET IMPLEMENTED - CHECK
    self.progressView = [[UIProgressView alloc]
                         initWithProgressViewStyle:UIProgressViewStyleDefault];
    [self.progressView sizeToFit];
    
    //progressView.progressTintColor = [UIColor colorWithRed:187.0/255 green:160.0/255 blue:209.0/255 alpha:1.0];
    [[self.progressView layer]setFrame:CGRectMake(0, 60, self.view.frame.size.width, 6)];
    [[self.progressView layer]setBorderColor:[UIColor redColor].CGColor];
    self.progressView.trackTintColor = [UIColor clearColor];
    
    //[[self.progressView layer]setCornerRadius:self.progressView.frame.size.width / 2];
    //[[self.progressView layer]setBorderWidth:3];
    [[self.progressView layer]setMasksToBounds:TRUE];
    self.progressView.clipsToBounds = YES;
    
    [self.view addSubview:self.progressView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Network Methods
- (void)createWebBrowser {
    [self createWebConfiguration];
    [self createWebView];
    [self createWebRequest];
}

- (void)createWebConfiguration {
    // Web Configuration
    self.webConfiguration = [[WKWebViewConfiguration alloc] init]; // released in dealloc
}

- (void)createWebView {
    // Web View
    CGRect frame = CGRectMake(0.0, 20.0, self.view.frame.size.width,
                              self.view.frame.size.height - 20);
    self.webView = [[WKWebView alloc] initWithFrame:frame configuration:self.webConfiguration];
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth |
    UIViewAutoresizingFlexibleHeight;
    self.webView.navigationDelegate = self;
    [self.view addSubview:self.webView];
    
    [self.webView addObserver:self
                   forKeyPath:NSStringFromSelector(@selector(estimatedProgress))
                      options:NSKeyValueObservingOptionNew
                      context:NULL]; // need to remove observer later
    
    [self.webView addObserver:self
                   forKeyPath:NSStringFromSelector(@selector(loading))
                      options:NSKeyValueObservingOptionNew
                      context:NULL];
    
    [self.webView setUIDelegate:self];
}

- (void)createWebRequest {
    // Request
    
    NSString *google = @"https://www.google.com";
    NSURL *url = [[NSURL alloc] initWithString:google];
    NSURLRequest *nsRequest = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:nsRequest];
    [url release];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progressView.progress = self.webView.estimatedProgress;
    }
    
    if ([keyPath isEqualToString:@"loading"]) {
        self.progressView.hidden = !self.webView.loading;
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)dealloc {
    [_progressView release];
    [_webView release];
    [_webConfiguration release];
    [super dealloc];
}

@end
