/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/* 
 * File:   Map.cpp
 * Author: gordeev
 * 
 * Created on October 15, 2018, 4:59 PM
 */



#include "Map.hpp"

Map::Map() {
   
   this->levelMap = nullptr;
   this->spriteH = 128;
   this->spriteW = 128;
   this->cellH = 16;
   this->cellW = 16;
    
   this->cellSprite = nullptr;
   this->cellSprite = IMG_Load("img/img.png");
   if (this->cellSprite == nullptr) {
       DEBUG("can't load cellsprite!");
       DEBUG(IMG_GetError());
   }
   this->cellSpriteTexture = nullptr;
}

Map::Map(const Map& orig) {
}

Map::~Map() {
    if (this->cellSprite != nullptr) {
        SDL_FreeSurface(this->cellSprite);
    }
    
    if (this->levelMap != nullptr) {
        SDL_FreeSurface(this->levelMap);
    }
    
    if (this->cellSpriteTexture !=nullptr) {
        SDL_DestroyTexture(this->cellSpriteTexture);
    }
}

int Map::Draw(Camera* cam,SDL_Surface* screen) {
    SDL_Rect dst;
    dst.h = this->cellH*cam->GetScale();
    dst.w = this->cellW*cam->GetScale();
    //1st we need to calculate width and height of the viewport in sprites
    float screenCellSizeW = this->cellW*cam->GetScale();
    float screenCellSizeH = this->cellH*cam->GetScale();
    int VP_W = screen->w / screenCellSizeW;
    int VP_H = screen->h / screenCellSizeH;
    //2nd we need to calculate starting offset coords of render loop
    //in case we have tiles what are partially visible
    int startXIndex = (cam->GetX() / screenCellSizeW);
    int startXOffset = startXIndex*screenCellSizeW - cam->GetX();
    int startYIndex = (cam->GetY() / screenCellSizeH);
    int startYOffset = startYIndex*screenCellSizeH - cam->GetY();
    //DEBUG("startXIndex = " << startXIndex <<" VIEWPORT W = " << VP_W);
    //DEBUG("startYIndex = " << startYIndex << " VIEWPORT_H = " << VP_H);
    int x = 0;
    int y = 0;
    
    for (y=0; y<= VP_H; y++) {
        for (x=0; x <= VP_W; x++) {
            int SX = (x*screenCellSizeW) + startXOffset;
           // if (SX < 0 && abs(SX) > screenCellSizeW) {
           //     break; //we dont need to draw sprite if it is not show on screen
           // }
            int SY = (y*screenCellSizeH) + startYOffset;
           // if (SY < 0 && abs(SY) > screenCellSizeH) {
           //     break; //we dont need to draw sprite if it is not show on screen
           // }
            dst.x = SX;
            dst.y = SY;
            DEBUG("dst.x = " << dst.x <<" dst.y = " << dst.y << " x " << x << " y " << y << " startYoff "<<startYOffset << " startXoff "<<startXOffset );
            SDL_BlitScaled(this->cellSprite,nullptr,screen,&dst);
            
        }
    }
    
    return RET_OK;
}

int Map::Draw(Camera* cam, SDL_Renderer* renderer,SDL_Surface* screen) {
    if (this->cellSpriteTexture == nullptr) {
        this->cellSpriteTexture = SDL_CreateTextureFromSurface(renderer,this->cellSprite);
        if (this->cellSpriteTexture == nullptr) {
        DEBUG( "SDL could not convert sprite to texture! SDL_Error:");
        DEBUG( SDL_GetError() ); 
        return RET_ERR;
        }
    }
    SDL_Rect dst;
    SDL_Rect src;
    dst.h = this->cellH*cam->GetScale();
    dst.w = this->cellW*cam->GetScale();
    src.h = this->spriteH;
    src.w = this->spriteW;
    
    src.x = this->spriteW;
    src.y = 0;
    //1st we need to calculate width and height of the viewport in sprites
    float screenCellSizeW = this->cellW*cam->GetScale();
    float screenCellSizeH = this->cellH*cam->GetScale();
    int VP_W = screen->w / screenCellSizeW;
    int VP_H = screen->h / screenCellSizeH;
    //2nd we need to calculate starting offset coords of render loop
    //in case we have tiles what are partially visible
    int startXIndex = (cam->GetX() / screenCellSizeW);
    int startXOffset = startXIndex*screenCellSizeW - cam->GetX();
    int startYIndex = (cam->GetY() / screenCellSizeH);
    int startYOffset = startYIndex*screenCellSizeH - cam->GetY();
    //DEBUG("startXIndex = " << startXIndex <<" VIEWPORT W = " << VP_W);
    //DEBUG("startYIndex = " << startYIndex << " VIEWPORT_H = " << VP_H);
    int x = 0;
    int y = 0;
    
    for (y=0; y<= VP_H+1; y++) {
        for (x=0; x <= VP_W+1; x++) {
            Uint8 mapPoint[4] = {0,0,0,0};
            Uint32 pixel = this->GetPixel(this->levelMap,startXIndex+x,startYIndex+y);
            SDL_GetRGB(pixel,this->levelMap->format,&mapPoint[0],&mapPoint[1],&mapPoint[2]);
           
                mapPoint[0] = 0;
                
            if (mapPoint[1] == 1) {
                mapPoint[1] = 1;
                mapPoint[0] = 0;
            } else {
                mapPoint[1] = 0;
            }
            
            src.x = this->spriteW * mapPoint[1];
            src.y = this->spriteH * mapPoint[0];
            
            int SX = (x*screenCellSizeW) + startXOffset;
            if (SX < 0 && abs(SX) > screenCellSizeW) {
                break; //we dont need to draw sprite if it is not show on screen
            }
            int SY = (y*screenCellSizeH) + startYOffset;
            if (SY < 0 && abs(SY) > screenCellSizeH) {
                break; //we dont need to draw sprite if it is not show on screen
            }
            dst.x = SX;
            dst.y = SY;
            //DEBUG("dst.x = " << dst.x <<" dst.y = " << dst.y << " x " << x << " y " << y << " startYoff "<<startYOffset << " startXoff "<<startXOffset );
            SDL_RenderCopy(renderer,this->cellSpriteTexture,&src,&dst);
       
            
        }
    }
    
    return RET_OK;
}

