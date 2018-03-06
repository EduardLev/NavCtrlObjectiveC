//
//  StockFetcherDelegate.h
//  NavCtrl
//
//  Created by Eduard Lev on 3/4/18.
//  Copyright © 2018 Aditya Narayan. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol StockFetcherDelegate <NSObject>

- (void)stockFetchSuccessWithPriceArray:(NSArray*)priceArray;

@optional
- (void)stockFetchDidFailWithError:(NSError*)error;
- (void)stockFetchDidStart;

@end
