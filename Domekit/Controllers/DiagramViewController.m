//
//  DiagramViewController.m
//  Domekit
//
//  Created by Robby on 5/10/15.
//  Copyright (c) 2015 Robby. All rights reserved.
//

#import "DiagramViewController.h"
#import "EquidistantAzimuthView.h"
#import "MaterialsListTableViewCell.h"
#import "AppDelegate.h"
#import <CoreText/CoreText.h>
#import <MessageUI/MessageUI.h>

#define NAVBAR_HEIGHT 88
#define EXT_NAVBAR_HEIGHT 57


@interface DiagramViewController ()
{
    int polaris, octantis;
    NSArray *colorTable;
    EquidistantAzimuthView *equidistantAzimuthView;
    UIButton *arrowButton;
    BOOL tableUp;
    UIScrollView *scrollView;  // attach this scrollview's guesture recognizer to
    UIBarButtonItem *shareButton;
}

@end

@implementation DiagramViewController

-(void) setGeodesicModel:(GeodesicModel *)geodesicModel{
    _geodesicModel = geodesicModel;
    [equidistantAzimuthView setGeodesic:_geodesicModel];
}

-(void) setMaterials:(NSDictionary *)materials{
    _materials = materials;
//    NSLog(@"MATERIALS INVOLVED:\n%@",materials);
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    colorTable = [[NSArray alloc] initWithObjects:[UIColor colorWithRed:0.8 green:0 blue:0 alpha:1.0],  //red
                  [UIColor colorWithRed:0 green:0 blue:1.0 alpha:1.0],  //blue
                  [UIColor colorWithRed:0 green:0.8 blue:0 alpha:1.0],  //green
                  [UIColor colorWithRed:0.53 green:0 blue:0.8 alpha:1.0],  //purple
                  [UIColor colorWithRed:1 green:0.66 blue:0 alpha:1.0],   //orange
                  [UIColor colorWithRed:0 green:0.575 blue:0.7 alpha:1.0], //teal
                  [UIColor colorWithRed:0.88 green:0.88 blue:0 alpha:1.0],  //gold
                  [UIColor colorWithRed:0.86 green:0 blue:0.73 alpha:1.0],  //pink
                  [UIColor colorWithRed:0.66 green:.88 blue:0 alpha:1.0],  // lime green
                  [UIColor colorWithRed:0.62 green:.42 blue:0.27 alpha:1.0],  // brown
                  [UIColor colorWithRed:0.6 green:0.725 blue:0.95 alpha:1.0],  // light blue
                  [UIColor colorWithRed:1 green:0.81 blue:0.51 alpha:1.0],  // salmon
                  [UIColor colorWithRed:.89 green:0.6 blue:0.97 alpha:1.0],  // light purple
                  [UIColor colorWithRed:.5 green:1 blue:1 alpha:1.0],  // cyan
                  [UIColor colorWithRed:.75 green:.75 blue:.15 alpha:1.0],  // dull yellow
                  [UIColor colorWithRed:0 green:.63 blue:.42 alpha:1.0],  // sea green
                  [UIColor colorWithRed:0.26 green:0.19 blue:0.73 alpha:1.0],  // purple-blue
                  [UIColor colorWithRed:0.2 green:0.47 blue:0.16 alpha:1.0],  // forest green
                  [UIColor colorWithRed:0.19 green:0.37 blue:0.52 alpha:1.0],  // gray blue
                  [UIColor colorWithRed:0.66 green:0.66 blue:0.66 alpha:1.0], nil];  //gray
    
    
    CGSize size = [[UIScreen mainScreen] bounds].size;
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
#define ZOOM 4
    
    equidistantAzimuthView = [[EquidistantAzimuthView alloc] initWithFrame:CGRectMake(0, 0, size.width * ZOOM, (size.width + EXT_NAVBAR_HEIGHT) * ZOOM)];
    [equidistantAzimuthView setColorTable:colorTable];
    [equidistantAzimuthView setGeodesic:_geodesicModel];
    [equidistantAzimuthView setBackgroundColor:[UIColor whiteColor]];
    
    UIScrollView *diagramScrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.width + EXT_NAVBAR_HEIGHT)];
    [diagramScrollview setContentSize:CGSizeMake(size.width * ZOOM, (size.width + EXT_NAVBAR_HEIGHT) * ZOOM)];
