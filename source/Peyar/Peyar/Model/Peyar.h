//
//  Peyar.h
//  Peyar
//
//  Created by Kishore Kumar on 11/18/14.
//  Copyright (c) 2014 com.kishorek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Peyar : NSObject

@property(nonatomic, assign) NSInteger peyarId;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *meaning;
@property(nonatomic, assign) NSInteger gender;
@property(nonatomic, strong) NSString *source;
@property(nonatomic, strong) NSString *prefix;

@end
