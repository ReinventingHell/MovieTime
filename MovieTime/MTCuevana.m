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
#import "HTMLNode.h"
#import "HTMLParser.h"

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
        //Ontengo los datos y creo la serie y la agrego a la lista
        NSString *titulo = [showItem objectForKey:@"tit"];
        NSString *url = [showItem objectForKey:@"url"];
        int duracion = [showItem objectForKey:@"duracion"];
        int episodios = [showItem objectForKey:@"episodios"];
        int temporadas = [showItem objectForKey:@"temporadas"];
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
    int pageNumber = 1;
    //Descargamos el HTML de la primer pagina de peliculas
    NSURL *urlMovies = [NSURL URLWithString:[movies stringByAppendingString:[NSString stringWithFormat:@"%d",pageNumber]]];
    NSString *html = [NSString stringWithContentsOfURL:urlMovies encoding:NSUTF8StringEncoding error:nil];
    //Creamos el parser
    HTMLParser *parser = [[HTMLParser alloc] initWithString:html error:nil];
    HTMLNode *bodyNode = [parser body];
    //Este bloque de codigo es para encontrar la cantidad maxima de paginas de peliculas
    int maxPages = 0;
    int currentValue = 0;
    NSString *page;
    //En los tags <a> se encuentra la informacion de page: 
    NSArray *aNodes = [bodyNode findChildTags:@"a"];
    for (HTMLNode *aNode in aNodes) {
        page = [[aNode getAttributeNamed:@"href"] stringByReplacingOccurrencesOfString:@"page:" withString:@""];
        currentValue = [page intValue];
        //Almacenamos el maximo valor
        if(currentValue>maxPages) maxPages = currentValue;
    }
    //Termina el bloque para encontrar la cantidad maxima de paginas de peliculas
    //Comienza a descargar TODO el codigo html de las 190 paginas para luego ser parseado...
    //Me parecia mas eficiente que descargar HTML -> parsear -> descargar HTML -> parsear..
    do {
        if(pageNumber != 1){
            urlMovies = [NSURL URLWithString:[movies stringByAppendingString:[NSString stringWithFormat:@"%d",pageNumber]]];
            html = [html stringByAppendingString:[NSString stringWithContentsOfURL:urlMovies encoding:NSUTF8StringEncoding 
                                                                             error:nil]];
        }
        pageNumber++;
        NSLog(@"Pagina: %d", pageNumber);
    } while (pageNumber<2); // ACA VA maxPages , pero para testear puse 2
    parser = [[HTMLParser alloc] initWithString:html error:nil];
    bodyNode = [parser body];
    NSString *contienePeliculas = @"#!/peliculas/";
    NSArray *movieNodes = [bodyNode findChildrenWithAttribute:@"href" matchingName:contienePeliculas allowPartial:YES];
    //Por aca va la mano! 
    for(HTMLNode *movie in movieNodes){
        NSLog(@"HTML de la movie:%@", [movie rawContents]);
    }
    return nil;
}


@end
