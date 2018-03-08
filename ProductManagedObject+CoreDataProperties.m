//
//  ProductManagedObject+CoreDataProperties.m
//  NavCtrl
//
//  Created by Eduard Lev on 3/8/18.
//  Copyright © 2018 Aditya Narayan. All rights reserved.
//
//

#import "ProductManagedObject+CoreDataProperties.h"

@implementation ProductManagedObject (CoreDataProperties)

+ (NSFetchRequest<ProductManagedObject *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"ProductManagedObject"];
}

@dynamic productLogoFilePath;
@dynamic productLogoURL;
@dynamic productWebsiteURL;
@dynamic name;

@end
