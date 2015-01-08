//
//  DBUtil.h
//  FMDB Test
//
//  Created by Kishore on 24/7/14.
//  Copyright (c) 2014 Kishorek. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Peyar;

@interface FavDBUtil : NSObject

+(instancetype) util;

-(void) saveFavorite:(Peyar *) peyar;
-(NSArray *) fetchFavorites;

-(void) removeFavorite:(NSInteger) favId;
-(BOOL) isFavorite:(NSInteger) favId;


@end
