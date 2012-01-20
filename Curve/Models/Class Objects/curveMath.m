//
//  curveMath.m
//  Curve
//
//  Created by Bradley Clemetson on 12/10/11.
//  Copyright (c) 2011 Codeprogrammers for Gonzaga University. All rights reserved.
//

#import "curveMath.h"

@implementation curveMath

@synthesize curveName;
@synthesize function;
@synthesize xData;
@synthesize yData;
@synthesize leftx, lefty, rightx, righty;
@synthesize lowX, lowY, highX, highY;

-(curveMath *) initWithName: (NSString *) newName
{
    self.curveName = newName;
    return self;
}

-(curveMath *) initWithName: (NSString *) newName 
                withXPoints: (NSMutableArray *) newX 
             andwithYPoints: (NSMutableArray *) newY
{
    self.curveName = newName;
    self.xData = newX;
    self.yData = newY;
    [self fitCurve];
    
    return self;
}

-(void)fitCurve
{
    int numpoints;
    double sumxy;
    double sumx;
    double sumy;
    double sumx2;
    double m;
    double b;
    
    numpoints = xData.count;
    sumxy = 0;
    for(NSUInteger i = 0; i < numpoints; i++) {
        sumxy = sumxy + ((int)[xData objectAtIndex:i] * (int)[yData objectAtIndex:i]);
    }
    sumx = 0;
    for(NSUInteger i = 0; i < numpoints; i++) {
        sumx = sumx + (int)[xData objectAtIndex:i];
    }
    sumy = 0;
    for(NSUInteger i = 0; i < numpoints; i++) {
        sumy = sumy + (int)[yData objectAtIndex:i];
    }
    sumx2 = 0;
    for(NSUInteger i = 0; i < numpoints; i++) {
        sumx2 = sumx2 + ((int)[xData objectAtIndex:i]*(int)[xData objectAtIndex:i]);
    }
    
    m = ((numpoints * sumxy) - (sumx * sumy))/ ((numpoints * sumx2) - (sumx * sumx));
    b = (sumy - (m * sumx)) / numpoints;
    
    /*
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:100];
    for ( NSUInteger i=0; i < 200; i++ ) {
        [arr insertObject:[NSDecimalNumber numberWithUnsignedInteger:i] atIndex:i];
    }
    self.xCurve = arr;
    
    arr = [NSMutableArray arrayWithCapacity:200];
    for ( NSUInteger i=0; i < 200; i++ ) {
        [arr insertObject:[NSDecimalNumber numberWithDouble:m * i + b] atIndex:i];
    }
    self.yCurve = arr;
    */
    int width = 320;
    int height = 480;
    
    if (b>height){
        leftx = (height - b)/m;
        lefty = height;
    }
    else if (b<0){
        leftx = (b * -1)/m;
        lefty = 0;
    }
    else{
        leftx = 0;
        lefty = b;
    }
    
    if ((m*width + b) > height){
        rightx = (width - b)/m;
        righty = height;
    }
    else if ((m*width + b)<0){
        rightx = (b * -1)/m;
        righty = 0;
    }
    else{
        rightx = width;
        righty = (m * width) + b;
    }

    
    function = [NSString stringWithFormat:@"f(x) = %fx + %f",m,b];
}

- (void)addPointX:(NSNumber *) newX andPointY:(NSNumber *) newY
{
    //print out using nslog new x and y, high x and y, and low x and y:
    NSLog(@"###NEW_PRINT BEFORE###");      //new print marker..
    //x:
    NSLog(@"New  X at %@: ", newX); //newX..
    NSLog(@"High X at %@: ", highX);//highX..
    NSLog(@"Low  X at %@: ", lowX); //lowX..
    //y:
    NSLog(@"New  Y at %@: ", newY); //newY..
    NSLog(@"High Y at %@: ", highY);//highY..
    NSLog(@"Low  Y at %@: ", lowY); //lowY..
    
    //1) get current highest point (x and y) and current lowest point (x and y); after input of each point
    //2) insert new points in their proper place in the array (sort by lowest to highest)

    
    if([self.xData count] == 0 && [self.yData count] == 0)
    {
        NSLog(@"!!!NO Data in Array yet!!!");
        lowX = newX;
        highX = newX;
        lowY = newY;
        highY = newY;
    } 
    else 
    {//entry of at least 2nd point and on:
        //x:
        if( newX < self.lowX )//if lowest..
        {
            NSLog(@"####NEW LOW X####");
            self.lowX = newX;
        } 
        else
        if( newX > self.highX )//if highest..
        {
            NSLog(@"####New HIGH X####");
            self.highX = newX;
        } 
        else
        if( newX == self.highX || newX == lowX )//if equal..
        {
            //if newX is equal to highX or lowX not a 1-to-1 function; throw error.
            NSLog(@"ERROR THROW, NOT ONE TO ONE");
        } 
        else//if in the middle..
        {
            //if newX is just in the middle somewhere; do nothing.
            NSLog(@"Simply add points");
        }
        //y:
        if( newY < self.lowY )//if lowest..
        {
            NSLog(@"###New Lowest Y###");
            self.lowY = newY;
        } 
        else
        if( newY > self.highY )//if highest..
        {
            NSLog(@"###NEW Highest Y###");
            self.highY = newY;
        } 
        else
        if( newY == self.highY || newY == self.lowY )//if equal..
        {
            //if newY is equal to highY or lowY not a 1-to-1 function; throw error.
        } 
        else//if in the middle..
        {
            //if newY is just in the middle somewhere; do nothing.
        }
    }
    
    //print out using nslog new x and y, high x and y, and low x and y:
    NSLog(@"###NEW_PRINT AFTER###");      //new print marker..
    //x:
    NSLog(@"New  X at %@: ", newX); //newX..
    NSLog(@"High X at %@: ", self.highX);//highX..
    NSLog(@"Low  X at %@: ", self.lowX); //lowX..
    //y:
    NSLog(@"New  Y at %@: ", newY); //newY..
    NSLog(@"High Y at %@: ", self.highY);//highY..
    NSLog(@"Low  Y at %@: ", self.lowY); //lowY..
    
    
    [self.xData addObject: newX];
    [self.yData addObject: newY];
}

@end
