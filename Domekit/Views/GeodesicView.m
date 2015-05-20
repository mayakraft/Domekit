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

- (void)drawRect:(CGRect)rect {
//    static GLfloat whiteColor[] = {1.0f, 1.0f, 1.0f, 1.0f};
//    static GLfloat clearColor[] = {0.0f, 0.0f, 0.0f, 0.0f};
    glClearColor(1.0f, 1.0f, 1.5f, 0.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    
    glPushMatrix(); // begin device orientation

//    _attitudeMatrix = GLKMatrix4Multiply([self getDeviceOrientationMatrix], _offsetMatrix);
    
//    glMaterialfv(GL_FRONT_AND_BACK, GL_EMISSION, whiteColor);  // panorama at full color
//    [sphere execute];
//    glMaterialfv(GL_FRONT_AND_BACK, GL_EMISSION, clearColor);
//        [meridians execute];  // semi-transparent texture overlay (15° meridian lines)

    static perspective_t POV = POLAR;
    switch(POV){
        case FPP:
            glMultMatrixf(_attitudeMatrix.m);
//            // raise POV 1.0 above the floor, 1.0 is an arbitrary value
            glTranslatef(0, 0, -1.0f);
            break;
            
        case POLAR:
            glTranslatef(0, 0, -polarRadius);
            glMultMatrixf(_attitudeMatrix.m);
            break;
            
        case ORTHO:
//            glTranslatef(-mouseTotalOffsetX * .05, mouseTotalOffsetY * .05, 0.0f);
            break;
    }
    
//    glDisable(GL_LIGHTING);
//    glPushMatrix();
//        [self drawCheckerboardX:0 Y:0 NumberSquares:4];
//    glPopMatrix();
    
    glEnable(GL_LIGHTING);
    
    glPushMatrix();
//        glTranslatef(0, 0, 1.0f);
        [self drawTriangles];
    glPopMatrix();
    
    glPopMatrix(); // end device orientation
}

-(void) setGeodesicModel:(GeodesicModel *)geodesicModel{
    _geodesicModel = geodesicModel;
}

-(void) drawTriangles{
    glPushMatrix();
    glRotatef(-90, 0, 0, 1);
    glScalef(_geodesicModel.mesh.shrink, _geodesicModel.mesh.shrink, _geodesicModel.mesh.shrink);
    glEnableClientState(GL_VERTEX_ARRAY);
    glEnableClientState(GL_NORMAL_ARRAY);
    glVertexPointer(3, GL_FLOAT, 0, _geodesicModel.mesh.glTriangles);
    glNormalPointer(GL_FLOAT, 0, _geodesicModel.mesh.glTriangleNormals);
    if(_sliceAmount)
        glDrawArrays(GL_TRIANGLES, 0, _sliceAmount*3);
    else
        glDrawArrays(GL_TRIANGLES, 0, _geodesicModel.mesh.numTriangles*3);
    glDisableClientState(GL_NORMAL_ARRAY);
    glDisableClientState(GL_VERTEX_ARRAY);
    glPopMatrix();
//    if(_showMeridians){
//        glDisable(GL_CULL_FACE);
//        glDisable(GL_LIGHTING);
//        glColor4f(0.0f, 0.0f, 0.0f, 1.0f);
//        glPushMatrix();
//        glRotatef(-90, 0, 0, 1);
//        glEnableClientState(GL_VERTEX_ARRAY);
//        glEnableClientState(GL_NORMAL_ARRAY);
//        glVertexPointer(3, GL_FLOAT, 0, _geodesicModel.sliceMeridians.points);
////        glNormalPointer(GL_FLOAT, 0, _geodesicModel.sliceMeridians.numPoints);
//        glDrawArrays(GL_POINTS, 0, _geodesicModel.sliceMeridians.numPoints);
////        glVertexPointer(3, GL_FLOAT, 0, _geodesicModel.meridiansMesh.glTriangles);
////        glNormalPointer(GL_FLOAT, 0, _geodesicModel.meridiansMesh.glTriangleNormals);
////        glDrawArrays(GL_TRIANGLES, 0, _geodesicModel.meridiansMesh.numPlanes*3);
//        glDisableClientState(GL_NORMAL_ARRAY);
//        glDisableClientState(GL_VERTEX_ARRAY);
//        glPopMatrix();
//        glEnable(GL_LIGHTING);
//        glEnable(GL_CULL_FACE);
//    }
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
    NSLog(@"FOV %f",_fieldOfView);
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
//    glEnable(GL_CULL_FACE);
//    glCullFace(GL_FRONT);
//    glEnable(GL_DEPTH_TEST);
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
    glDepthMask(GL_TRUE);
//    glClearDepth(1.0f);
    glEnable(GL_DEPTH_TEST);
    glDepthFunc(GL_LEQUAL);
    
    GLfloat mat_specular[] = { 1.0f, 1.0f, 1.0f, 1.0f };
//    GLfloat mat_shininess[] = { 5.0f };
    GLfloat red[] = {1.0f, 0.0f, 0.0f, 1.0f};
    GLfloat green[] = {0.0f, 1.0f, 0.0f, 1.0f};
    GLfloat blue[] = {0.0f, 0.0f, 1.0f, 1.0f};
    glMaterialfv(GL_FRONT, GL_DIFFUSE, mat_specular);
    // glMaterialfv(GL_FRONT, GL_SHININESS, mat_shininess);
    glLightfv(GL_LIGHT0, GL_DIFFUSE, red);
    glLightfv(GL_LIGHT1, GL_DIFFUSE, blue);
    glLightfv(GL_LIGHT2, GL_DIFFUSE, green);
    glLightfv(GL_LIGHT0, GL_POSITION, light_position1);
    glLightfv(GL_LIGHT1, GL_POSITION, light_position2);
    glLightfv(GL_LIGHT2, GL_POSITION, light_position3);
    glEnable(GL_LIGHTING);
    glEnable(GL_LIGHT0);
    glEnable(GL_LIGHT1);
    glEnable(GL_LIGHT2);
    glCullFace(GL_FRONT);
    glEnable(GL_CULL_FACE);
    // glShadeModel(GL_FLAT);
    glShadeModel (GL_SMOOTH);
    glEnable( GL_POINT_SMOOTH );
    glLineWidth(5);
    glPointSize(10);
    glClearColor(0.0f, 0.0f, 0.0f, 0.0f);

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
    }
    return self;
}

@end
