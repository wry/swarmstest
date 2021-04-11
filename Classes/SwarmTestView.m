//
// TODO!!!!
// collision -> bigger eats smaller
// mating -> same colored ones mate (birthed child has set size, rand color), follow same course from thereon
// zones -> aggressivity, weakness, etc
// death zones -> those that enter die
// information passing (swarmlets can tell whos aggressive and steer clear of those)
//
//  SwarmTestView.m
//  SwarmTest
//
//  Created by wry on 7/26/10.
//  Copyright 2010 wry. All rights reserved.
//

#import "SwarmTestView.h"


@implementation SwarmTestView

@synthesize swarmlets, minNum, maxNum, weirdZone, deathZone, sndHandler;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
    }
    return self;
}

- (void)initSwarm {
	swarmlets = [[NSMutableArray alloc] init];
	self.minNum = 500;
	self.maxNum = 100;
	for( int i = 0; i<self.minNum; i++ ) {
		[self addSwarmlet];
	}
	CGFloat _fwidth = self.frame.size.width;
	CGFloat _fheight = self.frame.size.height;
	weirdZone = CGRectMake(_fwidth/2-_fwidth/10, 210, _fwidth/5, _fwidth/5);
	deathZone = CGRectMake(0, _fheight-5, _fheight, 5);
	
	// draw weird zone
	UILabel *_label = [[UILabel alloc] initWithFrame:weirdZone];
	_label.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.2];
	[self addSubview:_label];
	[_label release];
	
	// draw death zone
	_label = [[UILabel alloc] initWithFrame:deathZone];
	_label.backgroundColor = [UIColor colorWithRed:0 green:1 blue:0 alpha:0.2];
	[self addSubview:_label];
	[_label release];
	
	// sound initialization
	sndHandler = [[SwarmletSoundHandler alloc] init];
}

- (void)startAnimation {
	// add swarmlets
	[NSTimer scheduledTimerWithTimeInterval:5.2 target:self selector:@selector(addSwarmlet) userInfo:nil repeats:YES];
	// draw next frame
	[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(drawShiat:) userInfo:nil repeats:YES];
}

- (void)drawShiat:(NSTimer *)timer {
	//NSLog(@"name is %@", [timer userInfo]);
	[self setNeedsDisplay];
}


-(void)changeCourseForAll {
	for( Swarmlet *swarmy in swarmlets ) {
		[swarmy changeCourse];
	}
}

-(CGPoint)degreesToXY:(float)degrees withRadius:(float)radius andOrigin:(CGPoint)origin {
    CGPoint xy;
    double radians = degrees * M_PI / 180.0;
	
    xy.x = (float)cos(radians) * radius + origin.x;
    xy.y = (float)sin(-radians) * radius + origin.y;
	
    return xy;
}

-(float)XYToDegrees:(CGPoint)xy withOrigin:(CGPoint)origin {
    int deltaX = origin.x - xy.x;
    int deltaY = origin.y - xy.y;
	
    double radAngle = atan2(deltaY, deltaX);
    double degreeAngle = radAngle * 180.0 / M_PI;
	
    return (float)(180.0 - degreeAngle);
}

-(void)setDestPosOfSwarmlet:(Swarmlet *)swarmlet {
	CGPoint destPos;
	BOOL foundDest = NO;
	while( foundDest == NO ) {
		//destPos = [self degreesToXY:(float)swarmlet.direction withRadius:swarmlet.length andOrigin:swarmlet.position];
		destPos = [self degreesToXY:(float)swarmlet.direction withRadius:swarmlet.speed andOrigin:swarmlet.position];
		if( destPos.x >= 0 && destPos.x <= self.frame.size.width && destPos.y >= 0 && destPos.y <= self.frame.size.height ) {
			foundDest = YES;
		}
		else {
			// play bouncing sound when they bounce back off the wall
			[sndHandler performSelectorInBackground:@selector(playBumpSoundForSize:) withObject:swarmlet];
			// turn off feeding mode
			swarmlet.feedingMode = NO;
			// make it change course
			[swarmlet changeCourse];
		}
	}
	swarmlet.destination = destPos;
}

