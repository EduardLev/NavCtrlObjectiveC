//
//  NetworkController.h
//  NavCtrl
//
//  Created by Eduard Lev on 3/4/18.
//  Copyright © 2018 Aditya Narayan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StockFetcherDelegate.h"

@interface NetworkController : NSObject

-(void)fetchStockPriceForTicker:(NSString*) ticker;

// add delegate
 @property (nonatomic, assign) id<StockFetcherDelegate> delegate;

@end
