//
//  Product.h
//  NavCtrl
//
//  Created by Eduard Lev on 3/1/18.
//  Copyright © 2018 Aditya Narayan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageFetcherDelegate.h"

@interface Product : NSObject<ImageFetcherDelegate>

// Stores as strings the product name, the URL for the product LOGO and the URL for the website
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *productLogoURL;
@property (nonatomic, retain) NSString *productWebsiteURL;
@property (nonatomic, retain) NSString *productLogoFilePath;

//@property (nonatomic, retain) UIImage *image;

- (instancetype)initWithName:(NSString*)name;

- (instancetype)initWithName:(NSString*)name
                    LogoURL:(NSString*)logoURL
                 WebsiteURL:(NSString*)websiteURL
NS_DESIGNATED_INITIALIZER;

@end
