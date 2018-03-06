//
//  NetworkController.m
//  NavCtrl
//
//  Created by Eduard Lev on 3/4/18.
//  Copyright © 2018 Aditya Narayan. All rights reserved.
//

#import "NetworkController.h"

@implementation NetworkController

- (void)fetchStockPriceForTicker:(NSString*)tickers {
    if ([self.stock_delegate
         respondsToSelector:@selector(stockFetchDidStart)]) {
        [self.stock_delegate stockFetchDidStart];
    }
    
    NSString *urlBase = @"https://www.alphavantage.co/query?function=BATCH_STOCK_QUOTES&";
    NSString *urlString = [NSString stringWithFormat:@"%@symbols=%@&apikey=ELR2JZ521B5KUK2N",
                           urlBase,
                           tickers];
    NSURL *url = [NSURL URLWithString:urlString];
    NSLog(@"%@",urlString);
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url
        completionHandler:^(NSData * _Nullable data,
                            NSURLResponse * _Nullable response,
                            NSError * _Nullable error) {
        if (error) {
            if ([self.stock_delegate respondsToSelector:@selector(stockFetchDidFailWithError:)]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.stock_delegate stockFetchDidFailWithError:error];
                });
            }
        } else {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:NSJSONReadingAllowFragments
                                                                   error:nil];
            NSArray *stockQuotes = dict[@"Stock Quotes"];
            NSMutableArray *prices = [[NSMutableArray alloc] init];
            for (int i = 0; i < stockQuotes.count; i++) {
                [prices addObject:[stockQuotes[i] objectForKey:@"2. price"]];
            }
            [NSError release];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.stock_delegate stockFetchSuccessWithPriceArray:prices];
            });
            [prices release];
        }
    }];
    [task resume];
}

- (void)fetchImageForUrl:(NSString*)logoURL WithName:(NSString*)name {
    if ([self.image_delegate
         respondsToSelector:@selector(imageFetchDidStart)]) {
            [self.image_delegate imageFetchDidStart];
    }
    
    NSURL *url = [NSURL URLWithString:logoURL];
    NSURLSessionDownloadTask *task = [[NSURLSession sharedSession] downloadTaskWithURL:url completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        UIImage *logo = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
        if (logo) {
            NSString *fileName = [NSString stringWithFormat:@"%@.png", name];
            NSString *filePath = [self documentsPathForFileName:fileName];
            NSData *data = UIImagePNGRepresentation(logo);
            [data writeToFile:filePath atomically:YES];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.image_delegate imageFetchSuccess:filePath];
            });
        }
        
        if (error) {
            if ([self.image_delegate respondsToSelector:@selector(imageFetchDidFailWithError:)]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.image_delegate imageFetchDidFailWithError:error];
                });
            }
        }
    }];
    [task resume];
}
    
/**
 * This function returns the filepath for a new filename. The file path will be in the
 * users Documents directory
 *
 * @param name The name of the file that you would like the path to be made for
 */
- (NSString*)documentsPathForFileName:(NSString*)name {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask,
                                                         YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    
    return [documentsPath stringByAppendingPathComponent:name];
}

@end
