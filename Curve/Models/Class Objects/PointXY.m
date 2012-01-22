//
//  PointXY.m
//  Curve
//
//  Created by Nicholas Interrante + Bradley Clemetson on 1/21/12.
//  Copyright (c) 2012 Codeprogrammers for Gonzaga University. All rights reserved.
//

#import "PointXY.h"

@implementation PointXY

@synthesize pointX, pointY;


-(void) setPointX: (double) newX andPointY: (double) newY
{
    self.pointX = newX;
    self.pointY = newY;
}

-(void) setPointX:(double) newX
{
    pointX = newX;
}

-(void) setPointY:(double) newY
{
    pointY = newY;
}




@end
