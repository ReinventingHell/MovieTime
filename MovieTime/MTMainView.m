//
//  MTMainView.m
//  MovieTime
//
//  Created by Bruno Tagliani on 4/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MTMainView.h"

@implementation MTMainView

- (void)drawRect:(CGRect)rect {
	// Drawing the loading image in the background. Shift it up 20px
	// to allow for the status area.
	UIImage *bg = [UIImage imageNamed:@"Default"];
	[bg drawAtPoint:CGPointMake(0, -20)];
}

@end
