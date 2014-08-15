#import "Make.h"
#import <OpenGLES/ES1/gl.h>

#import "UIScrollViewSubclass.h"

@interface Make (){
//    static float arrowWidth = ;   // fix this, put make it static
    CGRect frequencySliderRect;
    int numPages;
}
@end

@implementation Make

#define arrowWidth self.frame.size.width*.175

-(void) setup{
    
    float margin = self.view.bounds.size.width*.1;
    float pageW = self.view.bounds.size.width-margin*2;
    float panelW = pageW * .9;
    float controlsW = pageW * .7;
    
    numPages = 4;

//    UIScrollViewSubclass *_scrollView = [[UIScrollViewSubclass alloc] initWithFrame:CGRectMake(margin,
//                                                                                               self.view.bounds.size.height*.75,
//                                                                                               pageW,
//                                                                                               self.view.bounds.size.height*.25)];
    UIScrollViewSubclass *_scrollView = [[UIScrollViewSubclass alloc] initWithFrame:CGRectMake(0,
                                                                                               self.view.bounds.size.height*.75,
                                                                                               self.view.bounds.size.width,
                                                                                               self.view.bounds.size.height*.25)];
    frequencySliderRect = CGRectMake(0,
                                     self.view.bounds.size.height*.75,
                                     self.view.bounds.size.width,
                                     self.view.bounds.size.height*.25);
    
    
//    [_scrollView setDelegate:self];
    [_scrollView setBackgroundColor:[UIColor clearColor]];
    [_scrollView setContentSize:CGSizeMake(pageW * numPages,
                                           self.view.bounds.size.height*.25)];
    [_scrollView setShowsHorizontalScrollIndicator:NO];
    [_scrollView setShowsVerticalScrollIndicator:NO];
    [_scrollView setClipsToBounds:NO];
//    _scrollView.delaysContentTouches = NO;
//    [_scrollView setPagingEnabled:YES];
//    [_scrollView setUserInteractionEnabled:NO];
//    [_scrollView setGestureRecognizers:nil];
//    [self.view addSubview:_scrollView];
    
    
//    [_scrollView setHidden:YES];
//    HitTestView *hitTestView = [[HitTestView alloc] initWithFrame:CGRectMake(0,
//                                                                             self.view.bounds.size.height*.75,
//                                                                             self.view.bounds.size.width,
//                                                                             self.view.bounds.size.height*.25) View:_scrollView];
//    [self.view addSubview:hitTestView];
    

    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, arrowWidth*1.25)];
    [_titleLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:self.frame.size.width*.1]];
    [_titleLabel setNumberOfLines:0];
    [_titleLabel setTextAlignment:NSTextAlignmentCenter];
    [_titleLabel setTextColor:[UIColor whiteColor]];
    [_titleLabel setText:@"SCENE 1"];
//    [_titleLabel sizeToFit];
    [self.view addSubview:_titleLabel];
    
    _button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button1 setFrame:CGRectMake(0, self.frame.size.height-arrowWidth*2, arrowWidth*.75, arrowWidth*1.5)];
    [[_button1 titleLabel] setFont:[UIFont fontWithName:@"Montserrat-Regular" size:self.frame.size.width*.125]];
    [[_button1 titleLabel] setTextAlignment:NSTextAlignmentCenter];
    [_button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_button1 setTitle:@"◀︎" forState:UIControlStateNormal];
    [_button1 setBackgroundColor:[UIColor blackColor]];
    [_button1 addTarget:self action:@selector(button1Press:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_button1];
    
    _button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button2 setFrame:CGRectMake(self.frame.size.width-arrowWidth*.75, self.frame.size.height-arrowWidth*2, arrowWidth*.75, arrowWidth*1.5)];
    [[_button2 titleLabel] setFont:[UIFont fontWithName:@"Montserrat-Regular" size:self.frame.size.width*.125]];
    [[_button2 titleLabel] setTextAlignment:NSTextAlignmentCenter];
    [_button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_button2 setTitle:@"▶︎" forState:UIControlStateNormal];
    [_button2 setBackgroundColor:[UIColor blackColor]];
    [_button2 addTarget:self action:@selector(button2Press:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_button2];
    
//    self.elements = [NSMutableArray array];
//    [self.elements addObjectsFromArray:@[_button1, _button2]];
    
    // FREQUENCY SLIDER
//    (self.frame.size.width*.5, arrowWidth*1.25, self.frame.size.width*4/6., 4)
    
    _numberLabels = [[NSMutableArray alloc] init];
    for(int i = 0; i < 9; i++){
        UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.frame.size.width)/12.*(i+1.5), self.frame.size.height-arrowWidth, (self.frame.size.width)/12., (self.frame.size.width)/12.)];
        [numberLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:self.frame.size.width*.1]];
        [numberLabel setTextAlignment:NSTextAlignmentCenter];
        [numberLabel setHidden:NO];
        [numberLabel setText:[NSString stringWithFormat:@"%d",i+1]];
        [numberLabel setTextColor:[UIColor blackColor]];
        [_numberLabels addObject:numberLabel];
        [self.view addSubview:numberLabel];
