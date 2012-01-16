//
//  curveMath.h
//  Curve
//
//  Created by Bradley Clemetson on 12/10/11.
//  Copyright (c) 2011 Codeprogrammers for Gonzaga University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface curveMath : NSObject
{
    NSString *curveName;
    
    NSString *function;
    NSMutableArray *xData;
    NSMutableArray *yData;
    NSNumber *lowX;
    NSNumber *lowY;
    NSNumber *highX;
    NSNumber *highY;
    
    double leftx;
    double lefty;
    double rightx;
    double righty;
}

@property (nonatomic, retain) NSString *curveName;
@property (nonatomic, retain) NSString *function;

@property (copy,readwrite) NSArray *xData;
@property (copy,readwrite) NSArray *yData;

@property (nonatomic, retain) NSNumber *lowX;
@property (nonatomic, retain) NSNumber *lowY;
@property (nonatomic, retain) NSNumber *highX;
@property (nonatomic, retain) NSNumber *highY;

@property (nonatomic) double leftx;
@property (nonatomic) double lefty;
@property (nonatomic) double rightx;
@property (nonatomic) double righty;

-(void)fitCurve;
-(curveMath *) initWithName: (NSString *) newName;
-(curveMath *) initWithName: (NSString *) newName 
                withXPoints: (NSArray *) newX 
             andwithYPoints: (NSArray *) newY;


- (void)addPointX:(NSNumber *) newX andPointY:(NSNumber *) newY;
@end
