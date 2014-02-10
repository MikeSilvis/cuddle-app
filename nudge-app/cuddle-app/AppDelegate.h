//
//  AppDelegate.h
//  cuddle-app
//
//  Created by Mike Silvis on 2/10/13.
//  Copyright (c) 2013 Mike Silvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "ContactShowViewController.h"
#import <Parse/Parse.h>
#import <Crashlytics/Crashlytics.h>
#import "WelcomeController.h"
#import "GAI.h"
#define IS_IPHONE5 (([[UIScreen mainScreen] bounds].size.height-568)?NO:YES)

//#ifdef DEBUG
//  #define PARSEAPPLICATIONID @"7TZmoyE9Rdg5KvRTrEX8KctSDJ7NplhH1Oz7DR9H"
//  #define PARSECLIENTKEY @"HcUTx5Zjb3Zz4xxHgtYUKO5sHSkhqAikQpZruhHr"
//#else
  #define PARSEAPPLICATIONID @"7qRCV3hz4fajvJovE942RlmEyIbkp6f82NUwrQCW"  
  #define PARSECLIENTKEY @"DHhqhSc8mhGhrIGdR9K5s7qKoCLUeodCPQk4jkJy"
//#endif

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, retain) NSString *colleagueId;

-(void) addGoogleAnalytics;

@end
