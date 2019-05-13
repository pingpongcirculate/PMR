/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/* 
 * File:   Img.hpp
 * Author: banionis
 *
 * Created on 7 ноября 2018 г., 14:59
 */

#ifndef IMG_HPP
#define IMG_HPP

#include <iostream>
#include <SDL2/SDL_image.h>
#include <SDL2/SDL_surface.h>
#include "./const.hpp"
#include "Camera.hpp"

class Img {
public:
    Img();
    Img(const Img& orig);
    virtual ~Img();
    int LoadImg(const char* fname);
    int Draw(Camera* cam,SDL_Renderer* renderer,SDL_Surface* screen);
    int SetAlpha(int nAlpha);
    int SetPos(int X, int Y);
    int SetDimensions(int W, int H);
    void SetID(int ID);
    int GetID() const;
    void SetHiden(bool hiden);
    bool IsHiden() const;
    void SetAngle(double angle);
    double GetAngle() const;
private:
    int X;
    int Y;
    int W;
    int H;
    int ID;
    int Alpha;
    bool hiden;
    double angle;
    SDL_Surface* imgOrig;
    SDL_Texture* imgTexture;
};

#endif /* IMG_HPP */