//    [diagramScrollview setZoomScale:.5];
    [diagramScrollview setDelegate:self];
    [diagramScrollview setMaximumZoomScale:1.0];
    [diagramScrollview setMinimumZoomScale:.25];
    [diagramScrollview setZoomScale:0.25];
    [diagramScrollview addSubview:equidistantAzimuthView];
    [self.view addSubview:diagramScrollview];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, size.width + EXT_NAVBAR_HEIGHT, size.width, size.height - size.width - EXT_NAVBAR_HEIGHT - 44) style:UITableViewStylePlain];
//    [self setTableView:tableView];
    [self.view addSubview:self.tableView];
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
//    [self.tableView setBackgroundColor:[UIColor clearColor]];
    
    shareButton = [[UIBarButtonItem alloc] initWithTitle:@"Share" style:UIBarButtonItemStylePlain target:self action:@selector(shareButtonPressed)];
    self.navigationItem.rightBarButtonItem = shareButton;
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backButtonPressed)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, EXT_NAVBAR_HEIGHT, [[UIScreen mainScreen] bounds].size.width, self.tableView.frame.size.height + 44)];
    [scrollView setDelegate:self];
    [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width, [[UIScreen mainScreen] bounds].size.height)];
    [self.view addSubview:scrollView];
    [scrollView setHidden:YES];
    [self.view bringSubviewToFront:scrollView];
}

-(void) backButtonPressed{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) shareButtonPressed{
//    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Print", @"Email", nil];
//    [actionSheet showInView:self.view];
    
    NSArray *arrayPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [arrayPaths objectAtIndex:0];
    NSString* pathAndFileName = [path stringByAppendingPathComponent:@"diagram.pdf"];
    [self drawPDF:pathAndFileName];
//    NSLog(@"PDF Created at %@",pathAndFileName);

    NSData *pdfData = [NSData dataWithContentsOfFile:pathAndFileName];
    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:@[pdfData] applicationActivities:nil];
    [controller.popoverPresentationController setBarButtonItem:shareButton];
    if(controller)
        [self presentViewController:controller animated:YES completion:nil];
}

#pragma mark- TABLE VIEW

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0)
        return [[_materials objectForKey:@"lines"] count];
    else if(section == 1)
        return [[_materials objectForKey:@"points"] count];
    else if(section == 2)
        return 2;
    return 0;
}
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section == 0)
        return @"Struts";
    else if(section == 1)
        return @"Joints";
    else if(section == 2)
        return @"Parts List";
    else
        return @"";
}

