//
//  Company.m
//  NavCtrl
//
//  Created by Eduard Lev on 3/1/18.
//  Copyright © 2018 Aditya Narayan. All rights reserved.
//

#import "Company.h"
#import "NetworkController.h"

@interface Company ()

@property (nonatomic, retain) NetworkController *networkController;

@end

@implementation Company

@synthesize networkController;

- (instancetype)init {
    return [self initWithName:@"" Ticker:@"" AndLogoURL:@""];
}

// INITIALIZATION METHODS
- (instancetype)initWithName:(NSString*)name
                      Ticker:(NSString*)ticker
                  AndLogoURL:(NSString*)logoURL {
  self = [super init]; // MATCHED WITH SUPER DEALLOC
  if (self) {
    _name = name;
    _ticker = ticker;
    
    networkController = [[NetworkController alloc] init];
    networkController.image_delegate = self;
    [self.networkController fetchImageForUrl:logoURL WithName:name];
  }
  return self;
}

- (NSString*)description {
  return [NSString stringWithFormat:@"<%@: %@, $%@>", self.name, self.products, self.stockPrice];
}

- (void)imageFetchSuccess:(NSString*)filePath {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"imageFetchSuccess"
                                                        object:nil];
    NSLog(@"image fetched successfully");
    self.companyLogoFilepath = filePath;
    NSLog(@"%@",filePath);
}

- (void)imageFetchDidFailWithError:(NSError*)error {
    NSLog(@"Couldn't fetch image, this is a description of the error: %@",
          error.localizedDescription);
}

- (void)imageFetchDidStart {
    NSLog(@"initiating image fetch...");
    // could start an activity indicator here
}

// When deallocating, remember to release all the properties marked retain
- (void)dealloc {
    [_products release];
    [_name release];
    [_companyLogoURL release];
    [networkController release];
    [_companyLogoFilepath release];
    [_ticker release];
    [_stockPrice release];
    [super dealloc];
}

@end
