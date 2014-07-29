#import "Make.h"
#import "HitTestView.h"
#import "GLScrollView.h"
#import "UIViewSubclass.h"

typedef enum{
    hotspotBackArrow,
    hotspotForwardArrow,
    hotspotControls
} HotspotID;

@interface Make (){
    CADisplayLink *displayLink;
}

@end

@implementation Make

-(void)startDisplayLinkIfNeeded{
    if(!displayLink){
        displayLink = [CADisplayLink displayLinkWithTarget:_delegate selector:@selector(auxiliaryDraw)];
        [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
}

-(void) stopDisplayLink{
    if(displayLink)
        [displayLink invalidate];
    displayLink = nil;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    _scrollView.contentOffset = scrollView.contentOffset;
}

-(void) scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self startDisplayLinkIfNeeded];
}
-(void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if(!decelerate){
        [self stopDisplayLink];
    }
}
-(void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self stopDisplayLink];
}

-(void) customDraw{
//    glColor4f(0.0f, 0.0f, 0.0f, 1.0f);
//    [self drawRect:CGRectMake(self.view.bounds.size.width*.5, self.view.bounds.size.height*.066, self.view.bounds.size.width, self.view.bounds.size.height*.133)];
    glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
}


-(void) setup{
    
    float margin = self.view.bounds.size.width*.1;
    float pageW = self.view.bounds.size.width-margin*2;
    float panelW = pageW * .9;
    float controlsW = pageW * .7;
    
    int numPages = 4;
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(margin,
                                                                 self.view.bounds.size.height*.75,
                                                                 pageW,
                                                                 self.view.bounds.size.height*.25)];
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
    [_scrollView setGestureRecognizers:nil];
    
    
//    [_scrollView setHidden:YES];
    
