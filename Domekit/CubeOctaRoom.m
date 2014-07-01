#import "CubeOctaRoom.h"
#import <OpenGLES/ES1/gl.h>

const GLfloat quadVertices[3*4] = {
    -1.0f, 1.0f, 0.0f,
    -1.0f, -1.0f, 0.0f,
    1.0f, 1.0f, 0.0f,
    1.0f, -1.0f, 0.0f
};

@implementation CubeOctaRoom

+(instancetype) room{
    CubeOctaRoom *room = [[CubeOctaRoom alloc] init];
    return room;
}

-(void) draw{
    [self drawRoomWalls];
}

-(void) drawQuad{
    glEnableClientState(GL_VERTEX_ARRAY);
    glVertexPointer(3, GL_FLOAT, 0, quadVertices);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    glDisableClientState(GL_VERTEX_ARRAY);
}

-(void)drawRoomWalls{
    static float dist = 2.82842712474619;//sqrtf(2)*2;
    
    glPushMatrix();
    glScalef(1.25, 1.25, 1.25);
    
    // SQUARE FACES
    
    // top and bottom
    glPushMatrix();
    glRotatef(90, 1, 0, 0);
    glTranslatef(0.0f, 0.0f, -dist);
    [self drawQuad];
    glPopMatrix();
    glPushMatrix();
    glRotatef(90, 1, 0, 0);
    glTranslatef(0.0f, 0.0f, dist);
    [self drawQuad];
    glPopMatrix();
    // 4 sides
    glPushMatrix();
    glTranslatef(0.0f, 0.0f, dist);
    [self drawQuad];
    glPopMatrix();
    glPushMatrix();
    glTranslatef(0.0f, 0.0f, -dist);
    [self drawQuad];
    glPopMatrix();
    glPushMatrix();
    glRotatef(90, 0, 1, 0);
    glTranslatef(0.0f, 0.0f, dist);
    [self drawQuad];
    glPopMatrix();
    glPushMatrix();
    glRotatef(90, 0, 1, 0);
    glTranslatef(0.0f, 0.0f, -dist);
    [self drawQuad];
    glPopMatrix();
    
    //ROTATION 1
    
    glPushMatrix();
    glRotatef(45, 0, 1, 0);
    
    // 4 sides
    glPushMatrix();
    glTranslatef(0.0f, 0.0f, dist);
    [self drawQuad];
    glPopMatrix();
    glPushMatrix();
    glTranslatef(0.0f, 0.0f, -dist);
    [self drawQuad];
    glPopMatrix();
    glPushMatrix();
    glRotatef(90, 0, 1, 0);
    glTranslatef(0.0f, 0.0f, dist);
    [self drawQuad];
    glPopMatrix();
    glPushMatrix();
    glRotatef(90, 0, 1, 0);
    glTranslatef(0.0f, 0.0f, -dist);
    [self drawQuad];
    glPopMatrix();
    
    glPopMatrix();
    
    // ROTAITON 2
    glPushMatrix();
    glRotatef(45, 1, 0, 0);
    
    // top and bottom
    glPushMatrix();
    glRotatef(90, 1, 0, 0);
    glTranslatef(0.0f, 0.0f, -dist);
    [self drawQuad];
    glPopMatrix();
    glPushMatrix();
    glRotatef(90, 1, 0, 0);
    glTranslatef(0.0f, 0.0f, dist);
    [self drawQuad];
    glPopMatrix();
    // 4 sides
    glPushMatrix();
    glTranslatef(0.0f, 0.0f, dist);
    [self drawQuad];
    glPopMatrix();
    glPushMatrix();
    glTranslatef(0.0f, 0.0f, -dist);
    [self drawQuad];
    glPopMatrix();
    
    glPopMatrix();
    
    // ROTATION 3
    glPushMatrix();
    glRotatef(45, 0, 0, 1);
    
    // top and bottom
    glPushMatrix();
    glRotatef(90, 1, 0, 0);
    glTranslatef(0.0f, 0.0f, -dist);
    [self drawQuad];
    glPopMatrix();
    glPushMatrix();
    glRotatef(90, 1, 0, 0);
    glTranslatef(0.0f, 0.0f, dist);
    [self drawQuad];
    glPopMatrix();
    // 4 sides
    // cut
    glPushMatrix();
    glRotatef(90, 0, 1, 0);
    glTranslatef(0.0f, 0.0f, dist);
    [self drawQuad];
    glPopMatrix();
    glPushMatrix();
    glRotatef(90, 0, 1, 0);
    glTranslatef(0.0f, 0.0f, -dist);
    [self drawQuad];
    glPopMatrix();
    
    glPopMatrix();
    
    glPopMatrix();  // scale master

}


@end
