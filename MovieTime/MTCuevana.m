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
#import "MTMovie.h"

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
    NSMutableArray *moviesArray = [[NSMutableArray alloc] init];;
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
        //Ya tenemos la primer pagina descargada asi que la salteamos, y luego se concatenan las demas.
        if(pageNumber != 1){
            urlMovies = [NSURL URLWithString:[movies stringByAppendingString:[NSString stringWithFormat:@"%d",pageNumber]]];
            html = [html stringByAppendingString:[NSString stringWithContentsOfURL:urlMovies encoding:NSUTF8StringEncoding 
                                                                             error:nil]];
        }
        NSLog(@"Pagina descargada:%d",pageNumber);
        pageNumber++;
    } while (pageNumber<=1); // ACA VA maxPages , pero para testear puse 3
    //Comenzamos a parsear, iniciamos con el string de todas las paginas
    parser = [[HTMLParser alloc] initWithString:html error:nil];
    bodyNode = [parser body];
    NSString *contienePeliculas = @"#!/peliculas/";
    //busco el nodo padre de los demas nodos con info de la pelicula
    NSArray *movieNodes = [bodyNode findChildrenWithAttribute:@"href" matchingName:contienePeliculas allowPartial:YES];
    //Por aca va la mano! hay que parsear los nodos hijos, q tienen la info.
    NSString *urlPelicula,*urlImagen,*titulo,*descripcion,*reparto,*genero,*idioma;
    int ano,duracion;
    for(HTMLNode *movie in movieNodes){
        
        if ([[movie children] count] > 1) { //Los nodos de pelis tiene 7 nodos y  los otros 1
            //NSLog(@"URL:%@",[movie getAttributeNamed:@"href"]);
            urlPelicula = [movie getAttributeNamed:@"href"];
            for(HTMLNode *child in [movie children]){
                if([child findChildTag:@"img"]){
                    //NSLog(@"Imagen:%@",[[child findChildTag:@"img"] getAttributeNamed:@"src"]);
                    urlImagen = [[child findChildTag:@"img"] getAttributeNamed:@"src"];
                }
                if ([[child children] count] > 3) { // Los hijos que tienen la data de pelis tienen mas que 3 nodos,mientras q los demas 3 o menos.
                    for (HTMLNode *movieData in [child children]) {
                        if([[[movieData findChildTag:@"span"] getAttributeNamed:@"class"] isEqualToString:@"floatl"]){
                            //NSLog(@"Titulo:%@",[[movieData findChildTag:@"span"] contents]);
                            titulo = [[movieData findChildTag:@"span"] contents];
                        }
                        if([[movieData getAttributeNamed:@"class"] isEqualToString:@"ano"]){
                            //NSLog(@"Año:%@",[movieData contents]);
                            ano = [[movieData contents] intValue];
                        }
                        if([[movieData getAttributeNamed:@"class"] isEqualToString:@"txt"]){
                            //NSLog(@"Descripcion:%@",[movieData contents]);
                            descripcion = [movieData contents];
                        }
                        if([[[movieData findChildTag:@"span"] getAttributeNamed:@"class"] isEqualToString:@"reparto"]){
                            //NSLog(@"Reparto:%@",[[movieData findChildTag:@"span"] contents]);
                            reparto = [[movieData findChildTag:@"span"] contents];
                        }
                        if ([[movieData findChildTags:@"span"] count]> 2) {
                            //NSLog(@"Genero:%@",[[[movieData findChildTags:@"span"] objectAtIndex:0] contents]);
                            genero = [[[movieData findChildTags:@"span"] objectAtIndex:0] contents];
                            //NSLog(@"Idioma:%@",[[[movieData findChildTags:@"span"] objectAtIndex:1] contents]);
                            idioma = [[[movieData findChildTags:@"span"] objectAtIndex:1] contents];
                            //NSLog(@"Duracion:%@",[[[movieData findChildTags:@"span"] objectAtIndex:2] contents]);
                            duracion = [[[[movieData findChildTags:@"span"] objectAtIndex:0] contents] intValue];
                        }
                    }
                }
            }
            MTMovie *movieToAdd = [[MTMovie alloc] initWithTitle:titulo url:urlPelicula description:descripcion cast:reparto director:nil genre:genero lang:idioma duration:duracion year:ano];
            [moviesArray addObject:movieToAdd];
        }
    }
    return [moviesArray copy];
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
