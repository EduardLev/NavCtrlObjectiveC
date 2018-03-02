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

@interface CompanyModelController : NSObject

+(id)sharedInstance;

-(NSMutableArray<Company*>*)loadSampleCompanies;

@end
