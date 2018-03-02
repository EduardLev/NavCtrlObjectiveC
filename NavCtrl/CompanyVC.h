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

@interface CompanyVC : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) IBOutlet UITableView *tableView; // retain - match to release in dealloc
@property (nonatomic, retain) NSMutableArray<Company*> *companyList; // retain - match to release in dealloc

/* FOR LATER: DO I HAVE TO RELEASE THIS???? */
@property (nonatomic, retain) ProductVC *productViewController;
 

@end
