//
//  Show.h
//  MovieTime
//
//  Created by Bruno Tagliani on 4/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Show : NSObject
//Declaro los atributos
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *url;
@property (nonatomic) int seasons;
@property (nonatomic) int duration;
@property (nonatomic) int episodies;

- (id)initWithTitle:(NSString *)pTitle
                url:(NSString *)pUrl
            seasons:(int)pSeasons
           duration:(int)pDuration
          episodies:(int)pEpisodies;

- (NSString *)getIdWithSerie;

@end
