//
//  MTCuevana.h
//  MovieTime
//
//  Created by Bruno Tagliani on 4/21/12.
//  Copyright (c) 2012 SmartCode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTShow.h"

@interface MTCuevana : NSObject

+(NSArray *)getLatestMovies;
+(NSArray *)getRecommendedMovies;
+(NSArray *)getAllSeries;
+(NSArray *)getMovies;
+(NSArray *)getSeries;
+(NSArray *)getInfoSerie:(MTShow *)serie;

@end
