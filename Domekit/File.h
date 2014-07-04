#import "Face.h"

@protocol FileDelegate <NSObject>
@required
-(void) makeNewDomePressed;
-(void) loadDomePressed;
@end

@interface File : Face

@property id <FileDelegate> delegate;

//@property UIButton *load;
@property UIButton *make;

@property UIScrollView *savedDomesScrollView;

@end
