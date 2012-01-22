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
    x = newX;
}

-(void) setY:(double) newY
{
    y = newY;
}

-(void) addPointX:(double) newX Y:(double) newY
{
    [self setX:newX];
    [self setY:newY];
}

@end
