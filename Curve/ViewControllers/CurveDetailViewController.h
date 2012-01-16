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
    curveMath *selectedCurve;
    CPTXYGraph *graph;
    
    NSMutableArray *dataForPlot;
}

@property (nonatomic, strong) curveMath *selectedCurve;
@property(readwrite, retain, nonatomic) NSMutableArray *dataForPlot;

- (CPTXYGraph *) initCurveGraph;
- (void) loadCurvePoints;
- (void) refreshCurve;

@end