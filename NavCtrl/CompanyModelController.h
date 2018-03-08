//
//  CompanyModelController.h
//  NavCtrl
//
//  Created by Eduard Lev on 3/1/18.
//  Copyright © 2018 Aditya Narayan. All rights reserved.

// This model controller 'CompanyModelController' contains the data for the model objects
// used in this application. It also provides methods for modifying those model objects such
// as adding and removing products and companies. It is also responsible for initilizing itself
// from data on the disk or in Core Data. The other controllers in this project must
// create a property that links to the shared instance of this object, which will allow them
// to access the data stored.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Company.h"
#import "Product.h"
#import "NetworkController.h"
#import "CompanyManagedObject+CoreDataClass.h"
#import "ProductManagedObject+CoreDataClass.h"
#import "NavControllerAppDelegate.h"
@class NavControllerAppDelegate;

@interface CompanyModelController : NSObject<StockFetcherDelegate>


// This property will hold the list of companies in this application
@property (nonatomic, strong) NSMutableArray<Company*> *companyList;

// CORE DATA
@property (nonatomic, strong) NSMutableArray<CompanyManagedObject*> *managedCompanyList;
@property (nonatomic, strong) NavControllerAppDelegate *appDelegate;
@property (nonatomic, strong) NSManagedObjectContext *context;

// This will return the shared instance of Company Model Controller as per the singleton model
+ (CompanyModelController*)sharedInstance;

/**
 * Function that adds a given company to the company list array in the Company Model Controller
 * object. If the company list array does not exist, it is allocated and initialized with
 * the input Company object.
 */
- (void)addCompany:(Company*)company;

- (void)insertCompany:(Company*)company AtIndex:(int)index;

/**
 * Function that removes a given company from the company list array in the Company Model Controller
 * object. The function returns true if the company was removed. The company may not be able to be
 * removed either because it does not exist in the company list array or because the company
 * list array does not exist. In either case, the function will return false.
 */
- (int)removeCompany:(Company*)company;

/**
 * Function that adds a given Product object to a Company that may be contained in the company
 * list array. If the product was not able to be added, the method returns false. If the product was
 * added successfully, the method returns true. The product may not be able to be added if the
 * company is not present in company list.
 *
 * @param company A Company object instance
 * @param product The product object instance which to add to the products array of 'company'
 *
 */
- (BOOL)addProduct:(Product*)product ToCompany:(Company*)company;

/**
 * Function that removes a given Product object from a Company that may be contained in the company
 * list array. If the product was not able to be removed, the method returns false. If the product
 * was removed successfully, the method returns true. The product may not be able to be removed
 * if the company is not present in company list or if the product is not present in the products.
 *
 * @param company A Company object instance
 * @param product The product object instance which to remove from the products array of 'company'
 *
 */
- (BOOL)removeProduct:(Product*)product FromCompany:(Company*)company;

- (void)getStockPrices;

@end
