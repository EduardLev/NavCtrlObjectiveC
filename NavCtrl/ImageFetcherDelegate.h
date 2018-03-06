//
//  StockFetcherDelegate.h
//  NavCtrl
//
//  Created by Eduard Lev on 3/4/18.
//  Copyright © 2018 Aditya Narayan. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ImageFetcherDelegate <NSObject>

// Holds the filepath where the image is stored
- (void)imageFetchSuccess:(NSString*)filePath;

@optional
- (void)imageFetchDidFailWithError:(NSError*)error;
- (void)imageFetchDidStart;

@end

