//
//  PointXY.h
//  Curve
//
//  Created by Nicholas Interrante on 1/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PointXY : NSObject
{
    double x;
    double y;
}

@property (nonatomic) double x;
@property (nonatomic) double y;

-(void) setX:(double) newX;
-(void) setY:(double) newY;
-(void) addPointX:(double) newX Y:(double) newY;

@end
