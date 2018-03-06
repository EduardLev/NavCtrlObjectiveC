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

// True if this add/edit VC was presented from a product view controller
// If false, this add/edit VC was presented from a company view controller
@property (nonatomic) BOOL fromProductController;

// Stores the company to be shown on the edit screen, if applicable.
// If editing a company, this property will have the company to be edited
// If adding or editing a product, this property will hold the parent company class
@property (nonatomic, retain) Company *company;

// Stores the product to be shown on the edit screen, if applicable.
@property (nonatomic, retain) Product *product;

@property (nonatomic) BOOL add;


@property (nonatomic, retain) NSIndexPath *indexPath;


@end
