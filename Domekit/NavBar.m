#import "NavBar.h"

@implementation NavBar

-(void) setup{
    
    float arrowWidth = self.view.frame.size.width*.175;
    
    _forwardButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-(arrowWidth+5), 5, arrowWidth, arrowWidth)];
    [_forwardButton addTarget:self action:@selector(forwardButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [_forwardButton setBackgroundColor:[UIColor blackColor]];
    [[_forwardButton titleLabel] setFont:[UIFont fontWithName:@"Montserrat-Regular" size:30]];
    [_forwardButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_forwardButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [_forwardButton setTitle:@"▶︎" forState:UIControlStateNormal];
    [[self view] addSubview:_forwardButton];

    _backButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, arrowWidth, arrowWidth)];
    [_backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [_backButton setBackgroundColor:[UIColor blackColor]];
    [_backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_backButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [_backButton setTitle:@"◀︎" forState:UIControlStateNormal];
    [[_backButton titleLabel] setFont:[UIFont boldSystemFontOfSize:30]];

    [[self view] addSubview:_backButton];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5+arrowWidth, 5, self.view.frame.size.width-arrowWidth*2, arrowWidth)];
    [_titleLabel setTextAlignment:NSTextAlignmentCenter];
    [_titleLabel setFont:[UIFont boldSystemFontOfSize:30]];
    [_titleLabel setTextColor:[UIColor blackColor]];
    [_titleLabel setText:@"here"];
    [[self view] addSubview:_titleLabel];
    
    _numPages = 4;
//    [self setTitles:@[@"", @"MAKE", @"ASSEMBLE", @"SHARE"]];
}

+(instancetype) navBar{
    float w = [[UIScreen mainScreen] bounds].size.width;
    NavBar *navBar = [[NavBar alloc] initWithFrame:CGRectMake(0, 0, w, [[UIScreen mainScreen] bounds].size.width*.175+10)];
    if(navBar){
        
    }
    return navBar;
}

-(void) setPage:(NSInteger)page{
    if(page < 0 || page >= _numPages) return;
    _page = page;
    [[self delegate] pageChanged];
    [self setNeedsLayout];
}

//-(void) setTitles:(NSArray *)titles{
//    _titles = titles;
//    _numPages = [_titles count];
//    [self setNeedsLayout];
//}

//-(void) setNeedsLayout{
//    if(self.page >= 0 && self.page < [_titles count])
//        [_titleLabel setText:[_titles objectAtIndex:self.page]];
//}

-(void) backButtonPressed{
    if(self.page <= 0) return;
    self.page--;
    [[self delegate] pageTurnBack:self.page];
    [[self delegate] pageChanged];
    [self setNeedsLayout];
}

-(void) forwardButtonPressed{
    if(self.page >= _numPages-1) return;
    self.page++;
    [[self delegate] pageTurnForward:self.page];
    [[self delegate] pageChanged];
    [self setNeedsLayout];
}

@end
