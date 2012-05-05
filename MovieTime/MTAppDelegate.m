//
//  MTAppDelegate.m
//  MovieTime
//
//  Created by Bruno Tagliani on 4/25/12.
//  Copyright (c) 2012 SmartCode. All rights reserved.
//

#import "MTCuevana.h"
#import "MTShow.h"
#import "MTMovie.h"
#import "MTAppDelegate.h"
#import "MTMainViewController.h"
#import "MTFeedParser.h"

@implementation MTAppDelegate

@synthesize window;
@synthesize mainView;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	// Initialize the main application window, set its size to the screen's applicationFrame
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.window.rootViewController = [[MTMainViewController alloc] initWithNibName:nil bundle:nil];
    
    
    [self.window makeKeyAndVisible];
    
    //Pruebas
    NSLog(@"-------- DESCARGANDO PAGE 1 DE MOVIES -------");
    NSArray *listaMovies = [MTCuevana getMovies];
    for (MTMovie *listaItem in listaMovies) {
        NSLog(@"Titulo: %@", listaItem.title);
        NSLog(@"Url: %@", listaItem.url);
    }
    NSLog(@"-------- TERMINO PAGE 1 DE MOVIES -------");
    NSLog(@"-------- DESCARGANDO JSON SERIES -------");
    NSArray *listaShows = [MTCuevana getAllSeries];
    NSArray *infoShow;
    for (MTShow *listaItem in listaShows) {
        NSLog(@"Titulo: %@", listaItem.title);
        NSLog(@"Url: %@", listaItem.url);
        // EL parser de info anda bien pero hay algun problema con la URL que armamos.. porque algunos links tienen - no espacios
//        NSLog(@"-------- INFO -------");
//        infoShow = [MTCuevana getInfoSerie:listaItem];
//        if(infoShow){
//            NSLog(@"Url Imagen: %@", [infoShow objectAtIndex:0]);
//            NSLog(@"Año: %@", [infoShow objectAtIndex:2]);
//            NSLog(@"Descripcion: %@", [infoShow objectAtIndex:3]);
//            NSLog(@"Genero: %@", [infoShow objectAtIndex:4]);
//            NSLog(@"Duracion: %@", [infoShow objectAtIndex:5]);
//            NSLog(@"---------TERMINA INFO -------");
//        }
    }
    NSLog(@"-------- TERMINO JSON SERIES -------");
    NSLog(@"-------- DESCARGANDO PAGE 1 DE SERIES -------");
    NSArray *listaShowsPorHTML = [MTCuevana getSeries];
    for (MTShow *listaItem in listaShowsPorHTML) {
        NSLog(@"Titulo: %@", listaItem.title);
        NSLog(@"Url: %@", listaItem.url);
        //La url de la imagen no se guarda en el objeto Show...
        NSLog(@"Descripcion: %@", listaItem.description);
        NSLog(@"Año: %d", listaItem.year );
        NSLog(@"Genero: %@", listaItem.genre);
        NSLog(@"Duracion: %d", listaItem.duration);
        NSLog(@"Idioma: %@", listaItem.lang);
        NSLog(@"Temporadas: %d", listaItem.seasons);
    }
    NSLog(@"-------- TERMINO PAGE 1 DE SERIES -------");
    NSLog(@"-------- DESCARGANDO FEED DE ULTIMOS CAPITULOS -------");
    MTFeedParser *parser = [[MTFeedParser alloc] init];
    [parser getLatestSeries];
    for (MWFeedItem *listaItem in [parser episodesArray]) {
        NSLog(@"Titulo: %@", listaItem.title);
        NSLog(@"Link: %@", listaItem.link);
        NSLog(@"Fecha: %@", listaItem.date);
        NSLog(@"Descripcion: %@", listaItem.summary);
        //NSLog(@"Todo: %@", listaItem.description);
    }
    NSLog(@"Count:%d",[[parser episodesArray] count]);
    NSLog(@"-------- TERMINO FEED DE ULTIMOS CAPITULOS -------");
    //fin pruebas
    
    return YES;
    
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
