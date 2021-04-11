//
//  SwarmTestView.h
//  SwarmTest
//
//  Created by wry on 7/26/10.
//  Copyright 2010 wry. All rights reserved.
//

#define ATTRACTION_ZONE_SENSITIVITY 20

#import <UIKit/UIKit.h>
#import "Swarmlet.h"
#import "SwarmletSoundHandler.h"

@interface SwarmTestView : UIView <AVAudioPlayerDelegate> {
	
	NSMutableArray *swarmlets;
	NSInteger minNum;
	NSInteger maxNum;
	CGRect weirdZone;
	CGRect deathZone;
	SwarmletSoundHandler *sndHandler;
}

-(void)initSwarm;
-(void)addSwarmlet;
-(void)drawShiat:(NSTimer *)timer;
-(void)startAnimation;
-(CGPoint)degreesToXY:(float)degrees withRadius:(float)radius andOrigin:(CGPoint)origin;
-(void)setDestPosOfSwarmlet:(Swarmlet *)swarmlet;
-(void)changeCourseForAll;

// interaction handlers
-(void)checkSwarmyProximity:(Swarmlet *)swarmy;
-(void)cullDeadSwarmlets;

-(NSInteger)getPositionZoneForPoint:(CGPoint)point;
-(void)highlightPositionWithEllipse:(CGPoint)pos;

// zone handlers
-(BOOL)checkSwarmy:(Swarmlet *)swarmy forZone:(CGRect)zone;
-(void)handleIfSwarmyInWeirdZone:(Swarmlet *)swarmy;
-(void)handleIfSwarmyInDeathZone:(Swarmlet *)swarmy;

// experimental code
-(void)drawExperimental;

@property (nonatomic, retain) NSMutableArray *swarmlets;
@property (nonatomic, assign) NSInteger minNum;
@property (nonatomic, assign) NSInteger maxNum;
@property (nonatomic, assign) CGRect weirdZone;
@property (nonatomic, assign) CGRect deathZone;
@property (nonatomic, retain) SwarmletSoundHandler *sndHandler;

@end
