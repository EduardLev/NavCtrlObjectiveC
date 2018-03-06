//
//  NetworkController.h
//  NavCtrl
//
//  Created by Eduard Lev on 3/4/18.
//  Copyright © 2018 Aditya Narayan. All rights reserved.
//
// This class allows fetching of stock prices and images, which require outbound network requests.
//

#import <Foundation/Foundation.h>
#import "StockFetcherDelegate.h"
#import "ImageFetcherDelegate.h"

@interface NetworkController : NSObject

/**
 * Called when a network request is desired to fetch stock prices for a comma separated string of
 * ticker values. For example, "MSFT,APPL,GOOGL", etc. The tickers must be traded on a US exchange
 * in order for the network request to recieve proper values.
 *
 * @param tickers A comma separated list of ticker symbols to request prices for
 */
- (void)fetchStockPriceForTicker:(NSString*)tickers;

/**
 * Called in order to save the contents of an image at 'logoURL' to a filepath with the name
 * in the function parameters
 *
 * @param logoURL An https web URL that holds a PNG image
 * @param name String that holds the name of the product. This will be the filename in the filepath
 *
 */
- (void)fetchImageForUrl:(NSString*)logoURL WithName:(NSString*)name;

// Delegate properties to fetch stocks and images
@property (nonatomic, assign) id<StockFetcherDelegate> stock_delegate;
@property (nonatomic, assign) id<ImageFetcherDelegate> image_delegate;

@end
