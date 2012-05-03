//
//  MTUrlsCuevana.m
//  MovieTime
//
//  Created by Mathias on 21/04/12.
//  Copyright (c) 2012 SmartCode. All rights reserved.
//

#import "MTUrlsCuevana.h"
#define hostUrl @"http://www.cuevana.tv"

@implementation MTUrlsCuevana

//Implemento las constantes
//Basicas
NSString * const host = @"http://www.cuevana.tv";
NSString * const staticHost = @"http://sc.cuevana.tv";
//Ver
NSString * const shows = hostUrl@"/web/series";
NSString * const showInfo = hostUrl@"/web/series?&%s&%s&%s"; //deberia cambiar los %s p
NSString * const seasons = hostUrl@"/web/series?&%@&%@";
//Peliculas
NSString * const movies = hostUrl@"/web/peliculas";
NSString * const movieInfo = hostUrl@"/web/peliculas?&%s&%s";
NSString * const latestMovies = hostUrl@"/web/peliculas?&recientes";
NSString * const recomendedMovies = hostUrl@"/web/peliculas?&populares";
//Fuentes
NSString * const sources = hostUrl@"/player/sources?id=%s";
NSString * const movieSources = hostUrl@"/player/sources?id=%s&tipo=pelicula";
NSString * const showSources = hostUrl@"/player/sources?id=%s&tipo=serie";
NSString * const sourceGet = hostUrl@"/player/source_get";
//Subtitulos
NSString * const subShow = hostUrl@"/files/s/sub/%s_%s.srt";
NSString * const subShowQuality = hostUrl@"/files/s/sub/%s_%s_%s.srt";
NSString * const subMovie = hostUrl@"/files/sub/%s_%s.srt";
NSString * const subMovieQuality = hostUrl@"/files/sub/%s_%s_%s.srt";
//Misc
NSString * const search = hostUrl@"/web/buscar?&q=%s";

@end
