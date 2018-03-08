//
//  CompanyManagedObject+CoreDataProperties.m
//  NavCtrl
//
//  Created by Eduard Lev on 3/8/18.
//  Copyright © 2018 Aditya Narayan. All rights reserved.
//
//

#import "CompanyManagedObject+CoreDataProperties.h"

@implementation CompanyManagedObject (CoreDataProperties)

+ (NSFetchRequest<CompanyManagedObject *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"CompanyManagedObject"];
}

@dynamic name;
@dynamic companyLogoURL;
@dynamic companyLogoFilepath;
@dynamic ticker;
@dynamic stockPrice;
@dynamic products;

@end
