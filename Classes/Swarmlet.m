//
//  Swarmlet.m
//  SwarmTest
//
//  Created by wry on 7/26/10.
//  Copyright 2010 wry. All rights reserved.
//

#import "Swarmlet.h"

@implementation Swarmlet

@synthesize position, positionZone, destination, direction;
@synthesize width, length, aaliasing, speed, color, sndNum;
@synthesize feedingMode, poisonedMode, deadMode, attractionMode, reincarnatedMode;
@synthesize directionTimer, vimTimer;
@synthesize tmpAttractionCount;

- (id)init {
    if ((self = [super init])) {
        // init
		self.position = CGPointMake(0, 0);
		self.aaliasing = YES;
		self.feedingMode = NO;
		self.poisonedMode = NO;
		self.sndNum = arc4random() % 4;
		//self.sndNum = 2;
		
		// direction
		[self changeCourse];
		// color
		[self changeColor];
		// size
		[self changeSize];
		// speed
		[self changeSpeed];
		
		// frequency of direction change
		float _dc = (arc4random() % 25) / 10 + 0.8;
		
		// timer: change direction
		directionTimer = [NSTimer scheduledTimerWithTimeInterval:_dc target:self selector:@selector(changeCourse) userInfo:nil repeats:YES];
		// timer: shrink poisoned ones
		vimTimer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(changeVim) userInfo:nil repeats:YES];
		// timer: reset tmp attraction count
		[NSTimer scheduledTimerWithTimeInterval:2.1 target:self selector:@selector(resetTmpAttrCount) userInfo:nil repeats:YES];
    }
    return self;
}


-(void)changeCourse {
	// only change course if feeding mode is off ^^
	if( self.feedingMode == NO ) {
		self.direction = arc4random() % 360;
	}	
}

-(void)resetTmpAttrCount {
	self.tmpAttractionCount = 0;
}

-(void)changeColor {
	// only change color if feeding mode is off ^^
	if( self.feedingMode == NO ) {
		float _r = (arc4random() % 3) / 5.0;
		float _g = (arc4random() % 3) / 5.0;
		float _b = (arc4random() % 3) / 5.0;
		//float _a = (arc4random() % 10) / 10.0;
		
		self.color = [UIColor colorWithRed:_r green:_g blue:_b alpha:1];
	}	
}

-(void)changeColorToPale {
	self.color = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
}

-(void)changeSize {
	do {
		self.width = (arc4random() % SWARMY_MINSIZE+1);
		self.length = (arc4random() % SWARMY_MAXSIZE+1);
	} while( self.width > self.length );
}

-(void)changeVim {
	if( self.poisonedMode == YES ) {
		[self changeColorToPale];
		[self shrinkSwarmlet];
		//[self changeDirectionTimerToMad];
	}
}

-(void)changeSpeed {
	self.speed = (arc4random() % 3)+1;
}

-(void)shrinkSwarmlet {
	CGFloat shrinkRate = 1.2;
	CGFloat newWidth = self.width / shrinkRate;
	CGFloat newLength = self.length / shrinkRate;
	if( newWidth > 0.3 && newLength > 0.3 ) {
		self.width = newWidth;
		self.length = newLength;
	}
	else {
		self.deadMode = YES;
	}
}

-(void)changeDirectionTimerToMad {
	// this piece of fucking shiat wont work, so POSTPONING the solving of the issue :(
	//NSLog(@"releasing timer on swarmy %p", self);
	//[self.directionTimer invalidate];
	//self.directionTimer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(changeCourse) userInfo:nil repeats:YES];
}

#pragma mark Memory management

- (void)dealloc {
	[directionTimer release];
	[vimTimer release];
	[color release];
    [super dealloc];
}

@end