//    HitTestView *hitTestView = [[HitTestView alloc] initWithFrame:CGRectMake(0,
//                                                                             self.view.bounds.size.height*.75,
//                                                                             self.view.bounds.size.width,
//                                                                             self.view.bounds.size.height*.25) View:_scrollView];
//    [self.view addSubview:hitTestView];
    

    [self.view addSubview:_scrollView];
    
    // background views
    for(int i = 0; i < numPages; i++){
        UIView *back = [[UIView alloc] initWithFrame:CGRectMake(pageW * (i+.5) - panelW * .5,
                                                                0,
                                                                panelW,
                                                                _scrollView.bounds.size.height*.9)];
        [back setBackgroundColor:[UIColor blackColor]];
        [_scrollView addSubview:back];
    }
    // GRIPS
    for(int i = 1; i < numPages; i++){
        UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(pageW * i - margin*.25,
                                                                     _scrollView.bounds.size.height* .5 - margin*.5*1.618,
                                                                     margin*.5,
                                                                     margin*1.618)];
        [separator setBackgroundColor:[UIColor blackColor]];
        [_scrollView addSubview:separator];
    }
    
    // PAGE 1, polyhedra
    UIButton *octaButton = [[UIButton alloc] initWithFrame:CGRectMake(pageW * .5 - panelW * .5,
                                                                       0,
                                                                       panelW*.5,
                                                                       _scrollView.bounds.size.height*.9)];
    [octaButton setBackgroundColor:[UIColor clearColor]];
    UIButton *icosaButton = [[UIButton alloc] initWithFrame:CGRectMake(pageW * .5,
                                                                       0,
                                                                       panelW*.5,
                                                                       _scrollView.bounds.size.height*.9)];
    [icosaButton setBackgroundColor:[UIColor clearColor]];
    
    [icosaButton setTitle:@"5" forState:UIControlStateNormal];
    [octaButton setTitle:@"4" forState:UIControlStateNormal];
    [icosaButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [octaButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [[icosaButton titleLabel] setFont:[UIFont systemFontOfSize:40]];
    [[octaButton titleLabel] setFont:[UIFont systemFontOfSize:40]];

    [icosaButton addTarget:_delegate action:@selector(icosahedronButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [octaButton addTarget:_delegate action:@selector(octahedronButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:octaButton];
    [_scrollView addSubview:icosaButton];

    
    // PAGE 2, slider
    _slider = [[UISlider alloc] initWithFrame:CGRectMake(pageW*1.5 - controlsW*.5,
                                                         self.view.bounds.size.height*.1,
                                                         controlsW,
                                                         self.view.bounds.size.height*.1)];
    [_slider setMinimumTrackTintColor:[UIColor lightGrayColor]];
    [_slider setMaximumTrackTintColor:[UIColor lightGrayColor]];
    [_slider addTarget:self action:@selector(sliderChanged) forControlEvents:UIControlEventTouchUpInside];
    [_slider addTarget:self action:@selector(sliderChanged) forControlEvents:UIControlEventTouchUpOutside];
    [_scrollView addSubview:_slider];
    [_slider setThumbTintColor:[UIColor colorWithRed:.3f green:.3f blue:1.0f alpha:1.0f]];
    // numbers count
    for(int i = 0; i < 9; i++){
        UILabel *number = [[UILabel alloc] initWithFrame:CGRectMake(pageW*1.5 - controlsW*.5 + controlsW/9.0*i,
                                                                    self.view.bounds.size.height*.025,
                                                                    controlsW/9.0,
                                                                    self.view.bounds.size.height*.085)];
        [number setText:[NSString stringWithFormat:@"%d",i+1]];
        [number setTextColor:[UIColor whiteColor]];
        [number setFont:[UIFont fontWithName:@"Montserrat-Regular" size:28]];
        [number setTextAlignment:NSTextAlignmentCenter];
        [_scrollView addSubview:number];
    }
    
    // PAGE 3
    UILabel *sliceLabel = [[UILabel alloc] initWithFrame:CGRectMake(pageW * 2.5 - controlsW*.5, self.view.bounds.size.height*.05, controlsW, self.view.bounds.size.height*.1)];
    [sliceLabel setText:@"slice"];
    [sliceLabel setTextAlignment:NSTextAlignmentCenter];
    [sliceLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:28]];
    [sliceLabel setTextColor:[UIColor whiteColor]];
    [_scrollView addSubview:sliceLabel];
    

    // PAGE 4
    UILabel *sizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(pageW * 3.5 - controlsW*.5, self.view.bounds.size.height*.05, controlsW, self.view.bounds.size.height*.1)];
    [sizeLabel setText:@"scale it up"];
    [sizeLabel setTextAlignment:NSTextAlignmentCenter];
    [sizeLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:28]];
    [sizeLabel setTextColor:[UIColor whiteColor]];
    [_scrollView addSubview:sizeLabel];
    
    
    
    /// CONTROL LAYER
    
    GLScrollView *controlView = [[GLScrollView alloc] initWithFrame:CGRectMake(margin,
                                                                               self.view.bounds.size.height*.75,
                                                                               pageW,
                                                                               self.view.bounds.size.height*.25)];//[_scrollView frame]];
    [controlView setBackgroundColor:[UIColor clearColor]];
    [controlView setContentSize:CGSizeMake(pageW * numPages,
                                           self.view.bounds.size.height*.25)];
//    [controlView setShowsHorizontalScrollIndicator:NO];
//    [controlView setShowsVerticalScrollIndicator:NO];
//    controlView.delaysContentTouches = NO;
    // FUUUUUU
    // here's the problem
    // all of this would work, the dummy view forwarding touches to controlView (a scrollview) except this delaysContentTouches does not recognize to delay for objects which are not inside of itself. since it is a dummy scrollview. the other stuff is contained inside the real scrollview
    
    [controlView setPagingEnabled:YES];
    [controlView setDelegate:self];
    [controlView setHidden:YES];
    [self.view addSubview:controlView];
    
    UIViewSubclass *dummyView = [[UIViewSubclass alloc] initWithFrame:CGRectMake(0,
                                                                 self.view.bounds.size.height*.75,
                                                                 self.view.bounds.size.width,
                                                                 self.view.bounds.size.height*.25)];
    [dummyView addGestureRecognizer:controlView.panGestureRecognizer];
    [self.view addSubview:dummyView];
}

-(void) sliderChanged{
    int segments = 8;  // points on the line is segments+1
    int closest = floorf(_slider.value * segments + .5);
    [_slider setValue:(1.0f/segments)*closest animated:YES];
    [_delegate frequencySliderChanged:closest+1];
}

@end
