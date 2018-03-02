//
//  WebViewController.h
//  NavCtrl
//
//  Created by Eduard Lev on 3/2/18.
//  Copyright © 2018 Aditya Narayan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import <QuartzCore/QuartzCore.h>

@interface WebViewController : UIViewController<WKNavigationDelegate, WKUIDelegate>

// network request properties
@property (nonatomic, retain) WKWebView *webView; // release in dealloc
@property (nonatomic, retain) WKWebViewConfiguration *webConfiguration; // release in dealloc


@end
