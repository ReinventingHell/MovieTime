//
//  Movie.m
//  MovieTime
//
//  Created by Bruno Tagliani on 4/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Movie.h"

@implementation Movie

//Sintetizo los atributos
@synthesize title = _title;
@synthesize url = _url;
@synthesize description = _description;
@synthesize cast = _cast;
@synthesize director = _director;
@synthesize genre = _genre;
@synthesize lang = _lang;
@synthesize duration = _duration;
@synthesize year =__year;

//Metodos
- (id)initWithTitle:(NSString *)pTitle
                url:(NSString *)pUrl 
        description:(NSString *)pDescription 
               cast:(NSString *)pCast 
           director:(NSString *)pDirector 
              genre:(NSString *)pGenre 
               lang:(NSString *)pLang
           duration:(int)pDuration 
               year:(int)pYear
{
    // Call the superclass's designated initializer
    self = [super init];
    // Give the instance variables initial values
    if (self) {
        [self setTitle:pTitle];
        [self setUrl:pUrl];
        [self setDescription:pDescription];
        [self setCast:pCast];
        [self setDirector:pDirector];
        [self setGenre:pGenre];
        [self setLang:pLang];
        [self setDuration:pDuration];
        [self setYear:pYear];
    }
    //    dateCreated = [[NSDate alloc] init];
    // Return the address of the newly initialized object
    return self;
}

@end
