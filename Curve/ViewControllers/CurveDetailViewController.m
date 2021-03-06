//
//  CurveDetailViewController.m
//  Curve
//
//  Created by Bradley Clemetson on 12/11/11.
//  Copyright (c) 2011 Codeprogrammers for Gonzaga University. All rights reserved.
//

#import "CurveDetailViewController.h"
#import "PointXY.h"

@implementation CurveDetailViewController

@synthesize graphView;
@synthesize graphDetailCurl, curveFunction;
@synthesize selectedCurve;
@synthesize dataForPlot;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self refreshCurveFunction];
    [self initCurveGraph];
    
    

    
    // Do any additional setup after loading the view from its nib.

        
}

- (void) viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleBlackTranslucent];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
}

- (void) viewWillDisappear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleDefault];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

- (IBAction)focusGraph:(id)sender
{
    NSLog(@"Refocus Graph Pressed");
    [self changePlotRange];
}

-(void)changePlotRange 
{    
    // Setup plot space
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
    if(((int) [selectedCurve.dataPoints count]) > 1)
    {

    plotSpace.allowsUserInteraction = YES;
    
        plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat((selectedCurve.lowX - (selectedCurve.lowX * 2))) length:CPTDecimalFromFloat((selectedCurve.highX - selectedCurve.lowX) * 1.2)];
        
        plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat((selectedCurve.lowY - (selectedCurve.lowY * 2))) length:CPTDecimalFromFloat((selectedCurve.highY - selectedCurve.lowY) * 1.2)];
    }
    else
    {
        plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat((selectedCurve.lowX) / 2) length:CPTDecimalFromFloat((selectedCurve.lowX) * 2)];
        
        plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat((selectedCurve.lowY) / 2) length:CPTDecimalFromFloat((selectedCurve.lowX) * 2)];
    }
     
    
}



-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
    return [dataForPlot count];
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index 
{
    NSNumber *num = [[dataForPlot objectAtIndex:index] valueForKey:(fieldEnum == CPTScatterPlotFieldX ? @"x" : @"y")];
	// Green plot gets shifted above the blue
	if ([(NSString *)plot.identifier isEqualToString:@"Green Plot"])
	{
		if ( fieldEnum == CPTScatterPlotFieldY ) 
			num = [NSNumber numberWithDouble:[num doubleValue] + 1.0];
	}
    return num;
}

- (void)splitViewController:(UISplitViewController *)svc 
     willHideViewController:(UIViewController *)aViewController 
          withBarButtonItem:(UIBarButtonItem *)barButtonItem 
       forPopoverController:(UIPopoverController *)pc
{
    barButtonItem.title = aViewController.title;
    self.navigationItem.leftBarButtonItem = barButtonItem;
}

- (void)splitViewController:(UISplitViewController *)svc 
     willShowViewController:(UIViewController *)aViewController 
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    self.navigationItem.leftBarButtonItem = nil;
}

