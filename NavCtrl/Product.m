//
//  Product.m
//  NavCtrl
//
//  Created by Eduard Lev on 3/1/18.
//  Copyright © 2018 Aditya Narayan. All rights reserved.
//

#import "Product.h"
#import "NetworkController.h"

@interface Product ()
    
@property (nonatomic, retain) NetworkController *networkController;

@end
    
@implementation Product

- (instancetype)init {
  return [self initWithName:@"" LogoURL:@"" WebsiteURL:@""];
}

- (instancetype)initWithName:(NSString*)name {
    return [self initWithName:name LogoURL:@"" WebsiteURL:@""];
}

- (instancetype)initWithName:(NSString*)name
                    LogoURL:(NSString*)logoURL
                 WebsiteURL:(NSString*)websiteURL {
  self = [super init];
  if (self) {
    self.name = name;
    self.productWebsiteURL = websiteURL;
    self.productLogoURL = logoURL;

    _networkController = [[NetworkController alloc] init];
    self.networkController.image_delegate = self;
    [self.networkController fetchImageForUrl:logoURL WithName:name];
  }
  return self;
}

// DESCRIPTION
- (NSString*)description {
  return [NSString stringWithFormat:@"<%@>", self.name];
}

- (void)imageFetchSuccess:(NSString*)filePath {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"imageFetchSuccess"
                                                        object:nil];
    NSLog(@"image fetched successfully");
    self.productLogoFilePath = filePath;
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

// DEALLOC
- (void)dealloc {
    [_image release];
    [_name release];
    [_productLogoURL release];
    [_productWebsiteURL release];
    [_productLogoFilePath release];
    [_networkController release];
    [super dealloc];
}

@end
