//
//  Company.h
//  NavCtrl
//
//  Created by Eduard Lev on 3/1/18.
//  Copyright © 2018 Aditya Narayan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageFetcherDelegate.h"
#import "Product.h"

@interface Company : NSObject<ImageFetcherDelegate>

@property (nonatomic, retain) NSString *name; // retain - match to release in dealloc.

// URL for getting the logo of the company
@property (nonatomic, retain) NSString *companyLogoURL; // retain - match to release in dealloc.

// Filepath for the logo image of the company
@property (nonatomic, retain) NSString *companyLogoFilepath;

// Ticker Symbol for the Company. Must be a ticker symbol on a US-Based exchange.
@property (nonatomic, retain) NSString *ticker;

// String of the current stock price on a US-Based exchange in USD.
@property (nonatomic, retain) NSString *stockPrice;

// Mutable Array of the products sold by this company
@property (nonatomic, retain) NSMutableArray<Product*> *products;

-(instancetype)initWithName:(NSString*)name
                     Ticker:(NSString*)ticker
                 AndLogoURL:(NSString*)logoURL
NS_DESIGNATED_INITIALIZER;

@end
