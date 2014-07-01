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
    float w = self.view.bounds.size.width * .875;
    _slider = [[UISlider alloc] initWithFrame:CGRectMake(self.view.bounds.size.width*.5 - w*.5, self.view.bounds.size.height*.9, w, 48)];
    [self.view addSubview:_slider];
}

//-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    for(UITouch *touch in touches){
//        for(Hotspot *spot in self.hotspots){
//            if(CGRectContainsPoint([spot bounds], [touch locationInView:self.view])){
//                // customize response to each touch area
//                if([spot ID] == hotspotControls) { }
//                break;
//            }
//        }
//    }
//}
//
//-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
//    for(UITouch *touch in touches){
//        for(Hotspot *spot in self.hotspots){
//            if(CGRectContainsPoint([spot bounds], [touch locationInView:self.view])){
//                // customize response to each touch area
//                if([spot ID] == hotspotControls && _scene == scene2){
//                    float freq = ([touch locationInView:self.view].x-(self.view.frame.size.width)/12.*1.5) / ((self.view.frame.size.width)/12.);
//                    if(freq < 0) freq = 0;
//                    if(freq > 8) freq = 8;
//                    //TODO: THIS NEEDS TO GET THE UPDATE
//                    //                        [navScreen setRadioBarPosition:freq];
//                }
//                break;
//            }
//        }
//    }
//}
//
//-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
//    for(UITouch *touch in touches){
//        for(Hotspot *spot in self.hotspots){
//            if(CGRectContainsPoint([spot bounds], [touch locationInView:self.view])){
//                // customize response to each touch area
//                else if([spot ID] == hotspotControls){
//                    if(_scene == scene1){
//                        if([touch locationInView:self.view].x < self.view.frame.size.width*.5){
//                            
//                        }
//                        else if([touch locationInView:self.view].x > self.view.frame.size.width*.5){
//                            
//                        }
//                    }
//                    if(_scene == scene2){
//                        int freq = ([touch locationInView:self.view].x-(self.view.frame.size.width)/12.*1.5) / ((self.view.frame.size.width)/12.);
//                        if(freq < 0) freq = 0;
//                        if(freq > 8) freq = 8;
//                        //TODO: THIS NEEDS TO GET THE UPDATE
//                        //                            [navScreen setRadioBarPosition:freq];
//                        animationNewGeodesic = [[Animation alloc] initOnStage:self Start:_elapsedSeconds End:_elapsedSeconds+.5];
//                    }
//                }
//                break;
//            }
//        }
//    }
//}

@end
