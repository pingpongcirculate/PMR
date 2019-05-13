/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/* 
 * File:   Img.cpp
 * Author: banionis
 * 
 * Created on 7 ноября 2018 г., 14:59
 */

#include <cstddef>

#include "Img.hpp"
#include "const.hpp"
#include "Camera.hpp"

Img::Img() {
    this->X = 0;
    this->Y = 0;
    this->W = 0;
    this->H = 0;
    this->ID = 0;
    this->Alpha = 255;
    this->angle = 0;
    this->imgOrig = nullptr;
    this->hiden = true;
    this->imgTexture = nullptr;
}

Img::Img(const Img& orig) {
}

Img::~Img() {
    if (this->imgTexture !=nullptr) {
        SDL_DestroyTexture(this->imgTexture);
    }
    if (this->imgOrig != nullptr) {
        SDL_FreeSurface(this->imgOrig);
    }
}

int Img::SetAlpha(int nAlpha) {
  if (nAlpha < 0) { nAlpha = 0; }
  if (nAlpha > 255) {nAlpha = 255;}
  this->Alpha = nAlpha;
   //DEBUG("SET ALPHA ENTERED! "<<nAlpha);
  if (this->imgTexture !=nullptr) {
        SDL_SetTextureAlphaMod(this->imgTexture,nAlpha);
        //DEBUG("SET ALPHA CALLED! "<<nAlpha);
  } else {
      return RET_ERR;
  }
  return RET_OK;
}

int Img::SetPos(int X, int Y) {
    this->X = X;
    this->Y = Y;
    return RET_OK;
}

int Img::SetDimensions(int W, int H) {
    this->W = W;
    this->H = H;
    return RET_OK;
}

void Img::SetID(int ID) {
    this->ID = ID;
}

int Img::GetID() const {
    return ID;
}

void Img::SetHiden(bool hiden) {
    this->hiden = hiden;
}

bool Img::IsHiden() const {
    return hiden;
}

void Img::SetAngle(double angle) {
    this->angle = angle;
}

double Img::GetAngle() const {
    return angle;
}


int Img::Draw(Camera* cam, SDL_Renderer* renderer, SDL_Surface* screen) {
    if (this->hiden) { return RET_OK; }
    SDL_Rect dst;
    if (this->imgOrig != nullptr) {
        if (this->imgTexture == nullptr) {
            this->imgTexture = SDL_CreateTextureFromSurface(renderer,this->imgOrig);
        if (this->imgTexture == nullptr) {
        DEBUG( "SDL could not convert sprite to texture! SDL_Error:");
        DEBUG( SDL_GetError() ); 
        return RET_ERR;
        }
            SDL_SetTextureBlendMode(this->imgTexture,SDL_BLENDMODE_BLEND);
           if (SDL_SetTextureAlphaMod(this->imgTexture,this->Alpha) != 0) {
               DEBUG("CANT SET ALPHA FOR TEXTURE! "<< SDL_GetError());
           } ;
        }
        
        dst.x = this->X;
        dst.y = this->Y;
        dst.w = this->W;
        dst.h = this->H;
    SDL_RenderCopyEx(renderer,this->imgTexture,nullptr,&dst,this->angle,NULL,SDL_FLIP_NONE);    
    
    }
    return RET_OK;
}

int Img::LoadImg(const char* fname) {
     this->imgOrig = IMG_Load(fname);
    if (this->imgOrig == nullptr ) {
         DEBUG("Unable to convert image "<< fname <<" to texture! SDL ERROR: "<<IMG_GetError()<<"\n");
         return RET_ERR;
    }
  
    return RET_OK;
}
