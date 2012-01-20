//
//  EditCurveViewController.h
//  Curve
//
//  Created by Bradley Clemetson on 12/15/11.
//  Copyright (c) 2011 Codeprogrammers for Gonzaga University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "curveMath.h"
#import "CurveArray.h"
#import "PointCell.h"

@class PointCell;

@interface EditCurveViewController : UIViewController
{
    CurveArray *curveLists;
    
    UINavigationBar *modalNavigationBar;
    UIBarButtonItem *cancelButton;
    UIBarButtonItem *doneButton;
    
    UITextField *curveName;
    
    UITableView *curveXYPoints;
    PointCell *pointCell;
    
    curveMath *currentCurve;
    BOOL editingCurve;
}

@property (nonatomic, retain) IBOutlet UINavigationBar *modalNavigationBar;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *cancelButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *doneButton;

@property (nonatomic, retain) IBOutlet UITableView *curveXYPoints;
@property (nonatomic, retain) IBOutlet UITextField *curveName;
@property (nonatomic, retain) IBOutlet PointCell *pointCell;

@property (nonatomic) BOOL editingCurve;
@property (nonatomic, retain) curveMath *currentCurve;

- (IBAction)cancelPressed:(id)sender;
- (IBAction)donePressed:(id)sender;
- (IBAction)shouldAllowDone:(id)sender;
- (IBAction)updateTitle:(id)sender;
- (IBAction)curveNameDidFinishedit:(id)sender;

- (IBAction)updatePoint:(id)sender;

@end