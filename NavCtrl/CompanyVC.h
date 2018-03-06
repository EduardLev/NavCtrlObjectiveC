//
//  CompanyVC.h
//  NavCtrl
//
//  Created by Jesse Sahli on 2/7/17.
//  Copyright © 2017 Aditya Narayan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/Webkit.h>
#import "ProductVC.h"
#import "Company.h"
#import "CompanyModelController.h"
#import "AddEditViewController.h"

@interface CompanyVC : UIViewController<UITableViewDelegate, UITableViewDataSource>

// Stores the tableView for access
@property (nonatomic, retain) IBOutlet UITableView *tableView;

// Stores the view shown to user when there are no companies
@property (nonatomic, retain) IBOutlet UIView *emptyView;

// Action when user presses the add button within the no companies view
- (IBAction)addButtonDidTouchUpInside:(UIButton *)sender;

// Stores the stock timer object - every 60 S it refreshes
@property (nonatomic, retain) NSTimer *stockTimer;


@end