-(void)drawRect:(CGRect)rect {
	CGContextRef context = UIGraphicsGetCurrentContext();
	for( Swarmlet *swarmy in self.swarmlets ) {
		// get dest pos
		[self setDestPosOfSwarmlet:swarmy];
		
		// weird zone ^^
		[self handleIfSwarmyInWeirdZone:swarmy];
		
		// death zone
		swarmy.positionZone = [self getPositionZoneForPoint:swarmy.position];
		[self handleIfSwarmyInDeathZone:swarmy];
		
		// swarmy proximity
		CGContextSaveGState(context);
		[self checkSwarmyProximity:swarmy]; // experimental
		CGContextRestoreGState(context);
		
		// drawing of swarmies
		CGContextSetLineCap(context, kCGLineCapRound);
		CGContextSetLineJoin(context, kCGLineJoinRound);
		CGContextSetLineWidth(context, swarmy.width);
		CGContextSetAllowsAntialiasing(context, swarmy.aaliasing);
		CGContextSetShadowWithColor(context, CGSizeMake(0.5, 0.5), 0.5, [UIColor blackColor].CGColor);
		
		CGContextSetStrokeColorWithColor(context, swarmy.color.CGColor);
		
		CGContextMoveToPoint(context, swarmy.position.x, swarmy.position.y);
		CGContextAddLineToPoint(context, swarmy.destination.x, swarmy.destination.y);
		
		CGContextStrokePath(context);
		swarmy.position = swarmy.destination;
	}
	[self cullDeadSwarmlets];
	[self drawExperimental]; // experimental code
}

-(void)drawExperimental {
	// experimental code
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetLineWidth(context, 1);
	CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0 green:1 blue:0 alpha:0.2].CGColor);
	CGContextSetShadow(context, CGSizeMake(0, 0), 0);
	CGContextSetShouldAntialias(context, NO);
	
	int waveHeight = 5;
	int frameWidth = self.frame.size.width;
	int frameHeight = self.frame.size.height;
	int randX = (arc4random() % frameWidth)+50; // width of sine (+smoothness)
	int randY = arc4random() % waveHeight; // height of waves
	double piDouble = 2 * M_PI;
	double factor = piDouble / randX;
	
	for (int _x = 0; _x < frameWidth; _x++) {
		//double factor = piDouble / 320;
		//int j = (int) (cos(i * factor) * 240 + 240);
		int _y = (int)(cos(_x * factor) * randY + (frameHeight-waveHeight));
		CGContextMoveToPoint(context, _x, frameHeight);
		CGContextAddLineToPoint(context, _x, _y);
		CGContextStrokePath(context);
	}
}

-(void)cullDeadSwarmlets {
	NSMutableArray *deadOnes = [[NSMutableArray alloc] init]; 
	for( Swarmlet *swarmy in self.swarmlets ) {
		if( swarmy.deadMode == YES ) {
			[deadOnes addObject:swarmy];
		}
	}
	if( [deadOnes count] > 0 ) {
		[self.swarmlets removeObjectsInArray:deadOnes];
		NSLog(@"culled %d swarmlets, now only %d swarmlets left.", [deadOnes count], [self.swarmlets count]);
	}
	[deadOnes release];
}

-(void)checkSwarmyProximity:(Swarmlet *)swarmy {
	if( swarmy.reincarnatedMode || swarmy.feedingMode || swarmy.tmpAttractionCount > 12 ) {
		return;
	}
	for( Swarmlet *_swarmy in swarmlets ) {
		// no attraction when feeding or being reincarnated or they arent in attractionMode
		if( swarmy == _swarmy || _swarmy.reincarnatedMode || _swarmy.feedingMode || _swarmy.tmpAttractionCount > 12 ) {
			continue;
		}
		if( _swarmy.positionZone == swarmy.positionZone ) {
			_swarmy.attractionMode = YES;
			_swarmy.tmpAttractionCount += 1;
			swarmy.direction = [self XYToDegrees:_swarmy.position withOrigin:swarmy.position];
			_swarmy.direction = [self XYToDegrees:_swarmy.position withOrigin:swarmy.position];
			
			// optional highliting
			//[self highlightPositionWithEllipse:_swarmy.position];
			//[self highlightPositionWithEllipse:swarmy.position];
		}
	}
}

