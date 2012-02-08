//
//  curveMath.m
//  Curve
//
//  Created by Bradley Clemetson on 12/10/11.
//  Copyright (c) 2011 Codeprogrammers for Gonzaga University. All rights reserved.
//

#import "curveMath.h"
#import "PointXY.h"

@implementation curveMath

@synthesize curveName;
@synthesize function;
@synthesize dataPoints;
@synthesize leftx, lefty, rightx, righty;
@synthesize lowX, lowY, highX, highY;
@synthesize isNew;

-(id)init
{
    self = [super init];
    if(self)
    {
        dataPoints = [[NSMutableArray alloc] init];

        curveName = [[NSString alloc] init];
        function  = [[NSString alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [dataPoints release];

    [curveName release];
    [function release];
    [super dealloc];
}


-(curveMath *) initWithName: (NSString *) newName
{
    [self init];
    self.curveName = newName;
    self.isNew = TRUE;
    return self;
}

-(curveMath *) initWithName: (NSString *) newName 
                withXPoints: (NSMutableArray *) newXs 
             andwithYPoints: (NSMutableArray *) newYs
{
    [self init];
    self.curveName = newName;
    
    //Need a alternative to these
    //self.xData = newXs;
    //self.yData = newYs;
    
    //[self fitCurve];
    return self;
}

-(curveMath *) initWithName: (NSString *) newName 
                  andPoints: (NSMutableArray *) newPoints 
{
    [self init];
    self.curveName = newName;
    self.dataPoints = newPoints;
    
    //[self fitCurve];
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
    
    numpoints = dataPoints.count;
    sumxy = 0;
    for(NSUInteger i = 0; i < numpoints; i++) 
    {
        //sumxy = sumxy + ((int)[xData objectAtIndex:i] * (int)[yData objectAtIndex:i]);
        sumxy = sumxy + ((int) [[dataPoints objectAtIndex: i] pointX]) * ((int) [[dataPoints objectAtIndex: i] pointY]);
    }
    sumx = 0;
    for(NSUInteger i = 0; i < numpoints; i++) 
    {
        //sumx = sumx + (int)[xData objectAtIndex:i];
        sumx = sumx + ((int) [[dataPoints objectAtIndex:i] pointX]);
    }
    sumy = 0;
    for(NSUInteger i = 0; i < numpoints; i++) {
       //sumy = sumy + (int)[yData objectAtIndex:i];
        sumy = sumy + ((int) [[dataPoints objectAtIndex: i] pointY]);
    }
    sumx2 = 0;
    for(NSUInteger i = 0; i < numpoints; i++) {
        //sumx2 = sumx2 + ((int)[xData objectAtIndex:i]*(int)[xData objectAtIndex:i]);
        sumx2 = sumx2 + (((int) [[dataPoints objectAtIndex: i] pointX]) * ((int) [[dataPoints objectAtIndex: i] pointY]));
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

    
    self.function = [NSString stringWithFormat:@"f(x) = %fx + %f",m,b];
}


- (void)addPointX:(double) newX andPointY:(double) newY
{
    //print out using nslog new x and y, high x and y, and low x and y:
    NSLog(@"###NEW_PRINT BEFORE###");      //new print marker..
    //x:
    NSLog(@"New  X at %f: ", newX); //newX..
    NSLog(@"High X at %f: ", self.highX);//highX..
    NSLog(@"Low  X at %f: ", self.lowX); //lowX..
    //y:
    NSLog(@"New  Y at %f: ", newY); //newY..
    NSLog(@"High Y at %f: ", self.highY);//highY..
    NSLog(@"Low  Y at %f: ", self.lowY); //lowY..
    
    //1) get current highest point (x and y) and current lowest point (x and y); after input of each point
    //2) insert new points in their proper place in the array (sort by lowest to highest)
    
    
    if(self.isNew)
    {
        NSLog(@"!!!NO Data in Array yet!!!");
        self.lowX = newX;
        self.highX = newX;
        self.lowY = newY;
        self.highY = newY;
        self.isNew = FALSE;
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
    NSLog(@"New  X at %f: ", newX); //newX..
    NSLog(@"High X at %f: ", self.highX);//highX..
    NSLog(@"Low  X at %f: ", self.lowX); //lowX..
    //y:
    NSLog(@"New  Y at %f: ", newY); //newY..
    NSLog(@"High Y at %f: ", self.highY);//highY..
    NSLog(@"Low  Y at %f: ", self.lowY); //lowY..
    
    PointXY *newPoint = [[PointXY alloc] init];
    [newPoint setPointX: newX andPointY: newY];  //set x and y coordinates to a PointXY object..
    [dataPoints addObject:newPoint ];//add new PointXY object to point array..
    [newPoint release];
}

-(void)sort
{
/*    //Way #1:
    NSArray *sortedPoints = [dataPoints sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"pointX" ascending:YES selector:@selector(compare:)]]];//*/
    
    //Way #2: (block way):
    NSArray *sortedPoints = [dataPoints sortedArrayUsingComparator:^(id obj1, id obj2) {
        NSNumber *pointX1 = [NSNumber numberWithDouble:[obj1 pointX]];
        NSNumber *pointX2 = [NSNumber numberWithDouble:[obj2 pointX]];
        return [pointX1 compare: pointX2];
    }];

    self.dataPoints = [sortedPoints mutableCopy];
}

- (void)deletewithPointX: (double) targetX
{
    bool isFound = NO;
    int currentIndex = 0;
    
    for(; ([dataPoints count] > currentIndex) && !isFound ; currentIndex++)
    {
        NSLog(@"At Index: %i the object is: %f", currentIndex, [[dataPoints objectAtIndex:currentIndex] pointX]);
        if([[dataPoints objectAtIndex:currentIndex] pointX] == targetX)
        {
            isFound = YES;
            currentIndex --;
        }
    }
    if(isFound)
    {
        NSLog(@"!!!At Index: %i the object is: %f", currentIndex, [[dataPoints objectAtIndex:currentIndex] pointX]);
        [dataPoints removeObjectAtIndex: currentIndex];
        NSLog(@"Object at index %i deleted X Target %f", currentIndex, targetX );
    }
    else
    {
        NSLog(@"Nothing found to delete");
    }
    
}

- (void)deletePointXYatIndex: (NSUInteger) targetIndex
{
    [dataPoints removeObjectAtIndex:targetIndex];
}

@end