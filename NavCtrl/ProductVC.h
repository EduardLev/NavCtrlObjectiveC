//
//  ProductVC.h
//  NavCtrl
//
//  Created by Jesse Sahli on 2/7/17.
//  Copyright © 2017 Aditya Narayan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "Company.h"
#import "WebViewController.h"
#import "AddEditViewController.h"
@class AddEditViewController;

@interface ProductVC : UIViewController<UITableViewDelegate,
                                        UITableViewDataSource,
                                        WKNavigationDelegate>

@property (retain, nonatomic) IBOutlet UITableView *tableView; // release in dealloc

// Holds the company that the product is a part of
@property (nonatomic, retain) Company *company; // release in dealloc

// Holds the logo for the company in preview mode
@property (retain, nonatomic) IBOutlet UIImageView *topImageView;

// Holds the company name for the company in preview mode
@property (retain, nonatomic) IBOutlet UILabel *topLabelText;

// Holds the bottom view when there are no products to show
@property (retain, nonatomic) IBOutlet UIView *emptyView;

// Action for the add product button
- (IBAction)addProductButtonDidTouchUpInside:(UIButton *)sender;



/* FOR LATER: DO I HAVE TO RELEASE THIS???? */
@property (nonatomic, retain) WebViewController *webVC;
@property (nonatomic, retain) AddEditViewController *addEditVC;


@end
