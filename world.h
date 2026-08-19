#ifndef WORLD_H
#define WORLD_H

struct World {
    Block world[(SCRN_W / BLK_SIZE)][(SCRN_H / BLK_SIZE)];

    void update(float dt);
};

#endif WORLD_H