-(UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section == 1)
        return nil;
    UIView *view = [[UIView alloc] init];
    [view setBackgroundColor:[UIColor colorWithWhite:0.97 alpha:1.0]];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(13, 4, tableView.frame.size.width, 20)];
    [label setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:17]];
    [label setTextColor:[UIColor blackColor]];
    [view addSubview:label];

    if(section == 0)
        [label setText:@"Struts"];
    else {
        if(section == 1)
            [label setText:@"Joints"];
        else if(section == 2)
            [label setText:@"Statistics"];
        return view;
    }
    
    [view addGestureRecognizer:scrollView.panGestureRecognizer];

    UIButton *up = [[UIButton alloc] initWithFrame:CGRectMake(tableView.frame.size.width-44, 0, 44, 30)];
    [[up titleLabel] setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:17]];
    [up setTitle:@"▲" forState:UIControlStateNormal];
    [[up layer] setAnchorPoint:CGPointMake(0.5, 0.5)];
    [up setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [view addSubview:up];
    arrowButton = up;

    if(tableUp){
        [up addTarget:self action:@selector(animateTableDown) forControlEvents:UIControlEventTouchUpInside];
        [[arrowButton layer] setAffineTransform:CGAffineTransformMakeRotation(M_PI)];
    }
    else{
        [up addTarget:self action:@selector(animateTableUp) forControlEvents:UIControlEventTouchUpInside];
        [[arrowButton layer] setAffineTransform:CGAffineTransformMakeRotation(0)];
    }

    return view;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MaterialsListTableViewCell *cell = [[MaterialsListTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"MaterialsCell"];
    if(indexPath.section == 0){
        [cell setIndented:YES];
        NSArray *lines = [_materials objectForKey:@"lines"];
        if(indexPath.row < [lines count]){
            // format strut length
            float length = [[lines objectAtIndex:indexPath.row] floatValue] * _scale;
            
            [[cell textLabel] setText:[((AppDelegate*)[[UIApplication sharedApplication] delegate]) unitifyNumber:length]];
            
            UIView *colorBar = [[UIView alloc] initWithFrame:CGRectMake(10, 18, 64, 8)];
            if(indexPath.row < [colorTable count])
                [colorBar setBackgroundColor:[colorTable objectAtIndex:indexPath.row]];
            else
                [colorBar setBackgroundColor:[UIColor grayColor]];
            [cell addSubview:colorBar];
            
            NSArray *lineQuantities = [_materials objectForKey:@"lineQuantities"];
            if([lineQuantities count]){
                [[cell detailTextLabel] setText:[NSString stringWithFormat:@"× %@",[lineQuantities objectAtIndex:indexPath.row]]];
            }
        }
    }
    else if(indexPath.section == 1){
        [cell.textLabel setText:@""];
        NSArray *points = [_materials objectForKey:@"points"];
        [cell.detailTextLabel setText:[NSString stringWithFormat:@"x %@",[points objectAtIndex:indexPath.row]]];
    }
    else if(indexPath.section == 2){
        if(indexPath.row == 0){
            [cell.textLabel setText:@"Height"];
            [cell.detailTextLabel setText:[((AppDelegate*)[[UIApplication sharedApplication] delegate]) unitifyNumber:[_geodesicModel domeHeight] * (_scale * 2)]];
        }
        if(indexPath.row == 1){
            [cell.textLabel setText:@"Floor Diameter"];
            [cell.detailTextLabel setText:[((AppDelegate*)[[UIApplication sharedApplication] delegate]) unitifyNumber:[_geodesicModel domeFloorDiameter] * (_scale * 2)]];
        }
    }
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


#pragma mark- SCROLL VIEW DELEGATE

-(UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return equidistantAzimuthView;
}
-(void) scrollViewDidScroll:(UIScrollView *)view{
    if([view isEqual:scrollView]){
        CGSize size = scrollView.frame.size;
        CGRect start = CGRectMake(0, size.width + EXT_NAVBAR_HEIGHT, size.width, size.height - size.width - EXT_NAVBAR_HEIGHT - 44);
        [self.tableView setFrame:CGRectMake(0, start.origin.y - scrollView.contentOffset.y, [[UIScreen mainScreen ] bounds].size.width, start.origin.y + start.size.height + scrollView.contentOffset.y)];
        
        if(scrollView.contentOffset.y < 0){
            if(tableUp){
                tableUp = false;
                [arrowButton removeTarget:self action:@selector(animateTableDown) forControlEvents:UIControlEventTouchUpInside];
                [arrowButton addTarget:self action:@selector(animateTableUp) forControlEvents:UIControlEventTouchUpInside];
                [UIView beginAnimations:@"triangleFix" context:nil];
                [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
                [UIView setAnimationDuration:0.2];
                [UIView setAnimationDelegate:nil];
                [[arrowButton layer] setAffineTransform:CGAffineTransformMakeRotation(0)];
                [UIView commitAnimations];
            }
        }
        else if(scrollView.contentOffset.y > start.origin.y){
            if(!tableUp){
                tableUp = true;
                [arrowButton removeTarget:self action:@selector(animateTableUp) forControlEvents:UIControlEventTouchUpInside];
                [arrowButton addTarget:self action:@selector(animateTableDown) forControlEvents:UIControlEventTouchUpInside];
                [UIView beginAnimations:@"triangleFix" context:nil];
                [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
                [UIView setAnimationDuration:0.2];
                [UIView setAnimationDelegate:nil];
                [[arrowButton layer] setAffineTransform:CGAffineTransformMakeRotation(M_PI)];
                [UIView commitAnimations];
            }
        }
    }
}

#pragma mark- ANIMATIONS

-(void) animateTableUp{
    CGSize size = [[UIScreen mainScreen] bounds].size;
    CGRect start = CGRectMake(0, size.width + EXT_NAVBAR_HEIGHT, size.width, size.height - size.width - EXT_NAVBAR_HEIGHT - 44);
    [UIView beginAnimations:@"up" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationDelegate:self];
    [scrollView setContentOffset:start.origin];
//    [self.tableView setFrame:CGRectMake(0, 0, size.width, size.height - 44)];
    [[arrowButton layer] setAffineTransform:CGAffineTransformMakeRotation(M_PI)];
    [UIView commitAnimations];
}

-(void) animateTableDown{
    [UIView beginAnimations:@"down" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.25];
    [UIView setAnimationDelegate:self];
    [[arrowButton layer] setAffineTransform:CGAffineTransformMakeRotation(0)];
    [scrollView setContentOffset:CGPointMake(0, 0)];
//    [self.tableView setFrame:CGRectMake(0, size.width + EXT_NAVBAR_HEIGHT, size.width, size.height - size.width - EXT_NAVBAR_HEIGHT - 44)];
    [UIView commitAnimations];
}

-(void) animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if ([anim.description isEqualToString:@"up"]){
        tableUp = true;
        [arrowButton removeTarget:self action:@selector(animateTableUp) forControlEvents:UIControlEventTouchUpInside];
        [arrowButton addTarget:self action:@selector(animateTableDown) forControlEvents:UIControlEventTouchUpInside];
    }
    if ([anim.description isEqualToString:@"down"]){
        tableUp = false;
        [arrowButton removeTarget:self action:@selector(animateTableDown) forControlEvents:UIControlEventTouchUpInside];
        [arrowButton addTarget:self action:@selector(animateTableUp) forControlEvents:UIControlEventTouchUpInside];
    }
}

#pragma mark- PDF

-(void)drawPDF:(NSString*)fileName
{
    // Create the PDF context using the default page size of 612 x 792.
    UIGraphicsBeginPDFContextToFile(fileName, CGRectZero, nil);
    // Mark the beginning of a new page.
    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 612, 792), nil);
    
//    [self drawText:@"Hello World" inFrame:CGRectMake(0, 0, 300, 50)];
    
//    [self drawLabels];
//    [self drawLogo];
//    UIImage* logo = [UIImage imageNamed:@"logo.png"];
//    [self drawImage:logo inRect:CGRectMake(15, 15, 80, 80)];

    
    [equidistantAzimuthView setLineWidth:defaultLineWidth / 4.0];
    [equidistantAzimuthView drawProjectionWithContext:UIGraphicsGetCurrentContext() inRect:CGRectMake(15, 792*.5 - (612-30)*.5, 612-30, 612-30)];
    [equidistantAzimuthView setLineWidth:defaultLineWidth];

    //next page
    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 612, 792), nil);
    
    int xOrigin = 110;
    int yOrigin = 80;
    
    int rowHeight = 28;
    int columnWidth = 150;
    
    int titleY = 50;
    
    NSArray *lines = [_materials objectForKey:@"lines"];
    if([lines count] < 15){
        yOrigin = 140;
        titleY = 75;
    }
    
    [self drawText:self.title fontSize:24 inFrame:CGRectMake(200, titleY, 300, 30)];
    [self drawPartsTableDataAt:CGPointMake(xOrigin, yOrigin) withRowHeight:rowHeight andColumnWidth:columnWidth];

    // Close the PDF context and write the contents out.
    UIGraphicsEndPDFContext();
}