int Map::LoadMap(std::string fname) {
    this->levelMap = IMG_Load(fname.c_str());
    if (this->levelMap == nullptr) {
       DEBUG("can't load levelMap!");
       DEBUG(IMG_GetError());
       return RET_ERR;
   }
    return RET_OK;
}

Uint32 Map::GetPixel(SDL_Surface *surf, int x, int y)
{
//This function returns pixels color
int bpp = surf->format->BytesPerPixel;
Uint8 *p = (Uint8 *)surf->pixels + y * surf->pitch + x * bpp;

    switch (bpp)
    {
            case 1:
                    return *p;

            case 2:
                    return *(Uint16 *)p;

            case 3:
                    if (SDL_BYTEORDER == SDL_BIG_ENDIAN)
                            return p[0] << 16 | p[1] << 8 | p[2];
                    else
                            return p[0] | p[1] << 8 | p[2] << 16;

            case 4:
                    return *(Uint32 *)p;

            default:
                    return 0;
    }

}

int Map::GetMapH() const {
    return this->levelMap->h;
}

int Map::GetCellW() const {
    return cellW;
}

int Map::GetCellH() const {
    return cellH;
}

int Map::GetMapW() const {
    return this->levelMap->w;
}

/*
 * return 0 if no collisioin
 * return 1 if collisin with map
 */
int Map::ColisionCheck(int x, int y, int w, int h) {
    if (x < 0) { return 2;}
    if (y < 0) {return 2;}
    if (h < 0) {return 2;}
    if (w < 0) {return 2;}
    if (this->levelMap->w < x) {return 2;}
    if (this->levelMap->h < y) {return 2;}
    if (this->levelMap->w < x+w) {return 2;}
    if (this->levelMap->h < y+h) {return 2;}
            Uint8 mapPoint[4] = {0,0,0,0};
           // DEBUG("CHECKING: "<<x<< " "<< y<<" "<<w<<" "<<h);
            for (int width = 0; width<w; width++) {
              Uint32 pixel = this->GetPixel(this->levelMap,x+width,y);
            SDL_GetRGB(pixel,this->levelMap->format,&mapPoint[0],&mapPoint[1],&mapPoint[2]);
            if (mapPoint[0] !=255 && mapPoint[1] != 255) {
                return 1;
            }
            }
            
            for (int width = 0; width<w; width++) {
              Uint32 pixel = this->GetPixel(this->levelMap,x+width,y+h);
            SDL_GetRGB(pixel,this->levelMap->format,&mapPoint[0],&mapPoint[1],&mapPoint[2]);
            if (mapPoint[0] !=255 && mapPoint[1] != 255) {
                return 1;
            }
            }
            
            for (int height = 0; height<h; height++) {
              Uint32 pixel = this->GetPixel(this->levelMap,x,y+height);
            SDL_GetRGB(pixel,this->levelMap->format,&mapPoint[0],&mapPoint[1],&mapPoint[2]);
            if (mapPoint[0] !=255 && mapPoint[1] != 255) {
                return 1;
            }
            }
            
            for (int height = 0; height<h; height++) {
              Uint32 pixel = this->GetPixel(this->levelMap,x+w,y+height);
            SDL_GetRGB(pixel,this->levelMap->format,&mapPoint[0],&mapPoint[1],&mapPoint[2]);
            if (mapPoint[0] !=255 && mapPoint[1] != 255) {
                return 1;
            }
            }
            return 0;
}
