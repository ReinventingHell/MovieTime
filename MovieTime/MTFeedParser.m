//
//  MTFeedParser.m
//  MovieTime
//
//  Created by Bruno Tagliani on 5/5/12.
//  Copyright (c) 2012 SmartCode. All rights reserved.
//

#import "MTFeedParser.h"
#import "MTUrlsCuevana.h"
#import "MWFeedParser.h"

@implementation MTFeedParser
@synthesize episodesArray = _episodesArray;

-(void)getLatestSeries
{
    self.episodesArray = [[NSMutableArray alloc] init];
    NSURL *feedURL = [NSURL URLWithString:latestShowsRSS];
    MWFeedParser *feedParser = [[MWFeedParser alloc] initWithFeedURL:feedURL andAuth:[@"GoogleLogin auth=" stringByAppendingString:[self googleLogin]]];
    feedParser.delegate = self;
	feedParser.feedParseType = ParseTypeFull; // Parse feed info and all items
	feedParser.connectionType = ConnectionTypeSynchronously;
	[feedParser parse];
}


- (void)feedParserDidStart:(MWFeedParser *)parser {
	NSLog(@"Started Parsing: %@", parser.url);
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedInfo:(MWFeedInfo *)info {
	NSLog(@"Parsed Feed Info: “%@”", info.title);
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedItem:(MWFeedItem *)item {
	NSLog(@"Parsed Feed Item: “%@”", item.title);
	if (item) [self.episodesArray addObject:item];	
}

- (void)feedParserDidFinish:(MWFeedParser *)parser {
	NSLog(@"Finished Parsing%@", (parser.stopped ? @" (Stopped)" : @""));
    //[self updateTableWithParsedItems];
}

- (void)feedParser:(MWFeedParser *)parser didFailWithError:(NSError *)error {
	NSLog(@"Finished Parsing With Error: %@", error);
}



-(NSString *)googleLogin{
    NSString *gUserString = @"movietimeiosapp@gmail.com";
    NSString *gPassString = @"movietimepassword";
    NSString *GOOGLE_CLIENT_AUTH_URL = @"https://www.google.com/accounts/ClientLogin?client=";
    NSString *gSourceString = @"828011587087-13grm9fttepr2oca62tvb2ann7026kvt.apps.googleusercontent.com";
    //begin NSURLConnection prep:
    NSMutableURLRequest *httpReq = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:GOOGLE_CLIENT_AUTH_URL] ];
    [httpReq setTimeoutInterval:30.0];
    [httpReq setHTTPMethod:@"POST"];
    //set headers
    [httpReq addValue:@"Content-Type" forHTTPHeaderField:@"application/x-www-form-urlencoded"];
    //set post body
    NSString *requestBody = [[NSString alloc] 
                             initWithFormat:@"Email=%@&Passwd=%@&service=reader&accountType=HOSTED_OR_GOOGLE&source=%@",
                             gUserString, gPassString, [NSString stringWithFormat:@"%@%d", gSourceString]];
    [httpReq setHTTPBody:[requestBody dataUsingEncoding:NSASCIIStringEncoding]];
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = nil;
    NSString *responseStr = nil;
    data = [NSURLConnection sendSynchronousRequest:httpReq returningResponse:&response error:&error];
    responseStr = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    //extract auth
    NSArray *respArray = [responseStr componentsSeparatedByCharactersInSet: [NSCharacterSet newlineCharacterSet]];
    NSString *authString = [respArray objectAtIndex: 2];
    authString = [authString stringByReplacingOccurrencesOfString: @"Auth=" withString: @""];
    return authString;
}


@end