//        [self.elements addObject:numberLabel];
    }
    
    
    [_scrollView setNoTouchRects:@[[NSValue valueWithCGRect:frequencySliderRect]]];

//    for(int i = 0; i < [_scrollView gestureRecognizers].count; i++){
//        UIGestureRecognizer *g = [[_scrollView gestureRecognizers] objectAtIndex:i];
//        [g setDelegate:self];
//    }

}

-(void) button1Press:(UIButton*)sender{
    if(_page-1 >= 0)
        _page--;
}

-(void) button2Press:(UIButton*)sender{
    if(_page+1 < numPages)
        _page++;
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"touches began");
}
-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    for(UITouch *touch in touches){
        if(CGRectContainsPoint(frequencySliderRect, [touch locationInView:self.view])) {
            float freq = ([touch locationInView:self.view].x-(self.frame.size.width)/12.*1.5) / ((self.frame.size.width)/12.);
            if(freq < 0) freq = 0;
            if(freq > 8) freq = 8;
            [self setRadioBarPosition:freq];
        }
    }
}
-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    for(UITouch *touch in touches){
        if(CGRectContainsPoint(frequencySliderRect, [touch locationInView:self.view])){
            int freq = ([touch locationInView:self.view].x-(self.frame.size.width)/12.*1.5) / ((self.frame.size.width)/12.) ;
            if(freq < 0) freq = 0;
            if(freq > 8) freq = 8;
            [self setRadioBarPosition:freq];
            [_delegate frequencySliderChanged:freq+1];
//            animationNewGeodesic = [[Animation alloc] initOnStage:self Start:_elapsedSeconds End:_elapsedSeconds+.5];
        }
    }
}

//-(BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
//       shouldReceiveTouch:(UITouch *)touch{
//    
//}

//-(void) hideElements{
//    for(int i = 0; i < [self.elements count]; i++)
//        [self.elements[i] setHidden:YES];
//}

-(void) customDraw{
    glDisable(GL_LIGHTING);
    
    glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
    // navigation bar side arrow boxes
    [self drawRect:CGRectMake(arrowWidth*.5+5, self.frame.size.height-(arrowWidth*.5)-5, arrowWidth, arrowWidth)];
    [self drawRect:CGRectMake(self.frame.size.width-(arrowWidth*.5)-5, self.frame.size.height-(arrowWidth*.5)-5, arrowWidth, arrowWidth)];
    glColor4f(0.0f, 0.0f, 0.0f, 1.0f);
    // navigation bar plus and minus signs
//    [self drawRect:CGRectMake(arrowWidth*.5+5, self.frame.size.height-(arrowWidth*.5)-5, arrowWidth*.5, 5)];
//    [self drawRect:CGRectMake(self.frame.size.width-(arrowWidth*.5)-5, self.frame.size.height-(arrowWidth*.5)-5, 5, arrowWidth*.5)];
//    [self drawRect:CGRectMake(self.frame.size.width-(arrowWidth*.5)-5, self.frame.size.height-(arrowWidth*.5)-5, arrowWidth*.5, 5)];
    
    glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
//    if(*_scene == 1)
        [self drawRect:CGRectMake(self.frame.size.width*.5, arrowWidth, self.frame.size.width, arrowWidth*2)];
//    if(*_scene == 2)
//        [self drawRect:CGRectMake(self.frame.size.width*.5, arrowWidth*.5, self.frame.size.width, arrowWidth)];
//    if(*_scene == 4)
//        [self drawRect:CGRectMake(self.frame.size.width*.5, arrowWidth*1.5, self.frame.size.width, arrowWidth*3)];
    
    glColor4f(0.0f, 0.0f, 0.0f, 1.0f);
//    if(*_scene == 1){
        [self drawRect:CGRectMake(self.frame.size.width*.5, arrowWidth*1.25, self.frame.size.width*4/6., 4)];
        for(int i = 0; i < 9; i++)
            [self drawRect:CGRectMake((self.frame.size.width)/12.*(i+2), arrowWidth*1.25, 1, arrowWidth*.33)];
        [self drawRect:CGRectMake((self.frame.size.width)/12.*(_radioBarPosition+2), arrowWidth*1.25, 20, 20) WithRotation:45];
//    }
    glEnable(GL_LIGHTING);
}


@end