-(void)drawPartsTableDataAt:(CGPoint)origin
              withRowHeight:(int)rowHeight
             andColumnWidth:(int)columnWidth  {
    int padding = 10;
    
    NSMutableArray *col1 = [NSMutableArray array];
    NSArray *lines = [_materials objectForKey:@"lines"];
    for(int i = 0; i < [lines count]; i++){
        float length = [[lines objectAtIndex:i] floatValue] * _scale;
        [col1 addObject:[((AppDelegate*)[[UIApplication sharedApplication] delegate]) unitifyNumber:length]];
    }
    NSMutableArray *col2 = [NSMutableArray array];
    NSArray *lineQuantities = [_materials objectForKey:@"lineQuantities"];
    for(int i = 0; i < [lineQuantities count]; i++){
        [col2 addObject:[NSString stringWithFormat:@"× %@",[lineQuantities objectAtIndex:i]]];
    }
    NSMutableArray *col0 = [NSMutableArray array];
    for(int i = 0; i < [lines count]; i++)
        [col0 addObject:@""];
    
    
    [self drawText:@"Struts" fontSize:24 inFrame:CGRectMake(origin.x - columnWidth*.1, origin.y, columnWidth, rowHeight)];
    
    NSArray* strutInfo = [NSArray arrayWithObjects:col0, col1, col2, nil];
    
    for(int i = 0; i < [strutInfo count]; i++){
        NSArray* infoToDraw = [strutInfo objectAtIndex:i];
        for (int j = 0; j < [lines count]; j++){
            int newOriginX = origin.x + ((i)*columnWidth);
            int newOriginY = origin.y + ((j+1)*rowHeight);
            CGRect frame;
            if(i == 1)
                frame = CGRectMake(newOriginX + padding - columnWidth*.2, newOriginY + padding, columnWidth + columnWidth*2, rowHeight);
            else
                frame = CGRectMake(newOriginX + padding, newOriginY + padding, columnWidth, rowHeight);
            [self drawText:[infoToDraw objectAtIndex:j] fontSize:24 inFrame:frame];
        }
    }
    for(int i = 0; i < [lines count]; i++){
        int newOriginX = origin.x + ((0)*columnWidth);
        int newOriginY = origin.y + ((i)*rowHeight) + rowHeight * .6;
        [self drawLineFromPoint:CGPointMake(newOriginX + padding, newOriginY + padding) toPoint:CGPointMake(newOriginX + padding + columnWidth*.66, newOriginY + padding) lineWidth:10.0 withColor:[colorTable objectAtIndex:i]];
    }
    
    
    float moreMargin = columnWidth * .5;

    float nextY = origin.y + (([lines count]+1)*rowHeight) + rowHeight;
//    CGRect frame = CGRectMake(newOriginX + padding, newOriginY + padding, columnWidth, rowHeight);
    [self drawText:@"Joints" fontSize:24 inFrame:CGRectMake(origin.x - columnWidth*.1, nextY, columnWidth, rowHeight)];
    NSArray *points = [_materials objectForKey:@"points"];
    [self drawText:[NSString stringWithFormat:@"x %@",[points objectAtIndex:0]] fontSize:24 inFrame:CGRectMake(origin.x + columnWidth*2.1, nextY, columnWidth, rowHeight)];
    
    [self drawText:[NSString stringWithFormat:@"Dome Height: %@",[((AppDelegate*)[[UIApplication sharedApplication] delegate]) unitifyNumber:[_geodesicModel domeHeight] * (_scale * 2)]] fontSize:20 inFrame:CGRectMake(origin.x + moreMargin, nextY + rowHeight * 2, columnWidth*3, rowHeight)];
    
    [self drawText:[NSString stringWithFormat:@"Floor Diameter: %@",[((AppDelegate*)[[UIApplication sharedApplication] delegate]) unitifyNumber:[_geodesicModel domeFloorDiameter] * (_scale * 2)]] fontSize:20 inFrame:CGRectMake(origin.x + moreMargin, nextY + rowHeight * 3, columnWidth*3, rowHeight)];
    
    
    // draw table lines
    for (int i = 0; i <= [lines count]; i++) {
        int newOrigin = origin.y + (rowHeight*i) + rowHeight * .4;
        CGPoint from = CGPointMake(origin.x, newOrigin);
        CGPoint to = CGPointMake(origin.x + (2.5*columnWidth), newOrigin);
        [self drawLineFromPoint:from toPoint:to lineWidth:.5 withColor:[UIColor colorWithWhite:.92 alpha:1.0]];
    }
}

