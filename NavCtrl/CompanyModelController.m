//
//  CompanyModelController.m
//  NavCtrl
//
//  Created by Eduard Lev on 3/1/18.
//  Copyright © 2018 Aditya Narayan. All rights reserved.
//

#import "CompanyModelController.h"



@interface CompanyModelController ()

@property (nonatomic, strong) NetworkController *networkController;

@end

static CompanyModelController *sharedInstance = nil;

@implementation CompanyModelController

+ (CompanyModelController*)sharedInstance {
    // Checks if there is already a shared instance. If not, allocates one.
    if (sharedInstance == nil) {
      //  sharedInstance = [[CompanyModelController allocWithZone:NULL] init];
        sharedInstance = [[super allocWithZone:NULL] init] ;
     }
    return sharedInstance;
}



// Called the first time that the singleton is used
// Should load the data to this data model
// All data on companies and products will be in this model controller
- (id)init {
    self = [super init];
    if (self) {
        // Creates references to the navigation controller app delegate and context
        self.appDelegate = (NavControllerAppDelegate*)[[UIApplication sharedApplication] delegate];
        self.context = self.appDelegate.persistentContainer.viewContext;
        NSUndoManager *undoMgr =  [[NSUndoManager alloc] init];
        self.context.undoManager = undoMgr;
        [undoMgr release];
        
        [self fetchCompaniesFromCoreData];
        
        _companyList = [[NSMutableArray<Company*> alloc] init];
        if (self.managedCompanyList.count == 0) {
            // Will populate self.companyList with data written by hand in the method
            [self loadHardcodedData];
        }
        [self populateCompanyListWithFetchedData];
        
        
        
        // Counts how many times the user has launched this application
        /*if (![[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"])
        {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }*/

        // Initialize network controllers
        _networkController = [[NetworkController alloc] init];
        self.networkController.stock_delegate = self;
    }
    return self;
}

- (void)fetchCompaniesFromCoreData {
    // Creates request which will get the data saved in Core Data and retrieve it
    NSFetchRequest *request = [NSFetchRequest
                               fetchRequestWithEntityName:@"CompanyManagedObject"];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"order"
                                                                   ascending:YES];
    request.sortDescriptors = @[sortDescriptor];
    [sortDescriptor release];
    
    NSError *error = nil;
    if (_managedCompanyList == nil) {
        _managedCompanyList = [[NSMutableArray alloc]
                               initWithArray:[self.context
                                              executeFetchRequest:request
                                              error:&error]];
    } else {
        [_managedCompanyList release];
        _managedCompanyList = [[NSMutableArray alloc] initWithArray:[self.context executeFetchRequest:request error:&error]];
        //_managedCompanyList = [NSMutableArray arrayWithArray:[self.context executeFetchRequest:request error:&error]];
    }

    
    //bool HasLaunched = [[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"];
    
    if (!self.managedCompanyList) {
        NSLog(@"Error fetching Company objects: %@\n%@",
              [error localizedDescription],
              [error userInfo]);
        //abort();
    }
}

- (void)populateCompanyListWithFetchedData {
    if (self.companyList != nil) {
        [_companyList release];
    }
    _companyList = [[NSMutableArray<Company*> alloc] init];
    
    for (CompanyManagedObject *cMO in self.managedCompanyList) {
        Company *company = [[Company alloc] initWithName:cMO.name
                                                  Ticker:cMO.ticker
                                              AndLogoURL:cMO.companyLogoURL];
        company.order = cMO.order;
        
        if (company.products == nil) {
            NSMutableArray<Product*> *products_temp = [[NSMutableArray<Product*> alloc] init];
            company.products = products_temp;
            [products_temp release];
        }
        for (ProductManagedObject *pMO in cMO.products) {
            Product *product = [[Product alloc] initWithName:pMO.name
                                                     LogoURL:pMO.productLogoURL
                                                  WebsiteURL:pMO.productWebsiteURL];
            [company.products addObject:product];
            [product release];
        }
        [self.companyList addObject:company];
     //   [company.products release];
        [company release];
    }
}

- (void)undo {
    if ([self.context.undoManager canUndo]) {
        [self.context.undoManager undo];
        [self fetchCompaniesFromCoreData];
        [self populateCompanyListWithFetchedData];
        [self getStockPrices];
        [self save];
    }
}

- (void)save {
    NSError *error = nil;
    if ([[self context] save:&error] == NO) {
        NSAssert(NO, @"Error saving context: %@\n%@",
                 [error localizedDescription],
                 [error userInfo]);
    }
}

