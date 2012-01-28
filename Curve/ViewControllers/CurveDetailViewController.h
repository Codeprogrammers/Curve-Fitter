//
//  CurveDetailViewController.h
//  Curve
//
//  Created by Bradley Clemetson on 12/11/11.
//  Copyright (c) 2011 Codeprogrammers for Gonzaga University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "curveMath.h"
#import "CorePlot-CocoaTouch.h"

@interface CurveDetailViewController : UIViewController <UISplitViewControllerDelegate>
{
    
    UIView *graphView;
    
    curveMath *selectedCurve;
    CPTXYGraph *graph;
    
    NSMutableArray *dataForPlot;
    UIBarButtonItem *curveFunction;
    UIBarButtonItem *graphDetailCurl;
}

@property (nonatomic, retain) IBOutlet UIView *graphView;
@property (nonatomic, strong) curveMath *selectedCurve;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *graphDetailCurl;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *curveFunction;
@property(readwrite, retain, nonatomic) NSMutableArray *dataForPlot;

- (CPTXYGraph *) initCurveGraph;
- (void) loadCurvePoints;
- (void) refreshCurve;
- (IBAction)showGraphDetails:(id)sender;

@end
