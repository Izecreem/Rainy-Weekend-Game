//Main player file, handles player stuff
#include <raylib.h>
#include <algorithm>
#include "player.h"
#include "consts.h"

//Moves the player based on current input
void Player::_move(float dt, const InputState& input) {

    if (input.left && !(playerPos.x <= 0)) {
        vx -= speed * dt;
    }

    if (input.right && !(playerPos.x >= SCRN_W - size)) {
        vx += speed * dt;
    }

    if (input.jump && playerPos.y >= SCRN_H - size) {
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

//Updates friction
void Player::_friction(float dt) {
    const float frictionStep = FRICTION * dt;

    // Slow down toward zero without letting friction reverse direction.
    if (vx > 0.0f) {
        vx = std::max(0.0f, vx - frictionStep);
    } else if (vx < 0.0f) {
        vx = std::min(0.0f, vx + frictionStep);
    }

    playerPos.x += vx * dt;

    if (playerPos.x <= 0.0f) {
        playerPos.x = 0.0f;
        vx = 0.0f;
    } else if (playerPos.x >= SCRN_W - size) {
        playerPos.x = SCRN_W - size;
        vx = 0.0f;
    }
}

//Updates the player
void Player::update(float dt, const InputState& input) {
    _move(dt, input);
    _friction(dt);
    _gravity(dt);
    _render();
    return;
}
