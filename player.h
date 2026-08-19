#ifndef PLAYER_H
#define PLAYER_H

#include "io.h"

inline constexpr float MAX_SPEED = 200.0f;

struct Player {
    float speed;
    Vector2 playerPos = {0, 0};
    int size;
    float vx;
    float vy;

    void _move(float dt, const InputState& input);
    void _render();
    void _gravity(float dt);
    void _friction(float dt);
    void update(float dt, const InputState& input);
};


#endif
