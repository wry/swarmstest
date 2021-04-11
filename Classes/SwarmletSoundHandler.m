//
//  SwarmletSoundHandler.m
//  SwarmTest
//
//  Created by wry on 7/28/10.
//  Copyright 2010 wry. All rights reserved.
//

#import "SwarmletSoundHandler.h"


@implementation SwarmletSoundHandler


#pragma mark Sound generation

-(id)init {
    if ((self = [super init])) {
		[self initSounds];
	}
	return self;
}

-(void)initSounds {
	// Finch init
	engine = [[Finch alloc] init];
	
	// au file 1
	sound1 = [[Sound alloc] initWithFile:RSRC(@"bump.wav")];
	sound2 = [[Sound alloc] initWithFile:RSRC(@"bump2.wav")];
	sound3 = [[Sound alloc] initWithFile:RSRC(@"bump3.wav")];
	sound4 = [[Sound alloc] initWithFile:RSRC(@"bump4.wav")];
	sound5 = [[Sound alloc] initWithFile:RSRC(@"burn.wav")];
}


-(void)playBumpSoundForSize:(Swarmlet *)swarmy {
	//Use audio services to play the sound
	//AudioServicesPlaySystemSound(bumpSoundID);
	//sleep(2); //define length for your sound clip
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	float _vol = 1.0; // loudest
	float _size = swarmy.length;
	if( _size <= SWARMY_MAXSIZE ) {
		_vol = _size/SWARMY_MAXSIZE;
	}
	
	float _panX, _panY;
	
	if( swarmy.position.x == 0 ) {
		_panX = -1.0;
	}
	else if( swarmy.position.x == 320 ) {
		_panX = 1.0;
	}
	else {
		_panX = (swarmy.position.x/160)-1;
	}
	
	if( swarmy.position.y == 0 ) {
		_panY = -1.0;
	}
	else if( swarmy.position.y == 480 ) {
		_panY = 1.0;
	}
	else {
		_panY = (swarmy.position.y/240)-1;
	}
	
	panning pan3d = { _panX, _panY, 1.0 };

	if( swarmy.sndNum == 0 ) {
		sound1.gain = _vol;
		sound1.pitch = _vol/2;
		sound1.pan = pan3d;
		[sound1 play];
	}
	else if( swarmy.sndNum == 1 ) {
		sound2.gain = _vol;
		sound2.pitch = _vol/2;
		sound2.pan = pan3d;
		[sound2 play];
	}
	else if( swarmy.sndNum == 2 ) {
		sound3.gain = _vol;
		sound3.pitch = _vol/2;
		sound3.pan = pan3d;
		[sound3 play];
	}
	else {
		sound4.gain = _vol;
		sound4.pitch = _vol/2;
		sound4.pan = pan3d;
		[sound4 play];
	}
	[pool release];
}

/*
-(void)playBumpSoundForSize:(Swarmlet *)swarmy {
	//Use audio services to play the sound
	//AudioServicesPlaySystemSound(bumpSoundID);
	//sleep(2); //define length for your sound clip
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	float _vol = 1.0; // loudest
	float _size = swarmy.length;
	if( _size <= SWARMY_MAXSIZE ) {
		_vol = _size/SWARMY_MAXSIZE;
	}
	
	float _pan;
	
	if( swarmy.position.x == 0 ) {
		_pan = -1.0;
	}
	else if( swarmy.position.x == 320 ) {
		_pan = 1.0;
	}
	else {
		_pan = (swarmy.position.x/160)-1;
	}	
	
	bump.gain = _vol;
	bump.pitch = _vol/2;
	[bump play];
	[pool release];
}
*/


-(void)playBurnSoundForSize:(NSNumber *)size {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	float _vol = 1.0; // loudest
	float _size = [size floatValue];
	if( _size <= SWARMY_MAXSIZE ) {
		_vol = _size/SWARMY_MAXSIZE;
	}
	NSLog(@"playing burn sound 1");
	sound5.gain = _vol;
	sound5.pitch = 0.5;
	[sound5 play];
	[pool release];
}

#pragma mark Memory management

- (void)dealloc {
	[engine release];
	[sound1 release];
	[sound2 release];
	[sound3 release];
	[sound4 release];
	[super dealloc];
}

@end
