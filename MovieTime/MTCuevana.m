//
//  MTCuevana.m
//  MovieTime
//
//  Created by Bruno Tagliani on 4/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MTUrlsCuevana.h"
#import "MTCuevana.h"
#import "SBJson.h"

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

+(NSArray *)getAllSeries
{ 
    NSURL *urlLatestMovies = [NSURL URLWithString:shows];
    NSData* data = [NSData dataWithContentsOfURL:urlLatestMovies];
    
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
        //Aca habria que instanciar un objeto de movie y agragarlo a la lista actual
        NSString *titulo = [showItem objectForKey:@"tit"];
        NSString *url = [showItem objectForKey:@"url"];
        NSLog(@"Titulo: %@",titulo);
        NSLog(@"URL: %@",url);
    }

    return nil;
}

+(NSArray *)getMovies
{

    NSURL *urlMovies = [NSURL URLWithString:movies];
    NSData* data = [NSData dataWithContentsOfURL:urlMovies];
    
    

    return nil;
}


@end
