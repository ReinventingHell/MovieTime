//
//  Show.h
//  MovieTime
//
//  Created by Bruno Tagliani on 4/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTShow : NSObject
//Declaro los atributos
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSString *genre;
@property (nonatomic, strong) NSString *lang;
@property (nonatomic) int seasons;
@property (nonatomic) int duration;
@property (nonatomic) int episodies;
@property (nonatomic) int year;


- (id)initWithTitle:(NSString *)pTitle
                url:(NSString *)pUrl
            seasons:(int)pSeasons
           duration:(int)pDuration
          episodies:(int)pEpisodies;

- (id)initWithTitle:(NSString *)pTitle
                url:(NSString *)pUrl 
        description:(NSString *)pDescription 
              genre:(NSString *)pGenre 
               lang:(NSString *)pLang
            seasons:(int)pSeasons
           episodes:(int)pEpisodes 
           duration:(int)pDuration 
               year:(int)pYear;

- (NSString *)getIdWithSerie;

@end
