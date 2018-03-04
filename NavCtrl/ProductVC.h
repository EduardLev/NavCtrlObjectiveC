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
//@property (nonatomic, retain) NSArray<Product*> *products;
@property (nonatomic, retain) Company *company; // release in dealloc

/* FOR LATER: DO I HAVE TO RELEASE THIS???? */
@property (nonatomic, retain) WebViewController *webVC;
@property (nonatomic, retain) AddEditViewController *addEditVC;


@end
