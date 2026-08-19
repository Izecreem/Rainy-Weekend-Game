#ifndef PLAYER_H
#define PLAYER_H

struct Player {
    float speed;
    Vector2 playerPos = {0, 0};
    int size;
    float vy;

    void _move(float dt, char key);
    void _render();
    void _gravity(float dt);
    void update(float dt, char key);
};


#endif