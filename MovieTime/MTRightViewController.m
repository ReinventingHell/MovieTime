//
//  MTRightViewController.m
//  MovieTime
//
//  Created by Bruno Tagliani on 4/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MTRightViewController.h"

@interface MTRightViewController ()

@end

@implementation MTRightViewController


- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor redColor];
	
	UILabel *label  = [[UILabel alloc] init];
	label.text = @"Right Panel";
	[label sizeToFit];
	CGRect frame = label.frame;
	frame.origin.x = self.view.bounds.size.width - 80.0f;
	label.frame = frame;
	label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
	[self.view addSubview:label];
}

@end

