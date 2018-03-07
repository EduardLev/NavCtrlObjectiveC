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
    [self createNavigationBarButtons];
    [self createProgressView];

    // Do any additional setup after loading the view.
    if ([self checkInternetConnection]) {
        [self createWebBrowser];
        [self.view addSubview:self.progressView];
    } else {
        [self presentNoInternetAlert];
    }
}

- (void)presentNoInternetAlert {
    UIAlertController* alert =
    [UIAlertController alertControllerWithTitle:@"Error"
                                        message:@"No Internet Connection"
                                 preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction =
    [UIAlertAction actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                           handler:^(UIAlertAction * action) {}];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)createProgressView {
    _progressView = [[UIProgressView alloc]
                                    initWithProgressViewStyle:UIProgressViewStyleDefault];
    [self.progressView sizeToFit];
    [[self.progressView layer]setFrame:CGRectMake(0.0, 60.0, self.view.frame.size.width, 6)];
    [[self.progressView layer]setBorderColor:[UIColor redColor].CGColor];
    self.progressView.trackTintColor = [UIColor clearColor];
    
    [[self.progressView layer]setMasksToBounds:TRUE];
    self.progressView.clipsToBounds = YES;
}

- (void)createNavigationBarButtons {
    // Creates EDIT Button
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(enterEditMode)];
    self.navigationItem.rightBarButtonItem = editButton;
    [editButton release];
    
    // Creates BACK Button with custom arrow image
    UIImage *backImage = [UIImage imageNamed:@"btn-navBack"];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:backImage
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(back)];
    self.navigationItem.leftBarButtonItem = backButton;
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
    transition.timingFunction = [CAMediaTimingFunction
     functionWithName:kCAMediaTimingFunctionEaseIn];
    transition.type = kCATransitionFade; //kCATransitionMoveIn; //, kCATransitionPush,
     kCATransitionReveal, kCATransitionFade
    transition.subtype = kCATransitionFromTop; //kCATransitionFromLeft, kCATransitionFromRight,
     kCATransitionFromTop, kCATransitionFromBottom
     [self.navigationController.view.layer addAnimation:transition forKey:nil]; */
    
    [self.navigationController pushViewController:self.addEditVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Network Methods

- (BOOL)checkInternetConnection {
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    return (networkStatus != NotReachable);
}

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
    CGRect frame = CGRectMake(0.0, 60.0, self.view.frame.size.width,
                              self.view.frame.size.height - 60);
    _webView = [[WKWebView alloc] initWithFrame:frame configuration:self.webConfiguration];
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth |
    UIViewAutoresizingFlexibleHeight;
    self.webView.navigationDelegate = self;
    [self.view addSubview:self.webView];
    
    [self.webView addObserver:self
                   forKeyPath:NSStringFromSelector(@selector(estimatedProgress))
                      options:NSKeyValueObservingOptionNew
                      context:NULL];
    
    [self.webView addObserver:self
                   forKeyPath:NSStringFromSelector(@selector(loading))
                      options:NSKeyValueObservingOptionNew
                      context:NULL];
    
    [self.webView setUIDelegate:self];
}

- (void)createWebRequest {
    NSString *urlString = self.product.productWebsiteURL;
    NSURL *url = [NSURL URLWithString:urlString];
    if ((url.host != nil)&&(url.scheme != nil)) {
        NSURLRequest *nsRequest = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:nsRequest];
    } else {
        UIAlertController* alert =
        [UIAlertController alertControllerWithTitle:@"Error"
                                            message:@"Invalid URL"
                                     preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction =
        [UIAlertAction actionWithTitle:@"OK"
                                 style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {}];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context {
    
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progressView.progress = self.webView.estimatedProgress;
    }
    
    if ([keyPath isEqualToString:@"loading"]) {
        self.progressView.hidden = !self.webView.loading;
    }
}

- (void)webView:(WKWebView *)webView
didFailProvisionalNavigation:(WKNavigation *)navigation
      withError:(NSError *)error {
    NSLog(@"error loading website");
    
    UIAlertController* alert =
    [UIAlertController alertControllerWithTitle:@"Error"
                                        message:@"This website was not able to be loaded"
                                 preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction =
    [UIAlertAction actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                           handler:^(UIAlertAction * action) {}];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
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
