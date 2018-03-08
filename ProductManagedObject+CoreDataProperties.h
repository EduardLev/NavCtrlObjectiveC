//
//  ProductManagedObject+CoreDataProperties.h
//  NavCtrl
//
//  Created by Eduard Lev on 3/8/18.
//  Copyright © 2018 Aditya Narayan. All rights reserved.
//
//

#import "ProductManagedObject+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface ProductManagedObject (CoreDataProperties)

+ (NSFetchRequest<ProductManagedObject *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *productWebsiteFilePath;
@property (nullable, nonatomic, copy) NSString *productLogoURL;
@property (nullable, nonatomic, copy) NSString *productWebsiteURL;
@property (nullable, nonatomic, copy) NSString *name;

@end

NS_ASSUME_NONNULL_END
