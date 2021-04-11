//
//  SwarmTestAppDelegate.h
//  SwarmTest
//
//  Created by wry on 7/26/10.
//  Copyright wry 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SwarmTestViewController;

@interface SwarmTestAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    SwarmTestViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet SwarmTestViewController *viewController;

@end

