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
#import "Product.h"
#import "Company.h"

@interface WebViewController : UIViewController<WKNavigationDelegate, WKUIDelegate>

// network request properties
@property (nonatomic, retain) WKWebView *webView; // release in dealloc
@property (nonatomic, retain) WKWebViewConfiguration *webConfiguration; // release in dealloc

// Holds the URL that should load when the user selects a product
@property (nonatomic, retain) Product *product;
@property (nonatomic, retain) Company *company;



@end
