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

/**
 * Returns a foundation NSArray of Company objects
 *
 * The company objects are hard-coded with their products.
 * This class function is provided so that the user can easily
 * instantiate an array of companies.
 */

+(CompanyModelController*)sharedInstance {
    if (sharedInstance == nil) {
        sharedInstance = [[super allocWithZone:NULL] init];
    }
    
    return sharedInstance;
}

// Called the first time that the singleton is used
-(id)init {
    self = [super init];
    if (self) {
        
    }
    self.networkController = [[NetworkController alloc] init];
    self.networkController.delegate = self;
    return self;
}

- (NSMutableArray<Company*>*)loadSampleCompanies {
  // QUESTION: WHEN I WAS USING A LITERAL, THE PRODUCTS WERE GOING AWAY AFTER 'viewDidLoad'??
  Product *prod1 = [[Product alloc] initWithName:@"iPhone X"];
  Product *prod2 = [[Product alloc] initWithName:@"iPad Pro"];
  Product *prod3 = [[Product alloc] initWithName:@"Macbook Pro"];
    //NSArray<Product*> *appleProducts = @[prod1, prod2, prod3];
    NSMutableArray<Product*> *appleProducts = [[NSMutableArray alloc] initWithObjects:prod1, prod2, prod3, nil];
  [prod1 release];
  [prod2 release];
  [prod3 release];
  /*
  prod1 = [[Product alloc] initWithName:@"Galaxy S8"];
  prod2 = [[Product alloc] initWithName:@"Galaxy Note"];
  prod3 = [[Product alloc] initWithName:@"Galaxy Tab S3"];
    NSMutableArray<Product*> *samsungProducts = [[NSMutableArray alloc] initWithObjects:prod1, prod2, prod3, nil];
  [prod1 release];
  [prod2 release];
  [prod3 release]; */
  
  prod1 = [[Product alloc] initWithName:@"Pixel"];
  prod2 = [[Product alloc] initWithName:@"Chromebook Pixel"];
  prod3 = [[Product alloc] initWithName:@"Home"];
  NSMutableArray<Product*> *googleProducts = [[NSMutableArray alloc] initWithObjects:prod1, prod2, prod3, nil];
  [prod1 release];
  [prod2 release];
  [prod3 release];
  
  prod1 = [[Product alloc] initWithName:@"Surface Pro"];
  prod2 = [[Product alloc] initWithName:@"Lumia 950"];
  prod3 = [[Product alloc] initWithName:@"Lumia 650"];
  NSMutableArray<Product*> *microsoftProducts = [[NSMutableArray alloc] initWithObjects:prod1, prod2, prod3, nil];
  [prod1 release];
  [prod2 release];
  [prod3 release];
  
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
  
    Company *apple = [[Company alloc] initWithName:@"Apple" AndProducts:appleProducts Ticker:@"AAPL"];
    
    // REMOVED BECAUSE SAMSUNG NOT TRADED ON US STOCK MARKETS
    /*Company *samsung = [[Company alloc] initWithName:@"Samsung" AndProducts:samsungProducts Ticker:@"SSNLF"];*/
    Company *google = [[Company alloc] initWithName:@"Google" AndProducts:googleProducts Ticker:@"GOOGL"];
    Company *microsoft = [[Company alloc] initWithName:@"Microsoft" AndProducts:microsoftProducts Ticker:@"MSFT"];
    Company *amazon = [[Company alloc] initWithName:@"Amazon" AndProducts:amazonProducts Ticker:@"AMZN"];
  
  self.companyList = [NSMutableArray arrayWithObjects:
            apple, google, microsoft, amazon, NULL];
  
  [apple release];
  //[samsung release];
  [google release];
  [microsoft release];
  [amazon release];
  
    
  return self.companyList;
}

-(void)getStockPrices:(NSArray*)tickerSymbols {
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

- (void)stockFetchSuccessWithPriceArray:(NSArray *)priceArray {
    NSLog(@"Stock price received");

    for (int i = 0; i < priceArray.count; i++) {
        self.companyList[i].stockPrice = priceArray[i];
    }

}

-(void)stockFetchDidFailWithError:(NSError*)error {
    NSLog(@"Couldn't fetch stock price, this is a description of the error: %@", error.localizedDescription);
    // do some sort of error handling here
}

-(void)stockFetchDidStart {
    NSLog(@"initiation stock fetch...");
    // could start an activity indicator here
}

@end
