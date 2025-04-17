#include <GL/glut.h>
#include <vector>
#include <cstdlib> // for rand
#include <ctime>   // for seeding rand

struct Ball {
    float x, y, z;
    float vy;
    float radius;
};

// Settings
const int NUM_BALLS = 1000;
const float PARTICLE_SIZE = 0.02f; // size of each particle
std::vector<Ball> particles;

float gravity = -0.0098f;
float floorY = -1.0f;
float bounceDamping = 0.5f;

// Random float helper
float randFloat(float min, float max) {
    return min + static_cast<float>(rand()) / (static_cast<float>(RAND_MAX / (max - min)));
}

// Setup all particles
void initBalls() {
    srand(static_cast<unsigned int>(time(0)));
    for (int i = 0; i < NUM_BALLS; ++i) {
        Ball ball;
        ball.x = randFloat(-1.5f, 1.5f);
        ball.z = randFloat(-1.5f, 1.5f);
        ball.y = randFloat(0.5f, 2.5f); // Start at random height
        ball.vy = 0.0f;
        ball.radius = PARTICLE_SIZE; // small size
        particles.push_back(ball);
    }
}

// Update all particles
void update(int value) {
    for (auto& ball : particles) {
        ball.vy += gravity;
        ball.y += ball.vy;

        if (ball.y <= floorY + ball.radius) {
            ball.y = floorY + ball.radius;
            ball.vy *= -bounceDamping;

            // If the bounce is too weak, recycle the particle
            if (std::abs(ball.vy) < 0.05f) {
                ball.x = randFloat(-1.5f, 1.5f);
                ball.z = randFloat(-1.5f, 1.5f);
                ball.y = randFloat(2.0f, 4.0f); // start higher now
                ball.vy = randFloat(-0.05f, -0.15f); // small downward initial speed
            }
        }
    }

    glutPostRedisplay();
    glutTimerFunc(16, update, 0);
}

// Lighting setup
void initLighting() {
    GLfloat light_pos[] = { 1.0f, 1.0f, 2.0f, 0.0f };
    GLfloat light_ambient[] = { 0.1f, 0.1f, 0.1f, 1.0f };
    GLfloat light_diffuse[] = { 0.6f, 0.8f, 1.0f, 1.0f };

    glEnable(GL_LIGHTING);
    glEnable(GL_LIGHT0);
    glLightfv(GL_LIGHT0, GL_POSITION, light_pos);
    glLightfv(GL_LIGHT0, GL_AMBIENT, light_ambient);
    glLightfv(GL_LIGHT0, GL_DIFFUSE, light_diffuse);

    glEnable(GL_COLOR_MATERIAL);
    glColorMaterial(GL_FRONT, GL_AMBIENT_AND_DIFFUSE);
}

// Draw everything
void display() {
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glLoadIdentity();
    gluLookAt(0, 0, 5, 0, 0, 0, 0, 1, 0);

    // Draw floor
    glColor3f(0.2f, 0.2f, 0.2f);
    glBegin(GL_QUADS);
        glVertex3f(-2.0f, floorY, -2.0f);
        glVertex3f( 2.0f, floorY, -2.0f);
        glVertex3f( 2.0f, floorY,  2.0f);
        glVertex3f(-2.0f, floorY,  2.0f);
    glEnd();

    glDepthMask(GL_FALSE);
    // Draw all particles
    for (auto& ball : particles) {
        glPushMatrix();
        glTranslatef(ball.x, ball.y, ball.z);
        glColor4f(0.6f, 0.8f, 1.0f, 0.8f); // watery blue
        glutSolidSphere(ball.radius, 20, 20);
        glPopMatrix();
    }
    glDepthMask(GL_TRUE);

    glutSwapBuffers();
}

void reshape(int w, int h) {
    if (h == 0) h = 1;
    float ratio = (float)w / h;
    glViewport(0, 0, w, h);
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    gluPerspective(45, ratio, 1, 100);
    glMatrixMode(GL_MODELVIEW);
}

int main(int argc, char** argv) {
    glutInit(&argc, argv);
    glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGB | GLUT_DEPTH);
    glutInitWindowSize(800, 600);
    glutCreateWindow("Falling Water Particles");

    glEnable(GL_DEPTH_TEST);
    initLighting();
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    initBalls(); // initialize particles

    glutDisplayFunc(display);
    glutReshapeFunc(reshape);
    glutTimerFunc(0, update, 0);

    glutMainLoop();
    return 0;
}
