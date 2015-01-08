//
//  PeyarDBUtil.h
//  Peyar
//
//  Created by Kishore Kumar on 11/23/14.
//  Copyright (c) 2014 com.kishorek. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Peyar;

@interface PeyarDBUtil : NSObject

+(instancetype) util;

-(NSArray *) listOfLettersWithGender:(NSInteger) gender;
-(NSArray *) listOfNamesWithGender:(NSInteger) gender withStarting:(NSString *) prefix;

@end
