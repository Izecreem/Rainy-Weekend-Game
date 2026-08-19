#ifndef WORLD_H
#define WORLD_H

//Main world struct
struct World {
    Block world[(SCRN_W / BLK_SIZE)][(SCRN_H / BLK_SIZE)];

    void update(float dt);
    void gen_terrain();
};

#endif WORLD_H