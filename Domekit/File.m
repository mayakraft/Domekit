#import "File.h"

@implementation File

-(void) setup{
    _make = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width*.1, self.view.bounds.size.height*.1, self.view.bounds.size.width*.8, self.view.bounds.size.height*.3)];
//    _load = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width*.1, self.view.bounds.size.height*.6, self.view.bounds.size.width*.8, self.view.bounds.size.height*.3)];
    
    [_make setBackgroundColor:[UIColor blackColor]];
    [[_make titleLabel] setFont:[UIFont fontWithName:@"Montserrat-Regular" size:36]];
    [_make setTitle:@"NEW\nDOME" forState:UIControlStateNormal];
    _make.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [[_make titleLabel] setLineBreakMode:NSLineBreakByWordWrapping];
    [[_make titleLabel] setTextAlignment:NSTextAlignmentCenter];
    [_make addTarget:_delegate action:@selector(makeNewDomePressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_make];

//    [_load setBackgroundColor:[UIColor blackColor]];
//    [[_load titleLabel] setFont:[UIFont fontWithName:@"Montserrat-Regular" size:28]];
//    [_load setTitle:@"LOAD\nSAVED\nDOME" forState:UIControlStateNormal];
//    _load.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
//    [[_load titleLabel] setLineBreakMode:NSLineBreakByWordWrapping];
//    [[_load titleLabel] setTextAlignment:NSTextAlignmentCenter];
//    [_load addTarget:_delegate action:@selector(loadDomePressed) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:_load];
    
    _savedDomesScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height*.5, self.view.bounds.size.width, self.view.bounds.size.height*.5)];
    [_savedDomesScrollView setContentSize:CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height*1.75)];
    [self.view addSubview:_savedDomesScrollView];
    
    for(int i = 0; i < 6; i++){
        UIButton *savedDome = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width*.1, i*self.view.bounds.size.height*.3, self.view.bounds.size.width*.8, self.view.bounds.size.height*.2)];
        [savedDome setBackgroundColor:[UIColor blackColor]];
        [[savedDome titleLabel] setFont:[UIFont fontWithName:@"Montserrat-Regular" size:36]];
        [savedDome setTitle:[NSString stringWithFormat:@"DOME %d",i] forState:UIControlStateNormal];
        savedDome.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [[savedDome titleLabel] setLineBreakMode:NSLineBreakByWordWrapping];
        [[savedDome titleLabel] setTextAlignment:NSTextAlignmentCenter];
//        [savedDome addTarget:_delegate action:@selector(makeNewDomePressed) forControlEvents:UIControlEventTouchUpInside];
        [_savedDomesScrollView addSubview:savedDome];
    }
}

@end
