/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/* 
 * File:   Npc.cpp
 * Author: gordeev
 * 
 * Created on October 16, 2018, 5:05 PM
 */

#include "Npc.hpp"

Npc::Npc() {
    this->x =0;
    this->y =0;
    this->sprite =nullptr;
    this->cellH = 32;
    this->cellW = 32;
    this->sprite = IMG_Load("img/npc.png");
   if (this->sprite == nullptr) {
       DEBUG("can't load cellsprite!");
       DEBUG(IMG_GetError());
   }
   this->spriteTexture = nullptr;
   
}

Npc::Npc(const Npc& orig) {
  
}

Npc::~Npc() {
    if (this->sprite != nullptr) {
        SDL_FreeSurface(this->sprite);
    }
}

void Npc::SetY(float y) {
    this->y = y;
}

float Npc::GetY() const {
    return y;
}

void Npc::SetX(float x) {
    this->x = x;
}

float Npc::GetX() const {
    return x;
}

int Npc::Draw(Camera* cam, SDL_Surface* screen) {
    SDL_Rect dst;
    dst.h = this->cellH*cam->GetScale();
    dst.w = this->cellW*cam->GetScale();
    float screenCellSizeW = this->cellW*cam->GetScale();
    float screenCellSizeH = this->cellH*cam->GetScale();
    int startXIndex = (cam->GetX() / screenCellSizeW);
    int startXOffset = startXIndex - cam->GetX();
    int startYIndex = (cam->GetY() / screenCellSizeH);
    int startYOffset = startYIndex - cam->GetY();
            
    dst.x = x*screenCellSizeW + startXOffset;
    dst.y = y*screenCellSizeH + startYOffset;
    SDL_BlitScaled(this->sprite,nullptr,screen,&dst);
    
    return RET_OK;
}

int Npc::Draw(Camera* cam, SDL_Renderer* renderer,SDL_Surface* screen) {
     if (this->spriteTexture == nullptr) {
        this->spriteTexture = SDL_CreateTextureFromSurface(renderer,this->sprite);
        if (this->spriteTexture == nullptr) {
        DEBUG( "SDL could not convert sprite to texture! SDL_Error:");
        DEBUG( SDL_GetError() ); 
        return RET_ERR;
        }
    }
    SDL_Rect dst;
    dst.h = this->cellH*cam->GetScale();
    dst.w = this->cellW*cam->GetScale();
    float screenCellSizeW = this->cellW*cam->GetScale();
    float screenCellSizeH = this->cellH*cam->GetScale();
    int startXIndex = (cam->GetX() / screenCellSizeW);
    int startXOffset = startXIndex*screenCellSizeW;// - cam->GetX();
    int startYIndex = (cam->GetY() / screenCellSizeH);
    int startYOffset = startYIndex*screenCellSizeW;// - cam->GetY();
            
    dst.x = this->x - cam->GetX();// + startXOffset;
    dst.y = this->y - cam->GetY();// + startYOffset;
    //DEBUG("dst.x: "<<dst.x<<" dst.y: "<<dst.y<<" startXOffset: "<<cam->GetX() );
    //SDL_BlitScaled(this->sprite,nullptr,screen,&dst);
    SDL_RenderCopy(renderer,this->spriteTexture,nullptr,&dst);
    return RET_OK;
}

void Npc::SetSpeed(float speed) {
    this->speed = speed;
}

float Npc::GetSpeed() const {
    return speed;
}

int Npc::GetCellW() const {
    return cellW;
}

int Npc::GetCellH() const {
    return cellH;
}