- (void)redo {
    if ([self.context.undoManager canRedo]) {
        [self.context.undoManager redo];
        [self fetchCompaniesFromCoreData];
        [self populateCompanyListWithFetchedData];
        [self getStockPrices];
        [self save];
    }
}

/**
 * This will populate 'self.companyList' with a list of 4 companies with 3 products each.
 * Website URLS only hardcorded for apple products currently.
 * Logo URL's only hardcoded for iPhone X
 */
- (void)loadHardcodedData {
    /*
    // Google Products
    prod1 = [[Product alloc] initWithName:@"Pixel"];
    prod2 = [[Product alloc] initWithName:@"Chromebook Pixel"];
    prod3 = [[Product alloc] initWithName:@"Home"];
    NSMutableArray<Product*> *googleProducts = [[NSMutableArray alloc]
                                                initWithObjects:prod1, prod2, prod3, nil];
    [prod1 release];
    [prod2 release];
    [prod3 release];
    
    // Microsoft Products
    prod1 = [[Product alloc] initWithName:@"Surface Pro"];
    prod2 = [[Product alloc] initWithName:@"Lumia 950"];
    prod3 = [[Product alloc] initWithName:@"Lumia 650"];
    NSMutableArray<Product*> *microsoftProducts = [[NSMutableArray alloc]
                                                   initWithObjects:prod1, prod2, prod3, nil];
    [prod1 release];
    [prod2 release];
    [prod3 release];
    
    // Amazon Products
    prod1 = [[Product alloc] initWithName:@"Kindle Fire"];
    prod2 = [[Product alloc] initWithName:@"Kindle Paperwhite"];
    prod3 = [[Product alloc] initWithName:@"Echo"];
    NSMutableArray<Product*> *amazonProducts = [[NSMutableArray alloc]
                                                initWithObjects:prod1, prod2, prod3, nil];
    [prod1 release];
    [prod2 release];
    [prod3 release];*/
    
        // create hardcoded products and companies
        // Apple Products
        /*Product *prod1 = [[Product alloc] initWithName:@"iPhone X"
                                               LogoURL:@"https://goo.gl/iYhNTa"
                                            WebsiteURL:@"https://www.apple.com/iphone-x/"];
        Product *prod2 = [[Product alloc] initWithName:@"iPad Pro"];
        prod2.productWebsiteURL = @"https://www.apple.com/ipad-pro/";
        Product *prod3 = [[Product alloc] initWithName:@"Macbook Pro"];
        prod3.productWebsiteURL = @"https://www.apple.com/macbook-pro/";
        NSMutableArray<Product*> *appleProducts = [[NSMutableArray alloc]
                                                   initWithObjects:prod1, prod2, prod3, nil];
        [prod1 release];
        [prod2 release];
        [prod3 release];
        prod1 = nil;
        prod2 = nil;
        prod3 = nil;*/
        
        // Create the managed object products
    
        ProductManagedObject *prod1MO = [NSEntityDescription
                                         insertNewObjectForEntityForName:@"ProductManagedObject"
                                         inManagedObjectContext:[self context]];
        prod1MO.name = @"iPhone X";
        prod1MO.productLogoURL = @"https://goo.gl/iYhNTa";
        prod1MO.productWebsiteURL = @"https://www.apple.com/iphone-x/";
        
        ProductManagedObject *prod2MO = [NSEntityDescription
                                         insertNewObjectForEntityForName:@"ProductManagedObject"
                                         inManagedObjectContext:[self context]];
        prod2MO.name = @"iPad Pro";
        prod2MO.productWebsiteURL = @"https://www.apple.com/ipad-pro/";
        
        ProductManagedObject *prod3MO = [NSEntityDescription
                                         insertNewObjectForEntityForName:@"ProductManagedObject"
                                         inManagedObjectContext:[self context]];
        prod3MO.name = @"Macbook Pro";
        prod3MO.productWebsiteURL = @"https://www.apple.com/macbook-pro/";
        
        // Create company objects with the above products
        /*Company *apple = [[Company alloc] initWithName:@"Apple"
                                            Ticker:@"AAPL"
                                        AndLogoURL:@"https://goo.gl/1gyEdF"];
        apple.products = appleProducts;*/
    
        // Just created hardcoded apple product, and will save into core data immediately
        CompanyManagedObject *appleMO = [NSEntityDescription
                                     insertNewObjectForEntityForName:@"CompanyManagedObject"
                                     inManagedObjectContext:[self context]];
        
        // connecting model object companies with the object companies
        appleMO.name = @"Apple";
        appleMO.companyLogoURL = @"https://goo.gl/1gyEdF";
        appleMO.ticker = @"AAPL";
        NSSet *set = [[NSSet alloc] initWithObjects:prod1MO, prod2MO, prod3MO, nil];
        appleMO.products = set;
        [set release];
        
        //self.companyList = [NSMutableArray arrayWithObjects: apple, nil];
        [self.managedCompanyList addObject:appleMO];
        //self.managedCompanyList = [NSMutableArray arrayWithObjects: appleMO, nil];
        //[appleMO release]; // POTENTIALLY TROUBLESOME
    
        NSError *error = nil;
        if ([[self context] save:&error] == NO) {
            NSAssert(NO, @"Error saving context: %@\n%@",
                     [error localizedDescription],
                     [error userInfo]);
        }

        //[apple release];
        //[appleProducts release];
    /*
    Company *google = [[Company alloc] initWithName:@"Google"
                                             Ticker:@"GOOGL"
                                         AndLogoURL:@"https://goo.gl/irTv1f"];
    google.products = googleProducts;
    Company *microsoft = [[Company alloc] initWithName:@"Microsoft"
                                                Ticker:@"MSFT"
                                            AndLogoURL:@"https://diylogodesigns.com/blog/wp-content/uploads/2016/04/Microsoft-Logo-icon-png-Transparent-Background.png"];
    microsoft.products = microsoftProducts;
    Company *amazon = [[Company alloc] initWithName:@"Amazon"
                                             Ticker:@"AMZN"
                                         AndLogoURL:@"https://static1.squarespace.com/static/58eac4d88419c2d993e74f57/58ed681b29687f7f1229cc79/58ed6cf259cc68798571a3e4/1502659740704/e52e202774c81a2da566d4d0a93665cd_amazon-icon-amazon-logo-clipart_512-512.png"];
    amazon.products = amazonProducts;*/
    /*
    self.companyList = [NSMutableArray arrayWithObjects:
                        apple, google, microsoft, amazon, NULL]; */
    //[google release];
    //[microsoft release];
    //[amazon release];
    //[googleProducts release];
    //[amazonProducts release];
    //[microsoftProducts release];
}

