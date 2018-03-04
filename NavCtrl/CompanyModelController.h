//
//  CompanyModelController.h
//  NavCtrl
//
//  Created by Eduard Lev on 3/1/18.
//  Copyright © 2018 Aditya Narayan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Company.h"
#import "Product.h"
#import "NetworkController.h"

@interface CompanyModelController : NSObject<StockFetcherDelegate>

@property (nonatomic, strong) NSMutableArray<Company*> *companyList;

+(id)sharedInstance;

-(NSMutableArray<Company*>*)loadSampleCompanies;
-(void)getStockPrices:(NSArray*)tickerSymbols;

@end