-(void)drawLineFromPoint:(CGPoint)from toPoint:(CGPoint)to lineWidth:(CGFloat)lineWidth withColor:(UIColor*)color{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, lineWidth);
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextMoveToPoint(context, from.x, from.y);
    CGContextAddLineToPoint(context, to.x, to.y);
    CGContextStrokePath(context);
    CGColorSpaceRelease(colorspace);
}


-(void)drawImage:(UIImage*)image inRect:(CGRect)rect{
    [image drawInRect:rect];
}

-(void)drawText:(NSString*)textToDraw fontSize:(CGFloat)fontSize inFrame:(CGRect)frameRect{
    if(![textToDraw length])
        return;
    //    CFStringRef stringRef = (__bridge CFStringRef)textToDraw;
    //    NSString* familyName = @"HelveticaNeue-Medium";
    
    CFMutableAttributedStringRef attrStr = CFAttributedStringCreateMutable(kCFAllocatorDefault, 0);
    CFAttributedStringReplaceString (attrStr, CFRangeMake(0, 0), (CFStringRef) textToDraw);
    
    CTFontRef font = CTFontCreateWithName(CFSTR("HelveticaNeue-Medium"), fontSize, NULL);
    
    //    create paragraph style and assign text alignment to it
    //    CTTextAlignment alignment = kCTJustifiedTextAlignment;
    //    CTParagraphStyleSetting _settings[] = {    {kCTParagraphStyleSpecifierAlignment, sizeof(alignment), &alignment} };
    //    CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(_settings, sizeof(_settings) / sizeof(_settings[0]));
    
    //    set paragraph style attribute
    //    CFAttributedStringSetAttribute(attrStr, CFRangeMake(0, CFAttributedStringGetLength(attrStr)), kCTParagraphStyleAttributeName, paragraphStyle);
    
    //    set font attribute
    
    CFAttributedStringSetAttribute(attrStr, CFRangeMake(0, CFAttributedStringGetLength(attrStr)), kCTFontAttributeName, font);
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(attrStr);
    CGMutablePathRef framePath = CGPathCreateMutable();
    CGPathAddRect(framePath, NULL, frameRect);
    
    // Get the frame that will do the rendering.
    CFRange currentRange = CFRangeMake(0, 0);
    CTFrameRef frameRef = CTFramesetterCreateFrame(framesetter, currentRange, framePath, NULL);
    CGPathRelease(framePath);
    
    // Get the graphics context.
    CGContextRef    currentContext = UIGraphicsGetCurrentContext();
    
    // Put the text matrix into a known state. This ensures
    // that no old scaling factors are left in place.
    CGContextSetTextMatrix(currentContext, CGAffineTransformIdentity);
    
    // Core Text draws from the bottom-left corner up, so flip
    // the current transform prior to drawing.
    CGContextTranslateCTM(currentContext, 0, frameRect.origin.y*2);
    CGContextScaleCTM(currentContext, 1.0, -1.0);
    
    // Draw the frame.
    CTFrameDraw(frameRef, currentContext);
    
    CGContextScaleCTM(currentContext, 1.0, -1.0);
    CGContextTranslateCTM(currentContext, 0, (-1)*frameRect.origin.y*2);
}

-(void)drawLabels{
    NSArray* objects = [[NSBundle mainBundle] loadNibNamed:@"PDFNibView" owner:nil options:nil];
    UIView* mainView = [objects objectAtIndex:0];
    for (UIView* view in [mainView subviews]) {
        if([view isKindOfClass:[UILabel class]]){
            UILabel* label = (UILabel*)view;
            [self drawText:label.text fontSize:20 inFrame:label.frame];
        }
    }
}

-(void)drawLogo{
    NSArray* objects = [[NSBundle mainBundle] loadNibNamed:@"PDFNibView" owner:nil options:nil];
    UIView* mainView = [objects objectAtIndex:0];
    for (UIView* view in [mainView subviews]) {
        if([view isKindOfClass:[UIImageView class]]){
            UIImage* logo = [UIImage imageNamed:@"dome-logo.png"];
            [self drawImage:logo inRect:view.frame];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
