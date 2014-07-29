#import "Make.h"
#import <OpenGLES/ES1/gl.h>

@interface Make (){
    //    static float arrowWidth = ;   // fix this, put make it static
}
@end

@implementation Make

#define arrowWidth self.frame.size.width*.175

-(void) setup{
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, arrowWidth*1.25)];
    [_titleLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:self.frame.size.width*.1]];
    [_titleLabel setNumberOfLines:0];
    [_titleLabel setTextAlignment:NSTextAlignmentCenter];
    [_titleLabel setTextColor:[UIColor whiteColor]];
    [_titleLabel setText:@"SCENE 1"];
    //    [_titleLabel sizeToFit];
    [self.view addSubview:_titleLabel];
    
    _button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button1 setFrame:CGRectMake(0, self.frame.size.height-arrowWidth, (self.frame.size.width)*.5, (self.frame.size.width)/12.)];
    [[_button1 titleLabel] setFont:[UIFont fontWithName:@"Montserrat-Regular" size:self.frame.size.width*.1]];
    [[_button1 titleLabel] setTextAlignment:NSTextAlignmentCenter];
    [[_button1 titleLabel] setTextColor:[UIColor blackColor]];
    [[_button1 titleLabel] setText:@"button"];
    [self.view addSubview:_button1];
    
    _button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button2 setFrame:CGRectMake((self.frame.size.width)*.5, self.frame.size.height-arrowWidth, (self.frame.size.width)*.5, (self.frame.size.width)/12.)];
    [[_button2 titleLabel] setFont:[UIFont fontWithName:@"Montserrat-Regular" size:self.frame.size.width*.1]];
    [[_button2 titleLabel] setTextAlignment:NSTextAlignmentCenter];
    [[_button2 titleLabel] setTextColor:[UIColor blackColor]];
    [[_button2 titleLabel] setText:@"button"];
    [self.view addSubview:_button2];
    
//    self.elements = [NSMutableArray array];
//    [self.elements addObjectsFromArray:@[_button1, _button2]];
    
    _numberLabels = [[NSMutableArray alloc] init];
    for(int i = 0; i < 9; i++){
        UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.frame.size.width)/12.*(i+1.5), self.frame.size.height-arrowWidth, (self.frame.size.width)/12., (self.frame.size.width)/12.)];
        [numberLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:self.frame.size.width*.1]];
        [numberLabel setTextAlignment:NSTextAlignmentCenter];
        [numberLabel setHidden:YES];
        [numberLabel setText:[NSString stringWithFormat:@"%d",i+1]];
        [numberLabel setTextColor:[UIColor blackColor]];
        [_numberLabels addObject:numberLabel];
        [self.view addSubview:numberLabel];
//        [self.elements addObject:numberLabel];
    }
}

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