//
//  SwarmletSoundHandler.h
//  SwarmTest
//
//  Created by wry on 7/28/10.
//  Copyright 2010 wry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "Settings.h"
#import "Swarmlet.h"
#import "Finch.h"
#import "Sound.h"
#import "RevolverSound.h"

#define RSRC(x) [[NSBundle mainBundle] pathForResource:x ofType:nil]

@interface SwarmletSoundHandler : NSObject {

	// sounds
	Sound *sound1; // bump1
	Sound *sound2; // bump2
	Sound *sound3; // bump3
	Sound *sound4; // bump4
	Sound *sound5; // burn
	Finch *engine; // finch engine
}

// sound handlers
-(void)initSounds;
-(void)playBumpSoundForSize:(Swarmlet *)swarmy;
-(void)playBurnSoundForSize:(NSNumber *)size;

@end
