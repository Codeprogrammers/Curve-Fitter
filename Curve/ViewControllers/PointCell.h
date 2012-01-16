//
//  PointCell.h
//  Curve
//
//  Created by Bradley Clemetson on 1/3/12.
//  Copyright (c) 2012 CodeProgrammers for Gonzaga University. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PointCell : UITableViewCell
{
    UITextField *xPoint;
    UITextField *yPoint;
}

@property (nonatomic, retain) IBOutlet UITextField *xPoint;
@property (nonatomic, retain) IBOutlet UITextField *yPoint;



@end
