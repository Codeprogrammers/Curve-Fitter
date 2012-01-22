//
//  PointXY.m
//  Curve
//
//  Created by Nicholas Interrante on 1/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PointXY.h"

@implementation PointXY

@synthesize x, y;

-(void) setX:(double) newX
{
    self.x = newX;
}

-(void) setY:(double) newY
{
    self.y = newY;
}

-(void) addPointX:(double) newX Y:(double) newY
{
    [self setX:newX];
    [self setY:newY];
}

+(void) setX:(double) newX
{
    self.x = newX;
}

+(void) setY:(double) newY
{
    self.y = newY;
}

+(PointXY *) addPointX:(double) newX Y:(double) newY
{
    PointXY *newPoint;
    [newPoint setX:newX];
    [newPoint setY:newY];
    
    return newPoint;
}

@end
