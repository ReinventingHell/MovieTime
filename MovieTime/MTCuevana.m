//
//  MTCuevana.m
//  MovieTime
//
//  Created by Bruno Tagliani on 4/21/12.
//  Copyright (c) 2012 SmartCode. All rights reserved.
//

#import "MTUrlsCuevana.h"
#import "MTCuevana.h"
#import "Show.h"
#import "SBJson.h"

@interface MTCuevana()
//Declaro los metodos y propiedades privadas de la clase
+(NSData *)getDataFromUrl:(NSString *)url;
@end

@implementation MTCuevana


+(NSArray *)getLatestMovies
{
    NSURL *urlLatestMovies = [NSURL URLWithString:latestMovies];
    NSData* data = [NSData dataWithContentsOfURL:urlLatestMovies];

    //Armo el string con la info de data
    NSString *respuesta = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    

    NSLog(@"%@", respuesta);

    return nil;
}

+(NSArray *)getRecommendedMovies
{
    return nil;   
}

+(NSMutableArray *)getAllSeries
{ 
    //Creo el array a retornar
    NSMutableArray *list = [[NSMutableArray alloc] init];
    
    //Obtengo la data
    NSData* data = [self getDataFromUrl:shows];
    
    //Armo el string con la info de data
    NSString *respuesta = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //Armo la expresion regular
    NSString *toParser = @"";
    NSRegularExpression *reg = [[NSRegularExpression alloc] initWithPattern:@"c.listSerie\\('', (.*?)\\);" 
                                                                    options:NSRegularExpressionSearch
                                                                      error:nil];
    NSArray *matches = [reg matchesInString:respuesta options:0 range:NSMakeRange(0, respuesta.length)];
    for (NSTextCheckingResult *match in matches) {
        NSRange matchRange = [match range];
        toParser = [respuesta substringWithRange:matchRange];
        //Quito el principio y el final
        toParser = [toParser substringFromIndex:16];
        NSUInteger toNumber = toParser.length - 2;
        toParser = [toParser substringToIndex:toNumber];
    }
    //Creo el objeto para hacer el parser
    SBJsonParser *jsonParser = [SBJsonParser new];
	//Hago el parseo y lo guardo en un array
	NSArray *showsList = [jsonParser objectWithString:toParser error:NULL];
    //Recorro los elementos del array y obtengo la informacion de estos
    for (NSDictionary *showItem in showsList) {
        //Ontengo los datos y creo la serie y la agrego a la lista
        NSString *titulo = [showItem objectForKey:@"tit"];
        NSString *url = [showItem objectForKey:@"url"];
        int duracion = [[showItem objectForKey:@"duracion"] intValue];
        int episodios = [[showItem objectForKey:@"episodios"] intValue];
        int temporadas = [[showItem objectForKey:@"temporadas"] intValue];
        //Creo la nueva serie
        Show *serie = [[Show alloc] initWithTitle:titulo
                                              url:url
                                          seasons:temporadas
                                         duration:duracion
                                        episodies:episodios];
        //Agrego a la lista
        [list addObject:serie];
                       
    }

    return list;
}

+(NSArray *)getMovies
{

//    NSURL *urlMovies = [NSURL URLWithString:movies];
//    NSData* data = [NSData dataWithContentsOfURL:urlMovies];
    
    

    return nil;
}

+(NSArray *)getInfoSerie:(Show *)serie{
    NSArray* toReturn = [[NSMutableArray alloc] init];
    //Armo la url, le concateno en donde estan los %@ el id y el title
    NSString* tituloSinEspacio = [NSString stringWithString:[serie title]];
    //Reemplazo los espacios vacios con %20
    tituloSinEspacio = [tituloSinEspacio stringByReplacingOccurrencesOfString:@" "
                                                                   withString:@"%20"];
                        
    NSString* urlConParametros = [NSString stringWithFormat:seasons,[serie getIdWithSerie],tituloSinEspacio];
    //Obtengo la data
    NSData* data = [self getDataFromUrl:urlConParametros];
    //Armo el string con la info de data
    NSString *respuesta = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

    
    return toReturn;
}

//Implementacion metodos privados
+(NSData *)getDataFromUrl:(NSString *)url{
    NSURL *urlData = [NSURL URLWithString:url];
    NSData* data = [NSData dataWithContentsOfURL:urlData];
    return data;
}    

@end
