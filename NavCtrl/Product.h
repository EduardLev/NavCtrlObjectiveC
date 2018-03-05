//
//  Product.h
//  NavCtrl
//
//  Created by Eduard Lev on 3/1/18.
//  Copyright © 2018 Aditya Narayan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Product : NSObject

@property (nonatomic, retain) NSString *name; // retain - match to release in dealloc
@property (nonatomic, retain) UIImage *image;

-(instancetype)initWithName:(NSString*)name
NS_DESIGNATED_INITIALIZER;

@end
