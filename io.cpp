//Handles IO

#include <raylib.h> //gets raylib

#include "io.h"

// Gets every currently held movement key, not just the first one found.
InputState getInput() {
    return {
        .left = IsKeyDown(KEY_A),
        .right = IsKeyDown(KEY_D),
        .jump = IsKeyDown(KEY_SPACE) || IsKeyDown(KEY_W)
    };
}
