#import "Controls.h"
#import "HitTestView.h"

typedef enum{
    hotspotBackArrow,
    hotspotForwardArrow,
    hotspotControls
} HotspotID;


@implementation Controls

-(void) customDraw{
//    glColor4f(0.0f, 0.0f, 0.0f, 1.0f);
//    [self drawRect:CGRectMake(self.view.bounds.size.width*.5, self.view.bounds.size.height*.066, self.view.bounds.size.width, self.view.bounds.size.height*.133)];
}

-(void) setup{
    
    float margin = self.view.bounds.size.width*.1;
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(margin, self.view.bounds.size.height*.75, self.view.bounds.size.width-margin*2, self.view.bounds.size.height*.25)];
    [_scrollView setBackgroundColor:[UIColor clearColor]];
    [_scrollView setContentSize:CGSizeMake(self.view.bounds.size.width*6, self.view.bounds.size.height*.25)];
    [_scrollView setShowsHorizontalScrollIndicator:NO];
    [_scrollView setShowsVerticalScrollIndicator:NO];
    [_scrollView setClipsToBounds:NO];
    _scrollView.delaysContentTouches = NO;
    [_scrollView setPagingEnabled:YES];
    HitTestView *hitTestView = [[HitTestView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height*.75, self.view.bounds.size.width, self.view.bounds.size.height*.25) View:_scrollView];
    [self.view addSubview:hitTestView];
    [self.view addSubview:_scrollView];
    
    // background views
    float w2 = _scrollView.bounds.size.width * .9;
    for(int i = 0; i < 6; i++){
        UIView *back = [[UIView alloc] initWithFrame:CGRectMake(_scrollView.bounds.size.width * i + _scrollView.bounds.size.width*.5 - w2*.5, 0, w2, _scrollView.bounds.size.height*.9)];
        [back setBackgroundColor:[UIColor blackColor]];
        [_scrollView addSubview:back];
    }
    
    // PAGE 1, slider

    float w = _scrollView.bounds.size.width * .7;
//    _slider = [[UISlider alloc] initWithFrame:CGRectMake(self.view.bounds.size.width*.5 - w*.5, self.view.bounds.size.height*.9, w, self.view.bounds.size.height*.2)];
    _slider = [[UISlider alloc] initWithFrame:CGRectMake(_scrollView.bounds.size.width*.5 - w*.5, self.view.bounds.size.height*.1, w, self.view.bounds.size.height*.1)];
    [_slider setMinimumTrackTintColor:[UIColor lightGrayColor]];
    [_slider setMaximumTrackTintColor:[UIColor lightGrayColor]];
    [_slider addTarget:self action:@selector(sliderChanged) forControlEvents:UIControlEventTouchUpInside];
    [_slider addTarget:self action:@selector(sliderChanged) forControlEvents:UIControlEventTouchUpOutside];
    [_scrollView addSubview:_slider];
        
    // numbers count
    for(int i = 0; i < 9; i++){
        UILabel *number = [[UILabel alloc] initWithFrame:CGRectMake(_scrollView.bounds.size.width*.5 - w*.5 + w/9.0*i, self.view.bounds.size.height*.025, w/9.0, self.view.bounds.size.height*.085)];
        [number setText:[NSString stringWithFormat:@"%d",i+1]];
        [number setTextColor:[UIColor whiteColor]];
        [number setFont:[UIFont fontWithName:@"Montserrat-Regular" size:28]];
        [number setTextAlignment:NSTextAlignmentCenter];
        [_scrollView addSubview:number];
    }
    
}

-(void) sliderChanged{
    int segments = 8;  // points on the line is segments+1
    int closest = floorf(_slider.value * segments + .5);
    [_slider setValue:(1.0f/segments)*closest animated:YES];
    [_delegate frequencySliderChanged:closest+1];
}

@end
