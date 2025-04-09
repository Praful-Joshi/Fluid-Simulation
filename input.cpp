#include <GLFW/glfw3.h>
#include "input.hpp"

static double mouseX, mouseY;
static bool mouseDown = false;

void mouse_button_callback(GLFWwindow* window, int button, int action, int mods) {
    if (button == GLFW_MOUSE_BUTTON_LEFT)
        mouseDown = (action == GLFW_PRESS || action == GLFW_REPEAT);
}

void cursor_position_callback(GLFWwindow* window, double xpos, double ypos) {
    mouseX = xpos;
    mouseY = ypos;
}

void setup_input_callbacks(GLFWwindow* window) {
    glfwSetMouseButtonCallback(window, mouse_button_callback);
    glfwSetCursorPosCallback(window, cursor_position_callback);
}

bool is_mouse_down() {
    return mouseDown;
}

void get_mouse_pos(double& x, double& y) {
    x = mouseX;
    y = mouseY;
}
