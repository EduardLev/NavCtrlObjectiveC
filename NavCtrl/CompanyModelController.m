//
//  CompanyModelController.m
//  NavCtrl
//
//  Created by Eduard Lev on 3/1/18.
//  Copyright © 2018 Aditya Narayan. All rights reserved.
//

#import "CompanyModelController.h"

@implementation CompanyModelController

/**
 * Returns a foundation NSArray of Company objects
 *
 * The company objects are hard-coded with their products.
 * This class function is provided so that the user can easily
 * instantiate an array of companies.
 */
+(NSMutableArray<Company*>*)loadSampleCompanies {
  
  // QUESTION: WHEN I WAS USING A LITERAL, THE PRODUCTS WERE GOING AWAY AFTER 'viewDidLoad'??
  Product *prod1 = [[Product alloc] initWithName:@"iPhone X"];
  Product *prod2 = [[Product alloc] initWithName:@"iPad Pro"];
  Product *prod3 = [[Product alloc] initWithName:@"Macbook Pro"];
    //NSArray<Product*> *appleProducts = @[prod1, prod2, prod3];
    NSMutableArray<Product*> *appleProducts = [[NSMutableArray alloc] initWithObjects:prod1, prod2, prod3, nil];
  [prod1 release];
  [prod2 release];
  [prod3 release];
  
  prod1 = [[Product alloc] initWithName:@"Galaxy S8"];
  prod2 = [[Product alloc] initWithName:@"Galaxy Note"];
  prod3 = [[Product alloc] initWithName:@"Galaxy Tab S3"];
    NSMutableArray<Product*> *samsungProducts = [[NSMutableArray alloc] initWithObjects:prod1, prod2, prod3, nil];
  [prod1 release];
  [prod2 release];
  [prod3 release];
  
  prod1 = [[Product alloc] initWithName:@"Pixel"];
  prod2 = [[Product alloc] initWithName:@"Chromebook Pixel"];
  prod3 = [[Product alloc] initWithName:@"Home"];
  NSMutableArray<Product*> *googleProducts = [[NSMutableArray alloc] initWithObjects:prod1, prod2, prod3, nil];
  [prod1 release];
  [prod2 release];
  [prod3 release];
  
  prod1 = [[Product alloc] initWithName:@"Surface Pro"];
  prod2 = [[Product alloc] initWithName:@"Lumia 950"];
  prod3 = [[Product alloc] initWithName:@"Lumia 650"];
  NSMutableArray<Product*> *microsoftProducts = [[NSMutableArray alloc] initWithObjects:prod1, prod2, prod3, nil];
  [prod1 release];
  [prod2 release];
  [prod3 release];
  
  prod1 = [[Product alloc] initWithName:@"Kindle Fire"];
  prod2 = [[Product alloc] initWithName:@"Kindle Paperwhite"];
  prod3 = [[Product alloc] initWithName:@"Echo"];
  NSMutableArray<Product*> *amazonProducts = [[NSMutableArray alloc] initWithObjects:prod1, prod2, prod3, nil];
  [prod1 release];
  [prod2 release];
  [prod3 release];
  prod1 = nil;
  prod2 = nil;
  prod3 = nil;
  
  Company *apple = [[Company alloc] initWithName:@"Apple" AndProducts:appleProducts];
  Company *samsung = [[Company alloc] initWithName:@"Samsung" AndProducts:samsungProducts];
  Company *google = [[Company alloc] initWithName:@"Google" AndProducts:googleProducts];
  Company *microsoft = [[Company alloc] initWithName:@"Microsoft" AndProducts:microsoftProducts];
  Company *amazon = [[Company alloc] initWithName:@"Amazon" AndProducts:amazonProducts];
  
  NSMutableArray<Company*>* companies = [NSMutableArray arrayWithObjects:
                                         apple, samsung, google, microsoft, amazon, NULL];
  
  [apple release];
  [samsung release];
  [google release];
  [microsoft release];
  [amazon release];
  
  return companies;
}

@end
