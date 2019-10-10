//
//  View.m
//  Domekit
//
//  Created by Robby on 5/4/15.
//  Copyright (c) 2015 Robby. All rights reserved.
//

#import "GeodesicView.h"
#import "OpenGL/mesh.h"

#define polarRadius 2

@implementation GeodesicView

-(void) setGestureRotation:(GLKQuaternion)gestureRotation{
    _gestureRotation = gestureRotation;
}

- (void)drawRect:(CGRect)rect {
    // dark mode
    float bgColor[3] = {1.0f, 1.0f, 1.0f};
    
    if (@available(iOS 12.0, *)) {
        if (self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
            bgColor[0] = 0.0f;
            bgColor[1] = 0.0f;
            bgColor[2] = 0.0f;
        } else {
        }
    } else {
    }
    glClearColor(bgColor[0], bgColor[1], bgColor[2], 1.0f);
    glClear (GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    glPushMatrix(); // begin device orientation

        // setup polar coordinate frame looking into the origin
		glTranslatef(0, _yOffset, 0);
		glTranslatef(0, 0, -.4);
        glTranslatef(0, 0, -_cameraRadius);
        glTranslatef(0, 0, -_cameraRadiusFix);
        glMultMatrixf(_attitudeMatrix.m);

        GLfloat diffuseHidden[] = { 1.0, 1.0, 1.0, _sphereAlpha * _slicedSphereAlpha};
        GLfloat diffuseFull[] = { 1.0, 1.0, 1.0, _sphereAlpha };
        glMaterialfv(GL_FRONT_AND_BACK, GL_DIFFUSE, diffuseHidden);

        glPushMatrix();
            glMultMatrixf(GLKMatrix4MakeWithQuaternion(_gestureRotation).m);
            [_geodesicModel drawTrianglesSphereOverride];
            glMaterialfv(GL_FRONT_AND_BACK, GL_DIFFUSE, diffuseFull);
            [_geodesicModel drawTriangles];
        glPopMatrix();
    glPopMatrix(); // end device orientation
}

-(void) setGeodesicModel:(GeodesicModel *)geodesicModel{
    _geodesicModel = geodesicModel;
}

#pragma mark- OPENGL

-(void)setFieldOfView:(float)fieldOfView{
    _fieldOfView = fieldOfView;
    [self rebuildProjectionMatrix];
}
-(void)initOpenGL:(EAGLContext*)context{
    [(CAEAGLLayer*)self.layer setOpaque:NO];
    _aspectRatio = self.frame.size.width/self.frame.size.height;
    _fieldOfView = 45 + 45 * atanf(_aspectRatio); // hell ya
    _cameraRadius = polarRadius;
    [self rebuildProjectionMatrix];
    _attitudeMatrix = GLKMatrix4Identity;
    [self customGL];
	
	// Iphone X Fix
	_yOffset = 0.0;
    if (@available(iOS 11.0, *)) {
        UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
        if (mainWindow.safeAreaInsets.top > 24.0) {
            _yOffset = 0.2;
        }
    }

}
-(void)rebuildProjectionMatrix{
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    GLfloat frustum = Z_NEAR * tanf(_fieldOfView*0.00872664625997);  // pi/180/2
    _projectionMatrix = GLKMatrix4MakeFrustum(-frustum, frustum, -frustum/_aspectRatio, frustum/_aspectRatio, Z_NEAR, Z_FAR);
    glMultMatrixf(_projectionMatrix.m);
    glViewport(0, 0, self.frame.size.width, self.frame.size.height);
    glMatrixMode(GL_MODELVIEW);
}
-(void) customGL{
    static GLfloat light_position1[] = { 5.0, 5.0, 5.0, 0.0 };
    static GLfloat light_position2[] = { 5.0, -5.0, 5.0, 0.0 };
    static GLfloat light_position3[] = { -5.0, -5.0, 5.0, 0.0 };
    glMatrixMode(GL_MODELVIEW);
    
//    GLfloat mat_solid[] = { 1.0f, 1.0f, 1.0f, 1.0f };
//    GLfloat mat_shininess[] = { 5.0f };
    GLfloat red[] = {1.0f, 0.0f, 0.0f, 1.0f};
    GLfloat green[] = {0.0f, 1.0f, 0.0f, 1.0f};
    GLfloat blue[] = {0.0f, 0.0f, 1.0f, 1.0f};
//    glMaterialfv(GL_FRONT, GL_DIFFUSE, mat_solid);
//    glMaterialfv(GL_FRONT, GL_SHININESS, mat_shininess);
    glEnable(GL_LIGHTING);
    glEnable(GL_LIGHT0);
    glEnable(GL_LIGHT1);
    glEnable(GL_LIGHT2);
    glLightfv(GL_LIGHT0, GL_DIFFUSE, red);
    glLightfv(GL_LIGHT1, GL_DIFFUSE, blue);
    glLightfv(GL_LIGHT2, GL_DIFFUSE, green);
    glLightfv(GL_LIGHT0, GL_POSITION, light_position1);
    glLightfv(GL_LIGHT1, GL_POSITION, light_position2);
    glLightfv(GL_LIGHT2, GL_POSITION, light_position3);
    glEnable(GL_CULL_FACE);
    glCullFace(GL_FRONT);
//    glShadeModel(GL_FLAT);
    glShadeModel (GL_SMOOTH);
    glEnable( GL_POINT_SMOOTH );
    glLineWidth(5);
    glPointSize(10);
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);

    glEnable(GL_BLEND);
    glEnable(GL_DEPTH_TEST);
    glDepthMask (GL_TRUE);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
//    glClearDepth(1.0f);
//    glDepthFunc(GL_LEQUAL);
}

-(id) init{
    // it appears that iOS already automatically does this switch, stored in UIScreen mainscreen bounds
//    CGRect frame = [[UIScreen mainScreen] bounds];
//    if(SENSOR_ORIENTATION == 3 || SENSOR_ORIENTATION == 4){
//        return [self initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.height, frame.size.width)];
//    } else{
//        return [self initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height)];
//    }

    return [self initWithFrame:[[UIScreen mainScreen] bounds]];
}
- (id)initWithFrame:(CGRect)frame{
    EAGLContext *context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
    [EAGLContext setCurrentContext:context];
    self.context = context;
    return [self initWithFrame:frame context:context];
}
-(id) initWithFrame:(CGRect)frame context:(EAGLContext *)context{
    self = [super initWithFrame:frame context:context];
    if (self) {
        [self initOpenGL:context];
        _sphereAlpha = 1.0;
        _slicedSphereAlpha = 1.0;
        _gestureRotation = GLKQuaternionIdentity;
    }
    return self;
}

@end
