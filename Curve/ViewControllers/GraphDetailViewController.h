//
//  GraphDetailViewController.h
//  Curve
//
//  Created by Bradley C. on 1/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GraphDetailViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>
{
    NSMutableArray *myArray;
    NSMutableArray *arrayColors;
}

@property (nonatomic, retain) NSMutableArray *myArray;
@end