- (void)getStockPrices {
    NSMutableArray *tickerSymbols = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.companyList.count; i++) {
        [tickerSymbols addObject:self.companyList[i].ticker];
    }
    
    NSMutableString *tickerString = [[NSMutableString alloc] init];
    for (int i = 0; i < tickerSymbols.count; i++) {
        [tickerString appendString:tickerSymbols[i]];
        if (i != tickerSymbols.count - 1) {
            [tickerString appendString:@","];
        }
    }
    
    [self.networkController fetchStockPriceForTicker:tickerString];
    [tickerString release];
    [tickerSymbols release];
}

#pragma mark - Manipulation Data Model Methods

- (void)addCompany:(Company *)company {
    // Add company to the company list array with NSObjects
    if (self.companyList == nil) {
        _companyList = [[NSMutableArray<Company*> alloc] init];
    }
    [self.companyList addObject:company];
    [self.companyList lastObject].order = [self.companyList count];
    
    // Add company to the company list array with NSManagedObjects
    CompanyManagedObject *companyMO = [NSEntityDescription
                                     insertNewObjectForEntityForName:@"CompanyManagedObject"
                                              inManagedObjectContext:[self context]];
    companyMO.name = company.name;
    companyMO.ticker = company.ticker;
    companyMO.companyLogoFilepath = company.companyLogoFilepath;
    companyMO.companyLogoURL = company.companyLogoURL;
    companyMO.stockPrice = company.stockPrice;
    companyMO.order = company.order;
    // when you add a company, you are not yet adding products, so not necessary to add here
    
    [self.managedCompanyList addObject:companyMO];
    [self save];
}

- (void)insertCompany:(Company*)company AtIndex:(int)index {
    if (self.companyList == nil) {
        [self addCompany:company];
    }
    [self.companyList insertObject:company atIndex:index];
    
    // Add company to the company list array with NSManagedObjects
    CompanyManagedObject *companyMO = [NSEntityDescription
                                       insertNewObjectForEntityForName:@"CompanyManagedObject"
                                       inManagedObjectContext:[self context]];
    companyMO.name = company.name;
    companyMO.ticker = company.ticker;
    companyMO.companyLogoFilepath = company.companyLogoFilepath;
    companyMO.companyLogoURL = company.companyLogoURL;
    companyMO.stockPrice = company.stockPrice;
    
    [self.managedCompanyList insertObject:companyMO atIndex:index];
    [self save];
}

