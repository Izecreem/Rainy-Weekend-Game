//Main player file, handles player stuff
#include <raylib.h>
#include "player.h"
#include "consts.h"

//Moves the player based on current input
void Player::_move(float dt, char key) {

    if (key == 'A' && !(playerPos.x <= 0)) {
        playerPos.x -= speed * dt;
    }

    if (key == 'D' && !(playerPos.x >= SCRN_W - size)) {
        playerPos.x += speed * dt;
    }

    if (key == ' ' && playerPos.y >= SCRN_H - size) {
        vy = -150.0f;
    }
    
    return;
}

//Render the player
void Player::_render() {
    DrawRectangle(playerPos.x, playerPos.y, size, size, RED);
}

//Updates Gravity
void Player::_gravity(float dt) {
    vy += GRAVITY * dt;
    playerPos.y += vy * dt;

    if (playerPos.y >= SCRN_H - size) {
        playerPos.y = SCRN_H - size;
        vy = 0.0f;
    }
}

//Updates the player
void Player::update(float dt, char key) {
    _move(dt, key);
    _gravity(dt);
    _render();
    return;
}

