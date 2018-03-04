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

// Every company has a name and a list of products
@property (nonatomic, retain) NSString *name; // retain - match to release in dealloc.
@property (nonatomic, retain) NSMutableArray<Product*> *products; // retain - match to release in dealloc
@property (nonatomic, retain, strong) UIImage *image;
@property (nonatomic, retain) NSString *ticker;
@property (nonatomic, retain) NSString *stockPrice;

-(instancetype)initWithName:(NSString*)name AndProducts:(NSArray<Product*>*)products Ticker:(NSString*)ticker
NS_DESIGNATED_INITIALIZER;


@end
