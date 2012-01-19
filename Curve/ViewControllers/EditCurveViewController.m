//
//  EditCurveViewController.m
//  Curve
//
//  Created by Bradley Clemetson on 12/15/11.
//  Copyright (c) 2011 Codeprogrammers for Gonzaga University. All rights reserved.
//

#import "EditCurveViewController.h"

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;

@implementation EditCurveViewController

@synthesize modalNavigationBar, cancelButton, doneButton;
@synthesize curveName, curveXYPoints, pointCell;
@synthesize currentCurve;
@synthesize editingCurve;

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
    // Do any additional setup after loading the view from its nib.
    curveLists = [CurveArray shared];
    
    if(editingCurve == NO)
    {
        modalNavigationBar.topItem.title = @"New Curve";
        currentCurve = [[curveMath alloc] init];
        doneButton.enabled = NO;
        self.curveXYPoints.frame = CGRectMake(0, 45, 320, 416); 
    }
    else
    {
        modalNavigationBar.topItem.title = currentCurve.curveName;
        curveName.text = currentCurve.curveName;
        modalNavigationBar.hidden = YES;
        self.curveXYPoints.frame = CGRectMake(0, 0, 320, 460); 
    }
}

- (IBAction)cancelPressed:(id)sender
{
    NSLog(@"Cancel Pressed");
    [super dismissModalViewControllerAnimated:YES];
}

- (IBAction)donePressed:(id)sender
{
    NSLog(@"Done Pressed");
    if(editingCurve == NO)
    {
        [curveLists.curveListObjects addObject: currentCurve];
    }
    [super dismissModalViewControllerAnimated:YES];
    [self release];
}

- (IBAction)shouldAllowDone:(id)sender
{
    if([curveName.text length] <= 0)
        doneButton.enabled = NO;
    else
        doneButton.enabled = YES;
}
- (IBAction)updateTitle:(id)sender
{
    if([curveName.text length] <= 0)
        modalNavigationBar.topItem.title = @"New Curve";
    else
    {
        modalNavigationBar.topItem.title = curveName.text;
    }
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
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (BOOL)textView:(UITextView *)txtView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text 
    {
    if( [text rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet]].location == NSNotFound )
    {
        return YES;
    }
    
    [txtView resignFirstResponder];
    return NO;
}



//TableView Specific information
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (editingCurve == NO) 
        return 1;
    else
        return [currentCurve.xData count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
    static NSString *CellIdentifier = @"Cell";
    
    NSLog(@"Creating Cell Row: %i", indexPath.row + 1);
    PointCell *cell = (PointCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        [[NSBundle mainBundle] loadNibNamed:@"PointCell" owner:self options:nil];
        cell = pointCell;
        self.pointCell = nil;
    }
    if(indexPath.row == ([self.currentCurve.xData count]))
    {

    }
    else
    if (self.editingCurve == YES)
    {
            cell.xPoint.text = [NSString stringWithFormat:@"%@", 
                                [self.currentCurve.xData objectAtIndex: [indexPath row]]
                                ];
            cell.yPoint.text =  [NSString stringWithFormat:@"%@", 
                                 [self.currentCurve.yData objectAtIndex: [indexPath row]]
                                 ];
        
        cell.xPoint.tag = indexPath.row + 1;
        cell.yPoint.tag = indexPath.row + 1;
    }


    //These two line require iOS 4.2
    cell.xPoint.keyboardType = UIKeyboardTypeDecimalPad;
    cell.yPoint.keyboardType = UIKeyboardTypeDecimalPad;
    
    return cell;
}

- (IBAction)curveNameDidFinishedit:(id)sender
{
    currentCurve.curveName = self.curveName.text;
}


- (IBAction)updatePoint:(id)sender
{
    
    NSLog(@"Point has been called");
    if([sender isKindOfClass:[UITextField class]])
    {
        NSNumberFormatter *string2NSNumber = [[NSNumberFormatter alloc] init];
        [string2NSNumber setFormatterBehavior: NSNumberFormatterBehavior10_4];
        [string2NSNumber setFormatterBehavior:NSNumberFormatterDecimalStyle];
        
        NSLog(@"The Sender of this object is a UITextFeild!!");
        //((UITextField *) sender).text = @"Hello WORLD!";
        NSLog(@"Text to insert: %@", ((UITextField *) sender).text);
        //[curveLists.curveListObjects replaceObjectAtIndex:((UITextField *) sender).tag withObject:((UITextField *) sender).text];
        [curveLists.curveListObjects replaceObjectAtIndex:((UITextField *) sender).tag withObject:[string2NSNumber numberFromString: ((UITextField *) sender).text]];
    }
}

#pragma mark -
#pragma mark UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return YES;
}




@end
