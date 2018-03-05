//
//  Company.h
//  NavCtrl
//
//  Created by Eduard Lev on 3/1/18.
//  Copyright © 2018 Aditya Narayan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Product.h"

@interface Company : NSObject

@property (nonatomic, retain) NSString *name; // retain - match to release in dealloc.

// String and URL for getting the image for the company
@property (nonatomic, retain) NSString *logoString; // retain - match to release in dealloc.
@property (nonatomic, retain) NSString *logoURL; // retain - match to release in dealloc.

// Ticker Symbol for the Company. Must be a ticker symbol on a US-Based exchange.
@property (nonatomic, retain) NSString *ticker;

// String of the current stock price on a US-Based exchange in USD.
@property (nonatomic, retain) NSString *stockPrice;

// Mutable Array of the products sold by this company
@property (nonatomic, retain) NSMutableArray<Product*> *products; // retain - match to release in dealloc

// Is this image necessary after I change it to download?
@property (nonatomic, retain, strong) UIImage *image;

-(instancetype)initWithName:(NSString*)name
                AndProducts:(NSArray<Product*>*)products
                     Ticker:(NSString*)ticker
NS_DESIGNATED_INITIALIZER;


@end