- (int)removeCompany:(Company *)company {
    // Converts the company input to uppercase in order to compare to the company list
    NSString *companyInputUppercase = [company.name uppercaseString];
    
    // Deletes form the object company list
    if (self.companyList != nil) {
        for (int i = 0; i < self.companyList.count; i++) {
            // Converts the company list name to uppercase in order to compare to input company
            NSString *companyListUppercase = [self.companyList[i].name
                                              uppercaseString];
            if ([companyListUppercase isEqualToString:companyInputUppercase]) {
                [self.companyList removeObjectAtIndex:i];
            }
        }
    }
    
    // Deletes from managed object company list
    if (self.managedCompanyList != nil) {
        for (int i = 0; i < self.managedCompanyList.count; i++) {
            // Converts the company list name to uppercase in order to compare to input company
            NSString *managedCompanyListUppercase = [self.managedCompanyList[i].name
                                                     uppercaseString];
            if ([managedCompanyListUppercase isEqualToString:companyInputUppercase]) {
                [self.context deleteObject:[self.managedCompanyList objectAtIndex:i]];
                [self.managedCompanyList removeObjectAtIndex:i];
                [self save];
                return i;
            }
        }
    }
    // returns if self.companyList = nil, or if no name is found in the list equal to input name
    return -1;
}
/*
- (void)populateCompanyListWithFetchedData {
    for (CompanyManagedObject *cMO in self.managedCompanyList) {
        Company *company = [[Company alloc] initWithName:cMO.name
                                                  Ticker:cMO.ticker
                                              AndLogoURL:cMO.companyLogoURL];
        company.products = [[NSMutableArray<Product*> alloc] init];
        for (ProductManagedObject *pMO in cMO.products) {
            Product *product = [[Product alloc] initWithName:pMO.name
                                                     LogoURL:pMO.productLogoURL
                                                  WebsiteURL:pMO.productWebsiteURL];
            [company.products addObject:product];
            //[product release];
        }
        [self.companyList addObject:company];
        //[company release];
    }
}*/

- (BOOL)addProduct:(Product*)product ToCompany:(Company*)company {
    for (Company *c in self.companyList) {
        if ([c.name isEqualToString:company.name]) {
            if (c.products == nil) {
                NSMutableArray<Product*> *temp_array = [[NSMutableArray<Product*> alloc] init];
                c.products = temp_array;
                [temp_array release];
            }
        [c.products addObject:product];
        //return true;
        }
    }
    
    ProductManagedObject *productMO = [NSEntityDescription
                                       insertNewObjectForEntityForName:@"ProductManagedObject"
                                       inManagedObjectContext:[self context]];
    productMO.name = product.name;
    productMO.productLogoURL = product.productLogoURL;
    productMO.productWebsiteURL = product.productWebsiteURL;
    productMO.productLogoFilePath = product.productLogoFilePath;
    
    for (CompanyManagedObject *companyMO in self.managedCompanyList) {
        if ([companyMO.name isEqualToString:company.name]) {
            /*if (companyMO.products == nil) {
                //companyMO.products = [[NSSet<ProductManagedObject*> alloc] init];
            }*/
            companyMO.products = [companyMO.products setByAddingObject:productMO];
            [self save];
            return true;
        }
    }
    // product was not added to the company
    return false;
}

- (BOOL)removeProduct:(Product*)product FromCompany:(Company*)company {
    NSString *productName = product.name;
    
    for (Company *c in self.companyList) {
        if ([c isEqual:company]) {
            if ([company.products containsObject:product]) {
                [company.products removeObject:product];
                //return true;
            }
        }
    }

    for (CompanyManagedObject *cMO in self.managedCompanyList) {
        if ([cMO.name isEqualToString:company.name]) {
            for (ProductManagedObject *pMO in cMO.products) {
                if ([pMO.name isEqualToString:productName]) {
                    NSMutableSet<ProductManagedObject*> *set = [cMO.products mutableCopy];
                    [set removeObject:pMO];
                    cMO.products = set;
                    [self.context deleteObject:pMO];
                    [set release];
                    [self save];
                    return true;
                }
            }
        }
    }
    
    // product was not removed from the company
    return false;
}

