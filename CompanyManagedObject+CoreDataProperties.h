//
//  CompanyManagedObject+CoreDataProperties.h
//  NavCtrl
//
//  Created by Eduard Lev on 3/8/18.
//  Copyright © 2018 Aditya Narayan. All rights reserved.
//
//

#import "CompanyManagedObject+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface CompanyManagedObject (CoreDataProperties)

+ (NSFetchRequest<CompanyManagedObject *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *companyLogoURL;
@property (nullable, nonatomic, copy) NSString *companyLogoFilepath;
@property (nullable, nonatomic, copy) NSString *ticker;
@property (nullable, nonatomic, copy) NSString *stockPrice;
@property (nullable, nonatomic, retain) NSSet<ProductManagedObject *> *products;

@end

@interface CompanyManagedObject (CoreDataGeneratedAccessors)

- (void)addProductsObject:(ProductManagedObject *)value;
- (void)removeProductsObject:(ProductManagedObject *)value;
- (void)addProducts:(NSSet<ProductManagedObject *> *)values;
- (void)removeProducts:(NSSet<ProductManagedObject *> *)values;

@end

NS_ASSUME_NONNULL_END
