//
//  MTFeedParser.h
//  MovieTime
//
//  Created by Bruno Tagliani on 5/5/12.
//  Copyright (c) 2012 SmartCode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MWFeedParser.h"

@interface MTFeedParser : NSObject <MWFeedParserDelegate> {}

-(void)getLatestSeries;
-(NSString *)googleLogin;
@property (nonatomic,strong) NSMutableArray *episodesArray;

@end
