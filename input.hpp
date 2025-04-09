#pragma once
#include <GLFW/glfw3.h>

void setup_input_callbacks(GLFWwindow* window);
bool is_mouse_down();
void get_mouse_pos(double& x, double& y);
