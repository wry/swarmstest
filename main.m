//
//  main.m
//  SwarmTest
//
//  Created by wry on 7/26/10.
//  Copyright wry 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

int main(int argc, char *argv[]) {
	int retVal = 0;
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	@try {
		retVal = UIApplicationMain(argc, argv, nil, nil);
	} @catch(NSException * e) {
		NSLog(@"Exception: %@", e);
	}
    [pool release];
    return retVal;
}
