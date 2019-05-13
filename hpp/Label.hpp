/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/* 
 * File:   Label.hpp
 * Author: banionis
 *
 * Created on 10 ноября 2018 г., 2:47
 */

#ifndef LABEL_HPP
#define LABEL_HPP

#include "SDL2/SDL.h"
#include "SDL2/SDL_ttf.h"
#include <string>
#include <iostream>
#include <vector>
#include "Camera.hpp"

class Label {
public:
    Label();
    Label(const Label& orig);
    virtual ~Label();
    void setText(const char *txt);
    int loadFont(const char *fontPath,int size);
    int setColor(int R,int G,int B);
    int Draw(Camera* cam,SDL_Renderer* renderer,SDL_Surface* screen);
    void setID(int ID);
    int getID() const;
    void setH(int H);
    int getH() const;
    void setW(int W);
    int getW() const;
    void setY(int Y);
    int getY() const;
    void setX(int X);
    int getX() const;
    void setHiden(bool hiden);
    bool isHiden() const;
    void setText(std::string text);
private:
    void split(const std::string &s, char delim, std::vector<std::string> &elems);
    std::string text;
    TTF_Font *font;
    SDL_Color color;
    SDL_Texture *cacheTexture;
    bool hiden;
    int X;
    int Y;
    int W;
    int H;
    int ID;
};

#endif /* LABEL_HPP */

