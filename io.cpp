//Handles IO

#include <raylib.h> //gets raylib

//Gets the currently pressed key from raylib and returns a char
char keypressed() {
    if (IsKeyDown(KEY_W)) {
        return 'W';
    }
    if (IsKeyDown(KEY_A)) {
        return 'A';
    }
    if (IsKeyDown(KEY_S)) {
        return 'S';
    }
    if (IsKeyDown(KEY_D)) {
        return 'D';
    }
    if (IsKeyDown(KEY_SPACE)) {
        return ' ';
    }

    return '#';
}

