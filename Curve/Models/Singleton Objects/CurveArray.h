//
//  CurveArray.h
//  Curve
//
//  Created by Bradley Clemetson on 1/14/12.
//  Copyright (c) 2012 Codeprogrammers for Gonzaga University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CurveArray : NSObject
{
    NSMutableArray *curveListObjects;
}

@property (nonatomic, retain) NSMutableArray *curveListObjects;

+ (CurveArray *)shared;

@end
