//
//  NetworkController.m
//  NavCtrl
//
//  Created by Eduard Lev on 3/4/18.
//  Copyright © 2018 Aditya Narayan. All rights reserved.
//

#import "NetworkController.h"

@implementation NetworkController

-(void)fetchStockPriceForTicker:(NSString*)tickers {
    
    if ([self.delegate
         respondsToSelector:@selector(stockFetchDidStart)]) {
        [self.delegate stockFetchDidStart];
    }
    
    NSString *urlString = [NSString stringWithFormat:@"https://www.alphavantage.co/query?function=BATCH_STOCK_QUOTES&symbols=%@&apikey=ELR2JZ521B5KUK2N", tickers];
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            if ([self.delegate respondsToSelector:@selector(stockFetchDidFailWithError:)]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.delegate stockFetchDidFailWithError:error];
                });
            }
        } else {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONWritingPrettyPrinted error:nil];
            NSArray *stockQuotes = dict[@"Stock Quotes"];
            NSMutableArray *prices = [[NSMutableArray alloc] init];
            for (int i = 0; i < stockQuotes.count; i++) {
                [prices addObject:[stockQuotes[i] objectForKey:@"2. price"]];
            }
            NSLog(@"%@",prices); // have my array of prices here.
                                 // need to add it back to something in the main thread
            
            [NSError release];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate stockFetchSuccessWithPriceArray:prices];
            });
            [prices release];
            
        }
    }];
    [task resume];
}

@end
