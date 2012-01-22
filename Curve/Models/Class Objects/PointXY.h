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
    double pointX;
    double pointY;
}

@property (nonatomic) double pointX;
@property (nonatomic) double pointY;

- (void) setPointX: (double) newX;
- (bool) isValidPoint: (id) possiblePoint;

- (void) setPointY: (double) newY;
- (void) setPointX: (double) newX andPointY: (double) newY;

@end
