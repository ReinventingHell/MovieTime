//
//  Movie.h
//  MovieTime
//
//  Created by Bruno Tagliani on 4/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTMovie : NSObject
//Declaro los atributos
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSString *cast; //reparto
@property (nonatomic, strong) NSString *director;
@property (nonatomic, strong) NSString *genre; //genero
@property (nonatomic, strong) NSString *lang; //idioma
@property (nonatomic) int duration;
@property (nonatomic) int year;

- (id)initWithTitle:(NSString *)pTitle
                url:(NSString *)pUrl 
        description:(NSString *)pDescription 
               cast:(NSString *)pCast 
           director:(NSString *)pDirector 
              genre:(NSString *)pGenre 
               lang:(NSString *)pLang
           duration:(int)pDuration 
               year:(int)pYear;
@end
