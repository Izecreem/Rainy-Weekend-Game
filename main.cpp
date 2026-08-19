//This file just ties the game together, and makes the game loop

#include <raylib.h> //Includes the raylib module
#include "io.h" //Gets IO funcs
#include "player.h" //Gets player
#include "consts.h" 


//main function aka entry point
int main() {

    //Initalize window, FPS target and player
    InitWindow(SCRN_W, SCRN_H, "Rainy Weekend Game 1.00 :3");
    SetTargetFPS(60);
    Player player{
        .speed = 350.0f,
        .playerPos = {100, 100},
        .size = BLK_SIZE,
        .vx = 0.0f,
        .vy = 0.0f
    };

    //Main loop
    while (!WindowShouldClose()) {
        float dt = GetFrameTime();
        InputState input = getInput();

        BeginDrawing();
        ClearBackground(SYKYCOL);

        //Update and draw the player
        player.update(dt, input);

        EndDrawing();

    }

    CloseWindow();
    
    return 0;
}
