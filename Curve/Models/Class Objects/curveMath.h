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

@property (nonatomic, strong) NSMutableArray *xData;
@property (nonatomic, strong) NSMutableArray *yData;

@property (nonatomic, strong) NSNumber *lowX;
@property (nonatomic, strong) NSNumber *lowY;
@property (nonatomic, strong) NSNumber *highX;
@property (nonatomic, strong) NSNumber *highY;

@property (nonatomic) double leftx;
@property (nonatomic) double lefty;
@property (nonatomic) double rightx;
@property (nonatomic) double righty;

-(void)fitCurve;
-(curveMath *) initWithName: (NSString *) newName;
-(curveMath *) initWithName: (NSString *) newName 
                withXPoints: (NSMutableArray *) newX 
             andwithYPoints: (NSMutableArray *) newY;


- (void)addPointX:(NSNumber *) newX andPointY:(NSNumber *) newY;
@end
