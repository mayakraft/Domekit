#import <OpenGLES/ES1/gl.h>

void rainbow(float *clearColor, float *brightness, float *alpha){
    clearColor[0] = clearColor[1] = clearColor[2] = 0.0f;
    clearColor[3] = 1.0f;
    GLfloat white[] = {*brightness, *brightness, *brightness, *alpha};
    GLfloat blue[] = {0.0f, 0.0f, 1.0f, *alpha};
    GLfloat green[] = {0.0f, 1.0f, 0.0f, *alpha};
    GLfloat red[] = {1.0f, 0.0f, 0.0f, *alpha};
//    GLfloat pos1[] = {0.0f, 10.0f, 0.0f, 1.0f};
//    GLfloat pos2[] = {-8.6f, -5.0f, 0.0f, 1.0f};
//    GLfloat pos3[] = {8.6f, -5.0f,  0.0f, 1.0f};
    GLfloat pos1[] = {0.0f, 5.0f, 0.0f, 1.0f};
    GLfloat pos2[] = {-4.3f, -2.5f, 0.0f, 1.0f};
    GLfloat pos3[] = {4.3f, -2.5f,  0.0f, 1.0f};
    glLightfv(GL_LIGHT1, GL_POSITION, pos1);
    glLightfv(GL_LIGHT1, GL_DIFFUSE, blue);
    glLightfv(GL_LIGHT2, GL_POSITION, pos2);
    glLightfv(GL_LIGHT2, GL_DIFFUSE, red);
    glLightfv(GL_LIGHT3, GL_POSITION, pos3);
    glLightfv(GL_LIGHT3, GL_DIFFUSE, green);
    glMaterialfv(GL_FRONT_AND_BACK, GL_DIFFUSE, white);
    //glShadeModel(GL_SMOOTH);
    glEnable(GL_LIGHTING);
    glEnable(GL_LIGHT1);
    glEnable(GL_LIGHT2);
    glEnable(GL_LIGHT3);
}

void reset_lighting(){
    glDisable(GL_LIGHT0);
    glDisable(GL_LIGHT1);
    glDisable(GL_LIGHT2);
    glDisable(GL_LIGHT3);
    glDisable(GL_LIGHT4);
    glDisable(GL_LIGHT5);
    glDisable(GL_LIGHT6);
    glDisable(GL_LIGHT7);
}

void spotlightNoir(float *clearColor, float *brightness, float *alpha){
    clearColor[0] = clearColor[1] = clearColor[2] = 0.0f;
    clearColor[3] = 1.0f;
    GLfloat white[] = {*brightness, *brightness, *brightness, *alpha};
    GLfloat pos1[] = {0.0f, 10.0f, 0.0f, 1.0f};
    glLightfv(GL_LIGHT0, GL_DIFFUSE, white);
    glLightfv(GL_LIGHT0, GL_POSITION, pos1);
    glMaterialfv(GL_FRONT_AND_BACK, GL_DIFFUSE, white);
    glShadeModel(GL_SMOOTH);
    glEnable(GL_LIGHTING);
    glEnable(GL_LIGHT0);
    static GLfloat lightWhite[4] = {.60f, .60f, .60f, 1.0f};
    glMaterialfv(GL_FRONT_AND_BACK, GL_AMBIENT, lightWhite);
}

void silhouette(float *clearColor){
    clearColor[0] = clearColor[1] = clearColor[2] = 1.0f;
    clearColor[3] = 1.0f;
    glDisable(GL_LIGHTING);
    glColor4f(0.0, 0.0, 0.0, 1.0);
}

void whiteSilhouette(float *clearColor){
    clearColor[0] = clearColor[1] = clearColor[2] = 0.0f;
    clearColor[3] = 1.0f;
    glDisable(GL_LIGHTING);
    glColor4f(1.0, 1.0, 1.0, 1.0);
}
