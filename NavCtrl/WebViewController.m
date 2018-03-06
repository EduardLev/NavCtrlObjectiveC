//
//  WebViewController.m
//  NavCtrl
//
//  Created by Eduard Lev on 3/2/18.
//  Copyright © 2018 Aditya Narayan. All rights reserved.
//

#import "WebViewController.h"
#import "AddEditViewController.h"

@interface WebViewController ()

@property (nonatomic, retain) UIProgressView *progressView;
@property (nonatomic, retain) AddEditViewController *addEditVC;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *backImage = [UIImage imageNamed:@"btn-navBack"];
    // Creates custom back button with arrow image
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithImage:backImage
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(back)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    // Do any additional setup after loading the view.
    [self createWebBrowser];
    
    // call dealloc - NOT YET IMPLEMENTED - CHECK
    UIProgressView *progressView = [[UIProgressView alloc]
                         initWithProgressViewStyle:UIProgressViewStyleDefault];
    [progressView sizeToFit];
    
    //progressView.progressTintColor = [UIColor colorWithRed:187.0/255 green:160.0/255 blue:209.0/255 alpha:1.0];
    [[progressView layer]setFrame:CGRectMake(0, 60, self.view.frame.size.width, 6)];
    [[progressView layer]setBorderColor:[UIColor redColor].CGColor];
    progressView.trackTintColor = [UIColor clearColor];
    
    //[[self.progressView layer]setCornerRadius:self.progressView.frame.size.width / 2];
    //[[self.progressView layer]setBorderWidth:3];
    [[progressView layer]setMasksToBounds:TRUE];
    progressView.clipsToBounds = YES;
    
    [self.view addSubview:self.progressView];
    [progressView release];
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc]initWithTitle:@"Edit"
        style:UIBarButtonItemStylePlain target:self action:@selector(enterEditMode)];
    self.navigationItem.rightBarButtonItem = editButton;
    [editButton release];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)enterEditMode {
    _addEditVC = [[AddEditViewController alloc] init];
    self.addEditVC.title = @"Edit Product"; // important for logic on addEditVC
    self.addEditVC.product = self.product; // the product will be whatever product is being shown
    self.addEditVC.company = self.company;
    
    /* // CHANGE ANIMATION TYPE HERE
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    transition.type = kCATransitionFade; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
    transition.subtype = kCATransitionFromTop; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
     [self.navigationController.view.layer addAnimation:transition forKey:nil]; */
    
    [self.navigationController pushViewController:self.addEditVC animated:YES];
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
    _webConfiguration = [[WKWebViewConfiguration alloc] init]; // released in dealloc
}

- (void)createWebView {
    // Web View
    CGRect frame = CGRectMake(0.0, 20.0, self.view.frame.size.width,
                              self.view.frame.size.height - 20);
    _webView = [[WKWebView alloc] initWithFrame:frame configuration:self.webConfiguration];
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
    NSString *urlString = self.product.productWebsiteURL;
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSURLRequest *nsRequest = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:nsRequest];
    [url release];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progressView.progress = self.webView.estimatedProgress;
    }
    
    if ([keyPath isEqualToString:@"loading"]) {
        NSLog(@"this happened");
        self.progressView.hidden = !self.webView.loading;
    }
}

- (void)dealloc {
    [_progressView release];
    [_webView release];
    [_webConfiguration release];
    [_addEditVC release];
    [_webView release];
    [_company release];
    [_progressView release];
    [_product release];
    [super dealloc];
}

@end
