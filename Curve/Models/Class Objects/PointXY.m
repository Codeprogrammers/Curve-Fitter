//
//  PointXY.m
//  Curve
//
//  Created by Nicholas Interrante + Bradley Clemetson on 1/21/12.
//  Copyright (c) 2012 Codeprogrammers for Gonzaga University. All rights reserved.
//

#import "PointXY.h"

@implementation PointXY

@synthesize x, y;

-(void) setPointX:(double) newX
{
    self.x = newX;
}

-(void) setPointY:(double) newY
{
    self.y = newY;
}

-(void) setPointX: (double) newX andPointY: (double) newY
{
    self.x = newX;
    self.y = newY;
}


@end
