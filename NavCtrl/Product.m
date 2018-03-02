//
//  Product.m
//  NavCtrl
//
//  Created by Eduard Lev on 3/1/18.
//  Copyright © 2018 Aditya Narayan. All rights reserved.
//

#import "Product.h"

@implementation Product

// INITIALIZATION METHODS
-(instancetype)init {
  return [self initWithName:@""];
}

-(instancetype)initWithName:(NSString*)name {
  self = [super init];
  if (self) {
    _name = name;
    _image = [UIImage imageNamed:name];
      
      // FIX - WHY DO I HAVE TO DO THIS?
    [_image retain]; // IF I DON'T DO THIS, IT DISAPPEARS BY THE TIME IT GOES TO THE PRODUCT VC
  }
  return self;
}

// DESCRIPTION
-(NSString*)description {
  return [NSString stringWithFormat:@"<%@>", self.name];
}

// DEALLOC
-(void)dealloc {
    [_image release];
    [_name release];
    [super dealloc];
}

@end