- (void)moveCompany:(Company*)company
          FromIndex:(NSIndexPath*)fromIndexPath
            ToIndex:(NSIndexPath*)toIndexPath {
    
    CompanyManagedObject *companyMO = [self.managedCompanyList objectAtIndex:fromIndexPath.row];
    [companyMO retain];
    
    [self.companyList removeObjectAtIndex:fromIndexPath.row];
    [self.companyList insertObject:company atIndex:toIndexPath.row];
    
    // Updates order for the company list. Sets the order to the new position they appear.
    for (int i = 0; i < self.companyList.count; i++) {
        self.companyList[i].order = i;
    }
    
    [self.managedCompanyList removeObjectAtIndex:fromIndexPath.row];
    [self.managedCompanyList insertObject:companyMO atIndex:toIndexPath.row];
    
    for (int i = 0; i < self.managedCompanyList.count; i++) {
        self.managedCompanyList[i].order = i;
    }
    // at this point the managedCompanyList matches the companyList
    
    [self save];
    [companyMO release];
    
    //[self.companyMC.companyList removeObjectAtIndex:fromIndexPath.row];
    //[self.companyMC.companyList insertObject:company atIndex:toIndexPath.row];
}

#pragma mark Singleton Methods
// We don't want to allocate a new instance, so return the current one.
+ (instancetype)allocWithZone:(NSZone*)zone {
    return [[self sharedInstance] retain];
}

// Equally, we don't want to generate multiple copies of the singleton.
- (instancetype)copyWithZone:(NSZone *)zone {
    return self;
}

// Once again - do nothing, as we don't have a retain counter for this object.
- (instancetype)retain {
    return self;
}

// Replace the retain counter so we can never release this object.
- (NSUInteger)retainCount {
    return NSUIntegerMax;
}

// This function is empty, as we don't want to let the user release this object.
- (oneway void)release {
}

//Do nothing, other than return the shared instance - as this is expected from autorelease.
- (instancetype)autorelease {
    return self;
}

#pragma mark Required Delegate Methods

// When the Network Controller finishes, it calls its delegate method, which updates the
// data model, and then sends a notification that the stock prices were updated. This notification
// will be recieved by the company view controller.
- (void)stockFetchSuccessWithPriceArray:(NSArray *)priceArray AndCompanies:(NSArray*)companies {
    // Careful here - the user may have added or deleted companies while the stock prices came in.
    // If the user has edited anything during this time, do not put the prices in.
    NSLog(@"Stock price received");
    NSLog(@"%@", priceArray);
    
    // The issue here is that some of the ticker symbols may be badly formed.
    // Therfore, the price array that comes back might have less entries than those that went out
    // Therefore if the company List looks like GOOGLE, AMAZON, APPLE, we can't assume that the
    // Price array will hold the prices of GOOGLE, AMAZON and APPLE in that order. If someone
    // used the ticker symbol GOOG for example for GOOGLE, then the 'priceArray' would only have
    // two values for AMAZON and APPLE. There we will iterate over each company and string. The
    // string array is taken from the same dictionary as the price array. Therefore
    // the strings in the 'companies' array (ticker symbols) will match up 1 to 1 with the prices.


    for (Company *c in self.companyList) {
        if ([companies containsObject:c.ticker]) {
            c.stockPrice = [priceArray objectAtIndex:[companies indexOfObject:c.ticker]];
        } else {
            c.stockPrice = @"No Price";
        }
    }

    /*
    if (self.companyList.count == priceArray.count) {
        for (int i = 0; i < priceArray.count; i++) {
            self.companyList[i].stockPrice = priceArray[i];
        }
    }*/
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kStockPricesUpdated
                                                        object:nil];
}

- (void)imageFetchSuccess {
    NSLog(@"image fetched successfully");
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"imageFetchSuccess"
                                                        object:nil];
}

- (void)imageFetchDidFailWithError:(NSError*)error {
    NSLog(@"Couldn't fetch image, this is a description of the error: %@",
          error.localizedDescription);
}

- (void)imageFetchDidStart {
    NSLog(@"initiating image fetch...");
    // could start an activity indicator here
}

- (void)stockFetchDidFailWithError:(NSError*)error {
    NSLog(@"Couldn't fetch stock price, this is a description of the error: %@",
          error.localizedDescription);
    // do some sort of error handling here
}

- (void)stockFetchDidStart {
    NSLog(@"initiating stock fetch...");
    // could start an activity indicator here
}

#pragma mark Deallocation Methods

- (void)dealloc
{
    [_networkController release];
    [_companyList release];
    [_context release];
    [_appDelegate release];
    [_managedCompanyList release];
    [super dealloc];
}

@end
