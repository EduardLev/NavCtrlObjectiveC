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
@class ProductVC;
@class AddEditViewController;
#import "Company.h"
#import "CompanyModelController.h"
#import "AddEditViewController.h"

@interface CompanyVC : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) IBOutlet UITableView *tableView; // retain - match to release in dealloc
@property (nonatomic, retain) NSMutableArray<Company*> *companyList; // retain - match to release in dealloc
@property (nonatomic, retain) CompanyModelController *companyMC;


/* FOR LATER: DO I HAVE TO RELEASE THIS???? */
@property (nonatomic, retain) ProductVC *productViewController;
@property (nonatomic, retain) AddEditViewController *addEditVC;
 

@end
