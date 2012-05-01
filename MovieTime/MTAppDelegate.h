//
//  MTAppDelegate.h
//  MovieTime
//
//  Created by Bruno Tagliani on 4/25/12.
//  Copyright (c) 2012 SmartCode. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MTMainViewController;

@interface MTAppDelegate : UIResponder <UIApplicationDelegate> 


@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) MTMainViewController *mainView;


@end
