//
//  Swarmlet.h
//  SwarmTest
//
//  Created by wry on 7/26/10.
//  Copyright 2010 wry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "Settings.h"

@interface Swarmlet : NSObject {
	// position
	CGPoint position;
	NSInteger positionZone;
	CGPoint destination;
	CGFloat direction;
	
	// attributes
	CGFloat width;
	CGFloat length;
	UIColor *color;
	NSInteger speed;
	BOOL aaliasing;
	
	// modes
	BOOL feedingMode;
	BOOL poisonedMode;
	BOOL deadMode;
	BOOL attractionMode;
	BOOL reincarnatedMode;
	
	// experimental
	//CGSize shadowSize;
	//CGFloat shadowBlur;
	//CGColorRef shadowColor;
	
	// timers
	NSTimer *directionTimer;
	NSTimer *vimTimer;
	NSInteger tmpAttractionCount;
	
	// sounds
	NSInteger sndNum;
}


// altering attributes
-(void)changeCourse;
-(void)changeColor;
-(void)changeColorToPale;
-(void)changeSize;
-(void)changeVim;
-(void)changeSpeed;

// effects
-(void)shrinkSwarmlet;
-(void)changeDirectionTimerToMad;

@property (nonatomic, assign) CGPoint position;
@property (nonatomic, assign) NSInteger positionZone;
@property (nonatomic, assign) CGPoint destination;
@property (nonatomic, assign) CGFloat direction;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat length;
@property (nonatomic, assign) BOOL aaliasing;
@property (nonatomic, assign) BOOL feedingMode;
@property (nonatomic, assign) BOOL poisonedMode;
@property (nonatomic, assign) BOOL deadMode;
@property (nonatomic, assign) BOOL attractionMode;
@property (nonatomic, assign) BOOL reincarnatedMode;
@property (nonatomic, assign) NSInteger speed;
@property (nonatomic, retain) UIColor *color;
@property (retain) NSTimer *directionTimer;
@property (retain) NSTimer *vimTimer;
@property (nonatomic, assign) NSInteger tmpAttractionCount;
@property (nonatomic, assign) NSInteger sndNum;

@end
