#ifndef IO_H
#define IO_H

struct InputState {
    bool left;
    bool right;
    bool jump;
};

// Gets all currently held movement keys.
InputState getInput();

#endif
