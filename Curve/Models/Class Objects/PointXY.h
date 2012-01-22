//
//  PointXY.h
//  Curve
//
//  Created by Nicholas Interrante + Bradley Clemetson on 1/21/12.
//  Copyright (c) 2012 Codeprogrammers for Gonzaga University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PointXY : NSObject
{
    double x;
    double y;
}

@property (nonatomic) double x;
@property (nonatomic) double y;

-(void) setPointX: (double) newX;
-(void) setPointY: (double) newY;
-(void) setPointX: (double) newX andPointY: (double) newY;

@end