-(void)highlightPositionWithEllipse:(CGPoint)pos {
	// make them light up
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetLineWidth(context, 1);
	CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
	CGContextSetShadow(context, CGSizeMake(0, 0), 0);
	CGContextSetShouldAntialias(context, NO);
	CGContextStrokeEllipseInRect(context, CGRectMake(pos.x-ATTRACTION_ZONE_SENSITIVITY, pos.y-ATTRACTION_ZONE_SENSITIVITY, ATTRACTION_ZONE_SENSITIVITY*2, ATTRACTION_ZONE_SENSITIVITY*2));
	CGContextStrokeEllipseInRect(context, CGRectMake(pos.x-ATTRACTION_ZONE_SENSITIVITY, pos.y-ATTRACTION_ZONE_SENSITIVITY, ATTRACTION_ZONE_SENSITIVITY*2, ATTRACTION_ZONE_SENSITIVITY*2));
}

-(NSInteger)getPositionZoneForPoint:(CGPoint)point {
	CGFloat _fwidth = self.frame.size.width;
	NSInteger _pz = ((int)point.x/ATTRACTION_ZONE_SENSITIVITY)+1+((int)point.y/ATTRACTION_ZONE_SENSITIVITY)*((int)_fwidth/ATTRACTION_ZONE_SENSITIVITY);
	return(_pz);
}

-(BOOL)checkSwarmy:(Swarmlet *)swarmy forZone:(CGRect)zone {
	return CGRectContainsPoint(zone, swarmy.destination);
	/*
	if( swarmy.destination.x > zone.origin.x
	   && swarmy.destination.x < zone.origin.x + zone.size.width
	   && swarmy.destination.y > zone.origin.y
	   && swarmy.destination.y < zone.origin.y + zone.size.height ) {
		return YES;
	}
	return NO;
	 */
}

-(void)handleIfSwarmyInWeirdZone:(Swarmlet *)swarmy {
	if( [self checkSwarmy:swarmy forZone:self.weirdZone] ) {
		swarmy.width = 0.5;
		swarmy.length = 1;
		swarmy.reincarnatedMode = YES;
		swarmy.speed = 1;
	}
	else {
		if( swarmy.reincarnatedMode == YES && ( swarmy.width < 2.2 || swarmy.length < 2.2 ) ) {
			[swarmy changeSize];
			[swarmy changeColor];
			[swarmy changeSpeed];
			swarmy.reincarnatedMode = NO;
		}
	}
}

-(void)handleIfSwarmyInDeathZone:(Swarmlet *)swarmy {
	if( [self checkSwarmy:swarmy forZone:self.deathZone] ) {
		swarmy.poisonedMode = YES;
		[sndHandler performSelectorInBackground:@selector(playBurnSoundForSize:) withObject:[NSNumber numberWithFloat:swarmy.length]];
		[swarmy changeVim];
	}
	else {
		swarmy.poisonedMode = NO;
	}
}

-(void)addSwarmlet {
	if( [self.swarmlets count] < self.maxNum ) {
		Swarmlet *swarmy = [[Swarmlet alloc] init];
		swarmy.position = CGPointMake(arc4random() % (int)self.frame.size.width, arc4random() % (int)self.frame.size.height);
		swarmy.positionZone = [self getPositionZoneForPoint:swarmy.position];
		[self.swarmlets addObject:swarmy];
		[swarmy release];
	}
}

#pragma mark Touch handling methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	NSLog(@"touch began");
	[self touchesMoved:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	NSLog(@"touch cancelled");
	[self touchesEnded:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	NSLog(@"touch ended");
	for( Swarmlet *swarmy in swarmlets ) {
		swarmy.feedingMode = NO;
		[swarmy changeCourse];
	}
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	NSLog(@"touch moved");
	UITouch *touch = [touches anyObject];
	CGPoint point = [touch locationInView:self];
	for( Swarmlet *swarmy in swarmlets ) {
		swarmy.direction = [self XYToDegrees:point withOrigin:swarmy.position];
		swarmy.feedingMode = YES;
	}
}

#pragma mark Memory management

- (void)dealloc {
	[sndHandler release];
	[swarmlets release];
    [super dealloc];
}

@end
