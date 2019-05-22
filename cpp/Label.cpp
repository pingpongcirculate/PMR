/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/* 
 * File:   Label.cpp
 * Author: banionis
 * 
 * Created on 10 ноября 2018 г., 2:47
 */

#include "Label.hpp"
#include "const.hpp"

Label::Label() {
    this->font = nullptr;
    this->cacheTexture = nullptr;
    this->H = 0;
    this->ID = 0;
    this->X = 0;
    this->Y = 0;
    this->hiden = false;
    this->text = "";
    this->color.a = 255;
    this->color.r = 0;
    this->color.g = 0;
    this->color.b = 0;
    this->W = 0;
}

void Label::setID(int ID) {
    this->ID = ID;
}

int Label::getID() const {
    return ID;
}

void Label::setH(int H) {
    this->H = H;
}

int Label::getH() const {
    return H;
}

void Label::setW(int W) {
    this->W = W;
}

int Label::getW() const {
    return W;
}

void Label::setY(int Y) {
    this->Y = Y;
}

int Label::getY() const {
    return Y;
}

void Label::setX(int X) {
    this->X = X;
}

int Label::getX() const {
    return X;
}

void Label::setHiden(bool hiden) {
    this->hiden = hiden;
}

bool Label::isHiden() const {
    return this->hiden;
}

void Label::setText(std::string text) {
    this->text = text;
     if (this->cacheTexture != nullptr) {
       SDL_DestroyTexture(this->cacheTexture);
       this->cacheTexture = nullptr;
   }
}

void Label::setText(const char *txt) {
    this->text.assign(txt);
    if (this->cacheTexture != nullptr) {
       SDL_DestroyTexture(this->cacheTexture);
       this->cacheTexture = nullptr;
   }
    
};

Label::Label(const Label& orig) {
}

Label::~Label() {
   if (this->font != nullptr) {
        TTF_CloseFont(this->font);
    }
   
   if (this->cacheTexture != nullptr) {
       SDL_DestroyTexture(this->cacheTexture);
   }
}

int Label::setColor(int R, int G, int B) {
    this->color.b = B;
    this->color.r = R;
    this->color.g = G;
    this->color.a = 255;
    return RET_OK;
}

int Label::loadFont(const char* fontPath, int size) {
if (this->font != nullptr) {
        TTF_CloseFont(this->font);
    }    
this->font = TTF_OpenFont(fontPath,size);
    if( this->font == NULL )
    {
        printf( "Failed to load font! SDL_ttf Error: %s\n", TTF_GetError() );
        return RET_ERR;
    }
    return RET_OK;
}

void Label::split(const std::string& s, char delim, std::vector<std::string>& elems) {
    std::string temps;
    temps.assign(s);
    size_t pos = 0;
    std::string token;
    while ((pos = temps.find(delim)) != std::string::npos) {
    token = temps.substr(0, pos);
    elems.push_back(token);
    temps.erase(0, pos + sizeof(char));
    }
}


int Label::Draw(Camera* cam, SDL_Renderer* renderer, SDL_Surface* screen) {
    if (this->isHiden()) {
        return RET_OK;
    }
    
    SDL_Rect dstRect;
    
    if ( this->cacheTexture == nullptr ) {
    
    int w = 0;
    int h = 0;
    dstRect.x = 0;
    dstRect.y = 0;
    dstRect.w = 0;
    dstRect.h = 0;
    this->W = 0;
    this->H = 0;
    std::vector <std::string> elems;
    SDL_Surface *surface = NULL;
    SDL_Texture *tempTexture = NULL;
    SDL_Texture *oldrenderTarget = NULL;
    //WEAK POINT. MUST OPTIMIZE HERE
    this->split(this->text,'\n',elems); //get our strings into vector
    for (std::vector <std::string>::iterator it = elems.begin(); it != elems.end(); ++it) {
    TTF_SizeUTF8(this->font,it->c_str(),&w,&h);
        //we should calculate complete w and h
        if (this->W < w) { this->W = w; }
        this->H = this->H + h;
    } //calculate width and height
    
    this->cacheTexture = SDL_CreateTexture(renderer,SDL_PIXELFORMAT_RGBA8888, SDL_TEXTUREACCESS_TARGET,this->W,this->H);
    if (this->cacheTexture == NULL ) {
        printf( "Failed to create cache texture! SDL_Error: %s\n", SDL_GetError() );
        return RET_ERR;
    }
    SDL_SetTextureBlendMode(this->cacheTexture,SDL_BLENDMODE_BLEND);
    
    //DEBUG("CACHE COMPUTED: W: "<<this->W<<" H: "<<this->H<<" ME ID: "<<this->ID);
    oldrenderTarget = SDL_GetRenderTarget(renderer);
    if (SDL_SetRenderTarget(renderer,this->cacheTexture) != 0 ) {
        printf( "Failed to create cache texture! SDL_Error: %s\n", SDL_GetError() );
        return RET_ERR;
    };
    SDL_RenderClear(renderer);
    for (std::vector <std::string>::iterator it = elems.begin(); it != elems.end(); ++it) {
    if (TTF_SizeUTF8(this->font,it->c_str(),&w,&h)) {
        printf( "Failed to calculate message metrics! SDL_ttf Error: %s\n", TTF_GetError() );
        return RET_ERR;
    } else {
        dstRect.w = w;
        dstRect.h = h;
    }
    
    surface = TTF_RenderUTF8_Solid(this->font,it->c_str(),this->color);
    tempTexture = SDL_CreateTextureFromSurface(renderer,surface);
    SDL_RenderCopy(renderer,tempTexture,NULL,&dstRect);
    SDL_FreeSurface(surface);
    SDL_DestroyTexture(tempTexture);    
    dstRect.y = dstRect.y + dstRect.h;
        } 
    SDL_SetRenderTarget(renderer,oldrenderTarget);
    } //multyline text draw loop 
    
    dstRect.x = this->getX();
    dstRect.y = this->getY();
    dstRect.w = this->W;
    dstRect.h = this->H;
    SDL_RenderCopy(renderer,this->cacheTexture,NULL,&dstRect);
    return RET_OK;
}
