//
//  curveMath.h
//  Curve
//
//  Created by Bradley Clemetson + Bradley Clemetson on 12/10/11.
//  Copyright (c) 2011 Codeprogrammers for Gonzaga University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface curveMath : NSObject
{
    NSString *curveName;
    
    NSString *function;

    NSMutableArray *dataPoints;
    
    double lowX;
    double lowY;
    double highX;
    double highY;
    
    double leftx;
    double lefty;
    double rightx;
    double righty;
    
    BOOL isNew;
}

@property (nonatomic, retain) NSString *curveName;
@property (nonatomic, retain) NSString *function;


@property (nonatomic, strong) NSMutableArray *dataPoints;

@property (nonatomic) double lowX;
@property (nonatomic) double lowY;
@property (nonatomic) double highX;
@property (nonatomic) double highY;

@property (nonatomic) BOOL isNew;

@property (nonatomic) double leftx;
@property (nonatomic) double lefty;
@property (nonatomic) double rightx;
@property (nonatomic) double righty;

-(void)fitCurve;
-(curveMath *) initWithName: (NSString *) newName;
-(curveMath *) initWithName: (NSString *) newName 
                withXPoints: (NSMutableArray *) newX 
             andwithYPoints: (NSMutableArray *) newY;
-(curveMath *) initWithName: (NSString *) newName 
                   andPoints: (NSMutableArray *) newPoints;

- (void)addPointX:(double) newX andPointY:(double) newY;
- (void)deletewithPointX: (double) targetX;
- (void)deletePointXYatIndex: (NSUInteger) targetIndex;
- (void)sort;

@end
