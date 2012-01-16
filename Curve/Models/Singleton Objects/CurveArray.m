//
//  CurveArray.m
//  Curve
//
//  Created by Bradley Clemetson on 1/14/12.
//  Copyright (c) 2012 Codeprogrammers for Gonzaga University. All rights reserved.
//

#import "CurveArray.h"
#import "curveMath.h"

@implementation CurveArray
@synthesize curveListObjects;


static CurveArray *shared = nil;


/*
// Get the shared instance and create it if necessary.
+ (CurveArray *)shared
{
    if (nil != shared) 
    {
        return shared;
    }
    
    static dispatch_once_t pred;        // Lock
    dispatch_once(&pred, ^{             // This code is called at most once per app
        shared = [[CurveArray alloc] init];
    });
    
    return shared;
}
*/

+ (CurveArray *)shared 
{
    if (shared == nil) 
    {
        shared = [[super allocWithZone:NULL] init];
    }
    
    return shared;
}

// We can still have a regular init method, that will get called the first time the Singleton is used.
- (id)init
{
    self = [super init];
    
    if (self) {
        // Work your initialising magic here as you normally would
    }
    
    return self;
}

// Your dealloc method will never be called, as the singleton survives for the duration of your app.
// However, I like to include it so I know what memory I'm using (and incase, one day, I convert away from Singleton).
-(void)dealloc
{
    // I'm never called!
    [super dealloc];
}

// We don't want to allocate a new instance, so return the current one.
+ (id)allocWithZone:(NSZone*)zone 
{
    return [[self shared] retain];
}

// Equally, we don't want to generate multiple copies of the singleton.
- (id)copyWithZone:(NSZone *)zone {
    return self;
}

// Once again - do nothing, as we don't have a retain counter for this object.
- (id)retain {
    return self;
}

// Replace the retain counter so we can never release this object.
- (NSUInteger)retainCount {
    return NSUIntegerMax;
}

// This function is empty, as we don't want to let the user release this object.
- (oneway void)release {
    
}

//Do nothing, other than return the shared instance - as this is expected from autorelease.
- (id)autorelease {
    return self;
}

@end
