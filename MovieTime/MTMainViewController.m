//
//  MTMainViewController.m
//  MovieTime
//
//  Created by Bruno Tagliani on 4/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MTMainViewController.h"
#import "MTMainView.h"

@interface MTMainViewController ()

@end

@implementation MTMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.view.backgroundColor = [UIColor whiteColor];
	
	UILabel *label  = [[UILabel alloc] init];
	label.text = @"Center Panel";
	[label sizeToFit];
	[self.view addSubview:label];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


// We're programmatically declaring the interface so we need to implement -loadView
//- (void)loadView {
//	// Set the view controller's main view property to a new instance of a TXMainView class
//	self.view = [[MTMainView alloc] initWithFrame:[UIScreen mainScreen].bounds];
	
	// Add the top app logo
//	UIImageView *logoView = [[UIImageView alloc] initWithFrame:CGRectMake(25, 28, 265, 115)];
//	logoView.alpha = 0;
//	logoView.transform = CGAffineTransformMakeScale(1.6, 1.6);
//	logoView.image = [UIImage imageNamed:@"logo"];
//	[self.view addSubview:logoView];
	
	// Add "choose" text image
//	UIImageView *chooseView = [[UIImageView alloc] initWithFrame:CGRectMake(24, 158, 272, 23)];
//	chooseView.alpha = 0;
//	chooseView.transform = CGAffineTransformMakeScale(1.6, 1.6);
//	chooseView.image = [UIImage imageNamed:@"choose"];
////	[self.view addSubview:chooseView];
//}

@end

