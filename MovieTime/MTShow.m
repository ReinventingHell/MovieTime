//
//  Show.m
//  MovieTime
//
//  Created by Bruno Tagliani on 4/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MTShow.h"

@implementation MTShow

//Sintetizo los atributos
@synthesize title = _title;
@synthesize url = _url;
@synthesize seasons = _seasons;
@synthesize duration = _duration;
@synthesize episodies =_episodies;
@synthesize description =_description;
@synthesize genre =_genre;
@synthesize lang =_lang;
@synthesize year =_year;

//Metodos
- (id)initWithTitle:(NSString *)pTitle
                url:(NSString *)pUrl
            seasons:(int)pSeasons
           duration:(int)pDuration
          episodies:(int)pEpisodies
{
    // Call the superclass's designated initializer
    self = [super init];
    // Give the instance variables initial values
    if (self) {
        [self setTitle:pTitle];
        [self setUrl:pUrl];
        [self setSeasons:pSeasons];
        [self setDuration:pDuration];
        [self setEpisodies:pEpisodies];
    }
    // Return the address of the newly initialized object
    return self;
}

- (id)initWithTitle:(NSString *)pTitle
                url:(NSString *)pUrl 
        description:(NSString *)pDescription 
              genre:(NSString *)pGenre 
               lang:(NSString *)pLang
            seasons:(int)pSeasons
           episodes:(int)pEpisodies 
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
        [self setGenre:pGenre];
        [self setLang:pLang];
        [self setSeasons:pSeasons];
        [self setYear:pYear];
        [self setDuration:pDuration];
        [self setEpisodies:pEpisodies];
    }
    // Return the address of the newly initialized object
    return self;
}

- (NSString *)getIdWithSerie{
    
    NSString* id = [NSString stringWithString:[self url]];
    id = [id stringByReplacingOccurrencesOfString:@"#!/series/"
                                       withString:@""];
    
    NSRange rango = [id rangeOfString:@"/"];
    id = [id substringToIndex: rango.location];
    
    return id;
}
@end
