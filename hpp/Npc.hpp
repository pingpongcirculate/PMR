/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/* 
 * File:   Npc.hpp
 * Author: gordeev
 *
 * Created on October 16, 2018, 5:05 PM
 */

#ifndef NPC_HPP
#define NPC_HPP

#include <iostream>
#include <SDL2/SDL_image.h>
#include <SDL2/SDL_surface.h>
#include "./const.hpp"
#include "Camera.hpp"

class Npc {
public:
    Npc();
    Npc(const Npc& orig);
    virtual ~Npc();
    void SetY(float y);
    float GetY() const;
    void SetX(float x);
    float GetX() const;
    int Draw(Camera* cam,SDL_Surface* screen);
    int Draw(Camera* cam,SDL_Renderer* renderer,SDL_Surface* screen);
    void SetSpeed(float speed);
    float GetSpeed() const;
    int GetCellW() const;
    int GetCellH() const;
private:
    float x;
    float y;
    float speed;
    int cellH;
    int cellW;
    SDL_Surface* sprite;
    SDL_Texture* spriteTexture;
};

#endif /* NPC_HPP */

