//
//  MTUrlsCuevana.h
//  MovieTime
//
//  Created by Mathias on 21/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTUrlsCuevana : NSObject

//Defino las constantes
//Basicas
extern NSString * const host;
extern NSString * const staticHost;
//Ver
extern NSString * const shows;
extern NSString * const showInfo;
extern NSString * const seasons;
//Peliculas
extern NSString * const movies;
extern NSString * const movieInfo;
extern NSString * const latestMovies;
extern NSString * const recomendedMovies;
//Fuentes
extern NSString * const sources;
extern NSString * const movieSources;
extern NSString * const showSources;
extern NSString * const sourceGet;
//Subtitulos
extern NSString * const subShow;
extern NSString * const subShowQuality;
extern NSString * const subMovie;
extern NSString * const subMovieQuality;
//Misc
extern NSString * const search;

@end