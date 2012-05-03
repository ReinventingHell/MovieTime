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
    } while (pageNumber<=3); // ACA VA maxPages , pero para testear puse 3
    //Comenzamos a parsear, iniciamos con el string de todas las paginas
    parser = [[HTMLParser alloc] initWithString:html error:nil];
    bodyNode = [parser body];
    NSString *contienePeliculas = @"#!/peliculas/";
    //busco el nodo padre de los demas nodos con info de la pelicula, siguiendo esta estructura:
//    <a href="#!/peliculas/1833/die-another-day">
//    <div class="img"><img src="http://sc.cuevana.tv/box/1833.jpg" /></div>
//    <div class="box">
//    <div class="rate"><span style="width:79%"></span></div>
//    <div class="tit"><span class="floatl">007 - Otro Día Para Morir</span></div><div class="clearl"></div>
//    <div class="ano">2002</div>
//    <div class="txt">La nueva misión de James Bond empieza con una persecución en hidrofoil a gran velocidad a través de un campo de minas en la zona desmilitarizada del norte de Corea del Sur. De Hong Kong a...</div>
//    <div class="rep"><b>Reparto:</b> <span class="reparto">Pierce Brosnan, Halle Berry, Judi Dench, Toby Stephens, John Cleese, Madonna, Ro...</span></div>
//    <div class="in"><span class="genero">Acción</span> | <span class="idioma">Inglés</span> | <span class="duracion">123</span> min</div>
//    </div>
//    <div class="clearl"></div>
//    </a>
    NSArray *movieNodes = [bodyNode findChildrenWithAttribute:@"href" matchingName:contienePeliculas allowPartial:YES];
    //Por aca va la mano! hay que parsear los nodos hijos, q tienen la info.
    for(HTMLNode *movie in movieNodes){
        NSLog(@"HTML de la movie:%@", [movie rawContents]);
    }
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
