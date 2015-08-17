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
//    static GLfloat whiteColor[] = {1.0f, 1.0f, 1.0f, 1.0f};
//    static GLfloat clearColor[] = {0.0f, 0.0f, 0.0f, 0.0f};
    glClearColor(1.0f, 1.0f, 1.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    
    glPushMatrix(); // begin device orientation
//    GLKMatrix4 m = GLKMatrix4MakeWithQuaternion(_gestureRotation);
//    glMultMatrixf(m.m);

    static perspective_t POV = POLAR;
    if (POV == FPP){
//            glMultMatrixf(_attitudeMatrix.m);
//            // raise POV 1.0 above the floor, 1.0 is an arbitrary value
//            glTranslatef(0, 0, -1.0f);
    }
    if(POV == POLAR){
            glTranslatef(0, 0, -.4);
            glTranslatef(0, 0, -_cameraRadius);
            glTranslatef(0, 0, -_cameraRadiusFix);
            glMultMatrixf(_attitudeMatrix.m);
    }
    if(POV == ORTHO){
//            glTranslatef(-mouseTotalOffsetX * .05, mouseTotalOffsetY * .05, 0.0f);
    }
    
    glEnable(GL_BLEND);
    glEnable(GL_DEPTH_TEST);
    glClear (GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glDepthMask (GL_TRUE);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
//    if(_sphereAlphaHiddenFaces != 0.0){
//        NSLog(@"hidden faces");
//        GLfloat diffuseHidden[] = { 1.0, 1.0, 1.0, _sphereAlphaHiddenFaces };
//        glMaterialfv(GL_FRONT_AND_BACK, GL_DIFFUSE, diffuseHidden);
//        glPushMatrix();
//            if(_sphereOverride)
//                [_geodesicModel drawHiddenTrianglesSphereOverride];
//            else
//                [_geodesicModel drawHiddenTriangles];
//        glPopMatrix();
//    }
    
//    if(_animationFlag){
        GLfloat diffuseHidden[] = { 1.0, 1.0, 1.0, _sphereAlpha * _slicedSphereAlpha};
        GLfloat diffuseFull[] = { 1.0, 1.0, 1.0, _sphereAlpha };

        glMaterialfv(GL_FRONT_AND_BACK, GL_DIFFUSE, diffuseHidden);
        glPushMatrix();
        glMultMatrixf(GLKMatrix4MakeWithQuaternion(_gestureRotation).m);
        [_geodesicModel drawTrianglesSphereOverride];

        glMaterialfv(GL_FRONT_AND_BACK, GL_DIFFUSE, diffuseFull);

        [_geodesicModel drawTriangles];
        glPopMatrix();
//    }
//    else{
//        GLfloat diffuse[] = { 1.0, 1.0, 1.0, _sphereAlpha * _slicedSphereAlpha};
//        glMaterialfv(GL_FRONT_AND_BACK, GL_DIFFUSE, diffuse);
//        glPushMatrix();
//        glMultMatrixf(GLKMatrix4MakeWithQuaternion(_gestureRotation).m);
//
//            if(_sphereOverride)
//                [_geodesicModel drawTrianglesSphereOverride];
//            else
//                [_geodesicModel drawTriangles];
//        glPopMatrix();
//    }
    
    glPopMatrix(); // end device orientation
}

-(void) setGeodesicModel:(GeodesicModel *)geodesicModel{
    _geodesicModel = geodesicModel;
}

#pragma mark- OPENGL

// draws a XY 1x1 square in the Z = 0 plane
-(void) unitSquareX:(float)x Y:(float)y Width:(float)width Height:(float)height{
    static const GLfloat _unit_square_vertex[] = {
        0.0f, 1.0f, 0.0f,     1.0f, 1.0f, 0.0f,    0.0f, 0.0f, 0.0f,    1.0f, 0.0f, 0.0f };
    static const GLfloat _unit_square_normals[] = {
        0.0f, 0.0f, 1.0f,     0.0f, 0.0f, 1.0f,    0.0f, 0.0f, 1.0f,    0.0f, 0.0f, 1.0f };
    glPushMatrix();
    glScalef(width, height, 1.0);
    glTranslatef(x, y, 0.0);
    glEnableClientState(GL_VERTEX_ARRAY);
    glEnableClientState(GL_NORMAL_ARRAY);
    glVertexPointer(3, GL_FLOAT, 0, _unit_square_vertex);
    glNormalPointer(GL_FLOAT, 0, _unit_square_normals);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    glDisableClientState(GL_NORMAL_ARRAY);
    glDisableClientState(GL_VERTEX_ARRAY);
    glPopMatrix();
}

-(void) drawCheckerboardX:(float)walkX Y:(float)walkY NumberSquares:(int)numSquares{
    int XOffset = ceil(walkX);
    int YOffset = ceil(walkY);
    for(int i = -numSquares; i <= numSquares; i++){
        for(int j = -numSquares; j <= numSquares; j++){
            int b = abs(((i+j+XOffset+YOffset)%2));
            if(b) glColor4f(1.0, 1.0, 1.0, 1.0);
            else glColor4f(0.0, 0.0, 0.0, 1.0);
            [self unitSquareX:i-XOffset Y:j-YOffset Width:1 Height:1];
        }
    }
}
-(void)setFieldOfView:(float)fieldOfView{
    _fieldOfView = fieldOfView;
    [self rebuildProjectionMatrix];
}
-(void)initOpenGL:(EAGLContext*)context{
    [(CAEAGLLayer*)self.layer setOpaque:NO];
    _aspectRatio = self.frame.size.width/self.frame.size.height;
    _fieldOfView = 45 + 45 * atanf(_aspectRatio); // hell ya
    _cameraRadius = polarRadius;
//    NSLog(@"FOV %f",_fieldOfView);
    [self rebuildProjectionMatrix];
    _attitudeMatrix = GLKMatrix4Identity;
    [self customGL];
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
    
//    glDepthMask(GL_TRUE);
//    glClearDepth(1.0f);
//    glEnable(GL_DEPTH_TEST);
//    glDepthFunc(GL_LEQUAL);
    
//    GLfloat mat_solid[] = { 1.0f, 1.0f, 1.0f, 1.0f };
//    GLfloat mat_shininess[] = { 5.0f };
    GLfloat red[] = {1.0f, 0.0f, 0.0f, 1.0f};
    GLfloat green[] = {0.0f, 1.0f, 0.0f, 1.0f};
    GLfloat blue[] = {0.0f, 0.0f, 1.0f, 1.0f};
//    glMaterialfv(GL_FRONT, GL_DIFFUSE, mat_solid);
    // glMaterialfv(GL_FRONT, GL_SHININESS, mat_shininess);
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
    // glShadeModel(GL_FLAT);
    glShadeModel (GL_SMOOTH);
    glEnable( GL_POINT_SMOOTH );
    glLineWidth(5);
    glPointSize(10);
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);

    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
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
//        _sphereAlphaHiddenFaces = 0.0;
        _gestureRotation = GLKQuaternionIdentity;
    }
    return self;
}

@end