- (CPTXYGraph *) initCurveGraph;
{
    // Create graph from theme
    graph = [[CPTXYGraph alloc] initWithFrame:graphView.frame];
    
    if(currentGraphTheme == nil)
        currentGraphTheme = [CPTTheme themeNamed:kCPTDarkGradientTheme];
    
    [graph applyTheme:currentGraphTheme];
	CPTGraphHostingView *hostingView = (CPTGraphHostingView *)self.graphView;
    hostingView.collapsesLayers = NO; // Setting to YES reduces GPU memory usage, but can slow drawing/scrolling
    hostingView.hostedGraph = graph;
	
    graph.paddingLeft = 0.0;
	graph.paddingTop = 0.0;
	graph.paddingRight = 0.0;
	graph.paddingBottom = 0.0;
    
    // Setup plot space
    [self changePlotRange];
    
    
    // Axes
	CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
    CPTXYAxis *x = axisSet.xAxis;
    x.labelingPolicy = CPTAxisLabelingPolicyAutomatic;
    
    //Origin
    x.orthogonalCoordinateDecimal = CPTDecimalFromString(@"0");

    
    CPTXYAxis *y = axisSet.yAxis;
    y.labelingPolicy = CPTAxisLabelingPolicyAutomatic;
    
    //Origin
    y.orthogonalCoordinateDecimal = CPTDecimalFromString(@"0");
    
	// Create a blue plot area
	CPTScatterPlot *boundLinePlot = [[[CPTScatterPlot alloc] init] autorelease];
    CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
    lineStyle.miterLimit = 1.0f;
	lineStyle.lineWidth = 0.0f;
    
    if(currentPointColor == nil)
        lineStyle.lineColor = [CPTColor blueColor];
    else
        lineStyle.lineColor = currentPointColor;
    
    boundLinePlot.dataLineStyle = lineStyle;
    boundLinePlot.identifier = @"Blue Plot";
    boundLinePlot.dataSource = self;
	[graph addPlot:boundLinePlot];
    
	// Add plot symbols
	CPTMutableLineStyle *symbolLineStyle = [CPTMutableLineStyle lineStyle];
	symbolLineStyle.lineColor = [CPTColor blackColor];
	CPTPlotSymbol *plotSymbol = [CPTPlotSymbol ellipsePlotSymbol];
	plotSymbol.fill = [CPTFill fillWithColor:[CPTColor blueColor]];
	plotSymbol.lineStyle = symbolLineStyle;
    plotSymbol.size = CGSizeMake(10.0, 10.0);
    boundLinePlot.plotSymbol = plotSymbol;
    
    // Create a green plot area
	CPTScatterPlot *dataSourceLinePlot = [[[CPTScatterPlot alloc] init] autorelease];
    lineStyle = [CPTMutableLineStyle lineStyle];
    lineStyle.lineWidth = 3.f;
    
    if(currentLineColor == nil)
        lineStyle.lineColor = [CPTColor greenColor];
	else
        lineStyle.lineColor = currentLineColor;
    
    lineStyle.dashPattern = [NSArray arrayWithObjects:[NSNumber numberWithFloat:5.0f], [NSNumber numberWithFloat:5.0f], nil];
    dataSourceLinePlot.dataLineStyle = lineStyle;
    dataSourceLinePlot.identifier = @"Green Plot";
    dataSourceLinePlot.dataSource = self;
    
	// Animate in the new plot, as an example
	dataSourceLinePlot.opacity = 0.0f;
    [graph addPlot:dataSourceLinePlot];
	
	CABasicAnimation *fadeInAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
	fadeInAnimation.duration = 1.0f;
	fadeInAnimation.removedOnCompletion = NO;
	fadeInAnimation.fillMode = kCAFillModeForwards;
	fadeInAnimation.toValue = [NSNumber numberWithFloat:1.0];
	[dataSourceLinePlot addAnimation:fadeInAnimation forKey:@"animateOpacity"];
	
    [self loadCurvePoints];
    
#ifdef PERFORMANCE_TEST
    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(changePlotRange) userInfo:nil repeats:YES];
#endif
    [graph autorelease];
    return graph;
}

- (void) loadCurvePoints
{
    // Add some initial data
	NSMutableArray *contentArray = [NSMutableArray arrayWithCapacity:100];
	NSUInteger i;
	for ( i = 0; i < [selectedCurve.dataPoints count]; i++ ) {
        
		//id x = [NSNumber numberWithFloat:1+i*0.05];
        id x = [NSNumber numberWithFloat: [[selectedCurve.dataPoints objectAtIndex:i] pointX]];
		//id y = [NSNumber numberWithFloat:1.2*rand()/(float)RAND_MAX + 1.2]; 
        id y = [NSNumber numberWithFloat: [[selectedCurve.dataPoints objectAtIndex:i] pointY]];
		[contentArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:x, @"x", y, @"y", nil]];
	}
	self.dataForPlot = contentArray;
}

- (void) refreshCurveFunction
{
    if(selectedCurve.function == nil)
        self.curveFunction.title = @"f(X)";
    else
        self.curveFunction.title = selectedCurve.function;
}

- (void) refreshCurve
{
    [self refreshCurveFunction];
    [self changePlotRange];
    [self loadCurvePoints];
    [graph reloadData];
}

- (IBAction)showGraphDetails:(id)sender
{
    NSLog(@"Curl Graph Details Pressed!");
    GraphDetailViewController *graphDetails = [[GraphDetailViewController alloc] init];
    
    graphDetails.modalTransitionStyle = UIModalTransitionStylePartialCurl;
    [self presentModalViewController:graphDetails animated:YES];
    
    [graphDetails release];
}

- (void) changeGraphThemeTo: (CPTTheme *) newTheme
{
    currentGraphTheme = newTheme;
    [graph applyTheme:currentGraphTheme];
}
@end
