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
        sharedInstance = [[super allocWithZone:NULL] init];
    }
    return sharedInstance;
}

// Called the first time that the singleton is used
// Should load the data to this data model
// All data on companies and products will be in this model controller
-(id)init {
    self = [super init];
    if (self) {
        // Will populate self.companyList with data written by hand in the method
        [self loadHardcodedData];

        // Initialize network controllers
        self.networkController = [[NetworkController alloc] init];
        self.networkController.stock_delegate = self;
    }
    return self;
}

/**
 * This will populate 'self.companyList' with a list of 4 companies with 3 products each.
 * Website URLS only hardcorded for apple products currently.
 * Logo URL's only hardcoded for iPhone X
 */
-(void)loadHardcodedData {
    self.companyList = [[NSMutableArray<Company*> alloc] init];
    // create hardcoded products and companies
    // Apple Products
    
    Product *prod1 = [[Product alloc] initWithName:@"iPhone X" LogoURL:@"https://goo.gl/iYhNTa" WebsiteURL:@"https://www.apple.com/iphone-x/"];
    Product *prod2 = [[Product alloc] initWithName:@"iPad Pro"];
    prod2.productWebsiteURL = @"https://www.apple.com/ipad-pro/";
    Product *prod3 = [[Product alloc] initWithName:@"Macbook Pro"];
    prod3.productWebsiteURL = @"https://www.apple.com/macbook-pro/";
    NSMutableArray<Product*> *appleProducts = [[NSMutableArray alloc] initWithObjects:prod1, prod2, prod3, nil];
    [prod1 release];
    [prod2 release];
    [prod3 release];
    
    // Google Products
    prod1 = [[Product alloc] initWithName:@"Pixel"];
    prod2 = [[Product alloc] initWithName:@"Chromebook Pixel"];
    prod3 = [[Product alloc] initWithName:@"Home"];
    NSMutableArray<Product*> *googleProducts = [[NSMutableArray alloc] initWithObjects:prod1, prod2, prod3, nil];
    [prod1 release];
    [prod2 release];
    [prod3 release];
    
    // Microsoft Products
    prod1 = [[Product alloc] initWithName:@"Surface Pro"];
    prod2 = [[Product alloc] initWithName:@"Lumia 950"];
    prod3 = [[Product alloc] initWithName:@"Lumia 650"];
    NSMutableArray<Product*> *microsoftProducts = [[NSMutableArray alloc] initWithObjects:prod1, prod2, prod3, nil];
    [prod1 release];
    [prod2 release];
    [prod3 release];
    
    // Amazon Products
    prod1 = [[Product alloc] initWithName:@"Kindle Fire"];
    prod2 = [[Product alloc] initWithName:@"Kindle Paperwhite"];
    prod3 = [[Product alloc] initWithName:@"Echo"];
    NSMutableArray<Product*> *amazonProducts = [[NSMutableArray alloc] initWithObjects:prod1, prod2, prod3, nil];
    [prod1 release];
    [prod2 release];
    [prod3 release];
    prod1 = nil;
    prod2 = nil;
    prod3 = nil;
    
    // Create company objects with the above products
    Company *apple = [[Company alloc] initWithName:@"Apple" Ticker:@"AAPL" AndLogoURL:@"https://goo.gl/1gyEdF"];
    apple.products = appleProducts;
    Company *google = [[Company alloc] initWithName:@"Google" Ticker:@"GOOGL" AndLogoURL:@"https://goo.gl/irTv1f"];
    google.products = googleProducts;
    Company *microsoft = [[Company alloc] initWithName:@"Microsoft" Ticker:@"MSFT" AndLogoURL:@"https://diylogodesigns.com/blog/wp-content/uploads/2016/04/Microsoft-Logo-icon-png-Transparent-Background.png"];
    microsoft.products = microsoftProducts;
    Company *amazon = [[Company alloc] initWithName:@"Amazon" Ticker:@"AMZN" AndLogoURL:@"https://static1.squarespace.com/static/58eac4d88419c2d993e74f57/58ed681b29687f7f1229cc79/58ed6cf259cc68798571a3e4/1502659740704/e52e202774c81a2da566d4d0a93665cd_amazon-icon-amazon-logo-clipart_512-512.png"];
    amazon.products = amazonProducts;
    
    self.companyList = [NSMutableArray arrayWithObjects:
                        apple, google, microsoft, amazon, NULL];
    
    [apple release];
    [google release];
    [microsoft release];
    [amazon release];
}

-(void)getStockPrices {
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
}

#pragma mark - Manipulation Data Model Methods

- (void)addCompany:(Company *)company {
    if (self.companyList == nil) {
        self.companyList = [[NSMutableArray<Company*> alloc] init];
    }
    [self.companyList addObject:company];
}

- (BOOL)removeCompany:(Company *)company {
    // Converts the company input to uppercase in order to compare to the company list
    NSString *companyInputUppercase = [company.name uppercaseString];
    if (self.companyList != nil) {
        for (int i = 0; i < self.companyList.count; i++) {
            // Convers the company list name to uppercase in order to compare to input company
            NSString *companyListUppercase = [self.companyList[i].name uppercaseString];
            if ([companyListUppercase isEqualToString:companyInputUppercase]) {
                [self.companyList removeObjectAtIndex:i];
                return true;
            }
        }
    }
    
    // returns if self.companyList = nil, or if no name is found in the list equal to input name
    return false;
}

- (BOOL)addProduct:(Product*)product ToCompany:(Company*)company {
    for (Company *c in self.companyList) {
        if ([c isEqual:company]) {
            [c.products addObject:product];
            return true;
        }
    }
    // product was not added to the company
    return false;
}

- (BOOL)removeProduct:(Product*)product FromCompany:(Company*)company {
    for (Company *c in self.companyList) {
        if ([c isEqual:company]) {
            if ([company.products containsObject:product]) {
                [company.products removeObject:product];
                return true;
            }
        }
    }
    // product was not removed from the company
    return false;
}

-(void)dealloc
{
    [_networkController release];
    [super dealloc];
}

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
- (void)stockFetchSuccessWithPriceArray:(NSArray *)priceArray {
    // Careful here - the user may have added or deleted companies while the stock prices came in.
    // If the user has edited anything during this time, do not put the prices in.
    NSLog(@"Stock price received");
    NSLog(@"%@", priceArray);
    if (self.companyList.count == priceArray.count) {
        for (int i = 0; i < priceArray.count; i++) {
            self.companyList[i].stockPrice = priceArray[i];
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"stockPricesUpdated"
                                                        object:nil];
}

- (void)imageFetchSuccess {
    NSLog(@"image fetched successfully");
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"imageFetchedSuccessfully"
                                                        object:nil];
}

- (void)imageFetchDidFailWithError:(NSError*)error {
    NSLog(@"Couldn't fetch image, this is a description of the error: %@", error.localizedDescription);
}

- (void)imageFetchDidStart {
    NSLog(@"initiating image fetch...");
    // could start an activity indicator here
}

-(void)stockFetchDidFailWithError:(NSError*)error {
    NSLog(@"Couldn't fetch stock price, this is a description of the error: %@", error.localizedDescription);
    // do some sort of error handling here
}

-(void)stockFetchDidStart {
    NSLog(@"initiating stock fetch...");
    // could start an activity indicator here
}

@end
