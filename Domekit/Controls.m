#import "Controls.h"


typedef enum{
    hotspotBackArrow,
    hotspotForwardArrow,
    hotspotControls
} HotspotID;


@implementation Controls

-(void) customDraw{
    glColor4f(0.0f, 0.0f, 0.0f, 0.3f);
    [self drawRect:CGRectMake(self.view.bounds.size.width*.5, self.view.bounds.size.height*.066, self.view.bounds.size.width, self.view.bounds.size.height*.133)];
}

-(void) setup{
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height*.85, self.view.bounds.size.width, self.view.bounds.size.height*.3)];
    [_scrollView setBackgroundColor:[UIColor darkGrayColor]];
    [_scrollView setContentSize:CGSizeMake(self.view.bounds.size.width*6, self.view.bounds.size.height*.3)];
    [self.view addSubview:_scrollView];
    
    _scrollView.delaysContentTouches = NO;

    float w = self.view.bounds.size.width * .7;
//    _slider = [[UISlider alloc] initWithFrame:CGRectMake(self.view.bounds.size.width*.5 - w*.5, self.view.bounds.size.height*.9, w, self.view.bounds.size.height*.2)];
    _slider = [[UISlider alloc] initWithFrame:CGRectMake(self.view.bounds.size.width*.5 - w*.5, 0, w, self.view.bounds.size.height*.2)];
    [_slider setMinimumTrackTintColor:[UIColor lightGrayColor]];
    [_slider setMaximumTrackTintColor:[UIColor lightGrayColor]];
    [_slider addTarget:self action:@selector(sliderChanged) forControlEvents:UIControlEventTouchUpInside];
    [_slider addTarget:self action:@selector(sliderChanged) forControlEvents:UIControlEventTouchUpOutside];

    [_scrollView setPagingEnabled:YES];
    [_scrollView addSubview:_slider];
}

-(void) sliderChanged{
    int segments = 8;  // points on the line is segments+1
    int closest = floorf(_slider.value * segments + .5);
    [_slider setValue:(1.0f/segments)*closest animated:YES];
    [_delegate frequencySliderChanged:closest+1];
}

@end
