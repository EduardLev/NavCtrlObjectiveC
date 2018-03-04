//
//  AddEditViewController.h
//  NavCtrl
//
//  Created by Eduard Lev on 3/2/18.
//  Copyright © 2018 Aditya Narayan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Company.h"
#import "CompanyVC.h"

@interface AddEditViewController : UIViewController<UITextFieldDelegate>

@property (nonatomic, retain) Company *company;
@property (nonatomic, retain) Product *product;
@property (nonatomic) BOOL fromProductController;
@property (nonatomic) BOOL add;
@property (nonatomic, retain) NSIndexPath *indexPath;


@end
