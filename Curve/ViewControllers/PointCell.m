//
//  PointCell.m
//  Curve
//
//  Created by Bradley Clemetson on 1/3/12.
//  Copyright (c) 2012 CodeProgrammers for Gonzaga University. All rights reserved.
//

#import "PointCell.h"

@implementation PointCell
@synthesize xPoint, yPoint;

/*
- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) 
    {

    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
*/

-(id)init
{
    self = [super init];
    if(self)
    {
        xPoint = [[UITextField alloc] init];
        yPoint = [[UITextField alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [xPoint release];
    [yPoint release];
    [super dealloc];
}

@end
