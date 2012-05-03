//
//  Show.m
//  MovieTime
//
//  Created by Bruno Tagliani on 4/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Show.h"

@implementation Show

//Sintetizo los atributos
@synthesize title = _title;
@synthesize url = _url;
@synthesize seasons = _seasons;
@synthesize duration = _duration;
@synthesize episodies =_episodies;

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

- (NSString *)getIdWithSerie{
    
    NSString* id = [NSString stringWithString:[self url]];
    id = [id stringByReplacingOccurrencesOfString:@"#!/series/"
                                       withString:@""];
    
    NSRange rango = [id rangeOfString:@"/"];
    id = [id substringToIndex: rango.location];
    
    return id;
}
@end
