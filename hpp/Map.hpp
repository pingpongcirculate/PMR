/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/* 
 * File:   Map.hpp
 * Author: gordeev
 *
 * Created on October 15, 2018, 4:59 PM
 */

#ifndef MAP_HPP
#define MAP_HPP

#include <iostream>
#include <SDL2/SDL_image.h>
#include <SDL2/SDL_surface.h>
#include "./const.hpp"
#include "Camera.hpp"


class Map {
public:
    Map();
    Map(const Map& orig);
    virtual ~Map();
    int Draw(Camera* cam,SDL_Surface* screen);
    int Draw(Camera* cam,SDL_Renderer* renderer,SDL_Surface* screen);
    Uint32 GetPixel(SDL_Surface *surface, int x, int y);
    int ColisionCheck(int x, int y, int w, int h);
    int LoadMap(std::string fname);
    int GetMapW() const;
    int GetMapH() const;
    int GetCellW() const;
    int GetCellH() const;
private:
    SDL_Surface* cellSprite;
    SDL_Surface* levelMap;
    SDL_Texture* cellSpriteTexture;
    int cellH;
    int cellW;
    int spriteH;
    int spriteW;
};

#endif /* MAP_HPP */

