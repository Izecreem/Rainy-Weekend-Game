//Used for the blocks n stuff

#include <raylib.h>
#include "blocks.h"
#include "consts.h"

void Block::render() {
    DrawRectangle(blockPos.x, blockPos.y, BLK_SIZE, BLK_SIZE, color);
}
