//
//  Company.m
//  NavCtrl
//
//  Created by Eduard Lev on 3/1/18.
//  Copyright © 2018 Aditya Narayan. All rights reserved.
//

#import "Company.h"

@implementation Company

// INITIALIZATION METHODS
-(instancetype)init {
  return [self initWithName:@"" AndProducts:nil];
}

-(instancetype)initWithName:(NSString*)name AndProducts:(NSMutableArray<Product*>*)products {
  self = [super init]; // MATCHED WITH SUPER DEALLOC
  if (self) {
    _name = name;
    _products = products;
    _image = [UIImage imageNamed:name];
    [_image retain];
  }
  return self;
}

// DESCRIPTION
-(NSString*)description {
  return [NSString stringWithFormat:@"<%@: %@>", self.name, self.products];
} 

// When deallocating, remember to release all the properties marked retain
-(void)dealloc {
    //[_image release];
    [_products release];
    [_name release];
    [super dealloc];
}

@end
