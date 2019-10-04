/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/* 
 * File:   App.cpp
 * Author: gordeev
 * 
 * Created on October 15, 2018, 12:32 PM
 */



#include <cmath>

#include "App.hpp"

App::App() {
    DEBUG("contructor called");
    this->window = nullptr;
    this->renderer = nullptr;
    this->luaState = nullptr;
    this->luaScriptFileName = "lua/main.lua";
    this->cameraSpd = 3;
    this->activeMap = nullptr;
    this->camera = new (Camera);
    this->player = nullptr;
   
}

App::App(const App& orig) {
}

App::~App() {
   
   if (this->camera != nullptr) {
    delete(this->camera); 
   }
    this->ClearObjects();
    if (this->wSurface != nullptr) {
        SDL_FreeSurface(this->wSurface);
    }
    
    if (this->wTexture != nullptr) {
        SDL_DestroyTexture(this->wTexture);
    }
  if (this->renderer != nullptr) {
        SDL_DestroyRenderer(this->renderer);
    }
    if (this->window != nullptr) {
     SDL_DestroyWindow( this->window );
    }
    
     TTF_Quit();
     IMG_Quit();
     SDL_Quit();
     DEBUG("destructor called");
          
}

int App::AppInit() {
    
     //LOAD Window size values from ini
    CSimpleIniA ini;
    SI_Error rc;
    
    this->windowH = SCREEN_WIDTH;
    this->windowH = SCREEN_HEIGHT;
    
    FILE *fp = fopen(INIFILENAME,"a+"); //hack to avoid "no file exists" possibylity 
    fclose(fp);
    ini.SetUnicode(true);
    rc = ini.LoadFile(INIFILENAME);
    if (rc < 0) {
    this->windowH = SCREEN_WIDTH;
    this->windowH = SCREEN_HEIGHT;
    DEBUG( "cant find initial parameters");
    } else {
     this->windowW = ini.GetLongValue("video","width",SCREEN_WIDTH);
     this->windowH = ini.GetLongValue("video","height",SCREEN_HEIGHT);
    }
    
    //Initialize SDL 
    if( SDL_Init( SDL_INIT_EVERYTHING ) < 0 ) { 
        DEBUG( "SDL could not initialize! SDL_Error:");
        DEBUG( SDL_GetError() ); 
        return RET_ERR;
    }
    
    //Initialize IMG loading 
    int imgFlags = IMG_INIT_ALL; 
    if( !( IMG_Init( imgFlags ) & imgFlags ) ) { 
        DEBUG( "SDL_image could not initialize! SDL_image Error:");
        DEBUG( IMG_GetError() ); 
        return RET_ERR; 
    }
    
    this->window = SDL_CreateWindow( APP_TITLE, SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, this->windowW, this->windowH, SDL_WINDOW_SHOWN );
    if (this->window == nullptr) {
        DEBUG("cant create main SDL window");
        return RET_ERR;
    }
    
    this->renderer = SDL_CreateRenderer(this->window,-1,SDL_RENDERER_ACCELERATED|SDL_RENDERER_PRESENTVSYNC );
    if (this->renderer == nullptr) {
        DEBUG("cant create renderer");
        return RET_ERR;
    }
    
    this->wSurface = SDL_GetWindowSurface(this->window);
    this->wTexture = SDL_CreateTextureFromSurface(this->renderer,this->wSurface);

      //Initialize SDL_ttf
    if( TTF_Init() == -1 ) {
        DEBUG( "SDL_ttf could not initialize! SDL_ttf Error: "<< TTF_GetError() );
        return RET_ERR;
    }
    
    return RET_OK;
}



void App::ClearObjects() {
    if (this->activeMap != nullptr) { 
    delete(this->activeMap); 
    this->activeMap = nullptr;
   }
   if (this->player != nullptr) {
    delete(this->player);
    this->player = nullptr;
   }
  for (std::vector<Img *>::iterator it = this->imgList.begin(); it != this->imgList.end();) {
         delete *it;
         this->imgList.erase(it);
     }
  
  for (std::vector<Label *>::iterator it = this->labelList.begin(); it != this->labelList.end();) {
         delete *it;
         this->labelList.erase(it);
     }
}

void App::SetLuaState(lua_State* luaState) {
    this->luaState = luaState;
}

lua_State* App::GetLuaState() const {
    return luaState;
}

void App::SetExec_new_file(bool exec_new_file) {
    DEBUG("execution flag setted!");
    this->exec_new_file = exec_new_file;
}

bool App::IsExec_new_file() const {
    return exec_new_file;
}

void App::SetLuaScriptFileName(std::string luaScriptFileName) {
    this->luaScriptFileName = luaScriptFileName;
}

std::string App::GetLuaScriptFileName() const {
    return luaScriptFileName;
}

void App::SetExecLuaFileFunc(void (F)()) {
    this->execLuaFileFunc = F;
}

int App::LUA_CreateLabel(lua_State* L) {
     int argnum = lua_gettop(L);
    if (argnum < 9) {
        lua_pushstring(L,"Not enought arguments for CreateLabel");
        lua_pushnumber(L,1);
        lua_error(L);
        return RET_ERR;
    }
     
 Label *back = new Label();
 back->loadFont(luaL_checkstring(L,1),luaL_checkinteger(L,2));
 back->setColor(luaL_checkinteger(L,3),luaL_checkinteger(L,4),luaL_checkinteger(L,5));
 back->setX(luaL_checkinteger(L,6));
 back->setY(luaL_checkinteger(L,7));
 back->setText(luaL_checkstring(L,8));
 back->setID(luaL_checkinteger(L,9));
 back->setHiden(false);
 this->labelList.push_back(back);
 lua_pushnumber(L,0);
 return RET_OK;
}

int App::LUA_DelLabel(lua_State* L) {
 int argnum = lua_gettop(L);
    if (argnum < 1) {
        lua_pushstring(L,"Not enought arguments for DelLabel");
        lua_pushnumber(L,1);
        lua_error(L);
        return RET_ERR;
    }
    int OBJID = luaL_checkinteger(L,1);
    std::vector<Label  *>::iterator LabelObj = 
            std::find_if(this->labelList.begin(),this->labelList.end(),
            [&OBJID](Label *obj){ return obj->getID() == OBJID; });
            delete *LabelObj;
            this->labelList.erase(LabelObj);
            return RET_OK;
}

int App::LUA_HideLabel(lua_State* L) {
    int argnum = lua_gettop(L);
    if (argnum < 1) {
        lua_pushstring(L,"Not enought arguments for HideLabel");
        lua_pushnumber(L,1);
        lua_error(L);
        return RET_ERR;
    }
    int OBJID = luaL_checkinteger(L,1);
    std::vector<Label  *>::iterator LabelObj = 
            std::find_if(this->labelList.begin(),this->labelList.end(),
            [&OBJID](Label *obj){ return obj->getID() == OBJID; });
            (*LabelObj)->setHiden(true);
            return RET_OK;
}

int App::LUA_UnHideLabel(lua_State* L) {
    int argnum = lua_gettop(L);
    if (argnum < 1) {
        lua_pushstring(L,"Not enought arguments for unHideLabel");
        lua_pushnumber(L,1);
        lua_error(L);
        return RET_ERR;
    }
    int OBJID = luaL_checkinteger(L,1);
    std::vector<Label  *>::iterator LabelObj = 
            std::find_if(this->labelList.begin(),this->labelList.end(),
            [&OBJID](Label *obj){ return obj->getID() == OBJID; });
            (*LabelObj)->setHiden(false);
            return RET_OK;

}



int App::LUA_SetLabelText(lua_State* L) {
    int argnum = lua_gettop(L);
    if (argnum < 2) {
        lua_pushstring(L,"Not enought arguments for SetLabelText");
        lua_pushnumber(L,1);
        lua_error(L);
        return RET_ERR;
    }
    int OBJID = luaL_checkinteger(L,1);
    std::vector<Label  *>::iterator LabelObj = 
            std::find_if(this->labelList.begin(),this->labelList.end(),
            [&OBJID](Label *obj){ return obj->getID() == OBJID; });
            (*LabelObj)->setText(luaL_checkstring(L,2));
    return RET_OK;
}

void App::SetWindowW(int windowW) {
    this->windowW = windowW;
}

int App::GetWindowW() const {
    return windowW;
}

void App::SetWindowH(int windowH) {
    this->windowH = windowH;
}

int App::GetWindowH() const {
    return windowH;
}


int App::LUA_SetLabelPos(lua_State* L) {
    int argnum = lua_gettop(L);
    if (argnum < 3) {
        lua_pushstring(L,"Not enought arguments for SetLabelPos");
        lua_pushnumber(L,1);
        lua_error(L);
        return RET_ERR;
    }
    int OBJID = luaL_checkinteger(L,1);
    std::vector<Label  *>::iterator LabelObj = 
            std::find_if(this->labelList.begin(),this->labelList.end(),
            [&OBJID](Label *obj){ return obj->getID() == OBJID; });
            (*LabelObj)->setX(luaL_checkinteger(L,2));
            (*LabelObj)->setY(luaL_checkinteger(L,3));
            return RET_OK;
}

int App::LUA_LoadImg(lua_State* L) {
 int argnum = lua_gettop(L);
    if (argnum < 7) {
        lua_pushstring(L,"Not enought arguments for LoadImage");
        lua_pushnumber(L,1);
        lua_error(L);
        return RET_ERR;
    }
 
    Img *back = new Img();
    this->imgList.push_back(back);
    back->LoadImg(luaL_checkstring(L,1));
    back->SetPos(luaL_checkinteger(L,2),luaL_checkinteger(L,3) );
    back->SetDimensions(luaL_checkinteger(L,4),luaL_checkinteger(L,5));
    back->SetAlpha(luaL_checkinteger(L,6));
    back->SetID(luaL_checkinteger(L,7));
    back->SetHiden(false);
    lua_pushnumber(L,0);
    return RET_OK;
}

int App::LUA_DelImg(lua_State* L) {
 int argnum = lua_gettop(L);
    if (argnum < 1) {
        lua_pushstring(L,"Not enought arguments for DelImg");
        lua_pushnumber(L,1);
        lua_error(L);
        return RET_ERR;
    }
    int OBJID = luaL_checkinteger(L,1);
    std::vector<Img  *>::iterator ImgObj = 
            std::find_if(this->imgList.begin(),this->imgList.end(),
            [&OBJID](Img *obj){ return obj->GetID() == OBJID; });
            delete *ImgObj;
            this->imgList.erase(ImgObj);
            return RET_OK;
}

int App::LUA_SetImgAlpha(lua_State* L) {
 int argnum = lua_gettop(L);
    if (argnum < 2) {
        lua_pushstring(L,"Not enought arguments for SetImgAlpha");
        lua_pushnumber(L,1);
        lua_error(L);
        return RET_ERR;
    }
    int OBJID = luaL_checkinteger(L,1);
    std::vector<Img  *>::iterator ImgObj = 
            std::find_if(this->imgList.begin(),this->imgList.end(),
            [&OBJID](Img *obj){ return obj->GetID() == OBJID; });
            (*ImgObj)->SetAlpha(luaL_checkinteger(L,2));
            return RET_OK;
}

int App::LUA_SetImgRotation(lua_State* L) {
 int argnum = lua_gettop(L);
    if (argnum < 2) {
        lua_pushstring(L,"Not enought arguments for SetImgRotation");
        lua_pushnumber(L,1);
        lua_error(L);
        return RET_ERR;
    }
    int OBJID = luaL_checkinteger(L,1);
    std::vector<Img  *>::iterator ImgObj = 
            std::find_if(this->imgList.begin(),this->imgList.end(),
            [&OBJID](Img *obj){ return obj->GetID() == OBJID; });
            (*ImgObj)->SetAngle(lua_tonumber(L,2));
            return RET_OK;
}


int App::LUA_SetImgPos(lua_State* L) {
 int argnum = lua_gettop(L);
    if (argnum < 3) {
        lua_pushstring(L,"Not enought arguments for SetImgPos");
        lua_pushnumber(L,1);
        lua_error(L);
        return RET_ERR;
    }
    int OBJID = luaL_checkinteger(L,1);
    std::vector<Img  *>::iterator ImgObj = 
            std::find_if(this->imgList.begin(),this->imgList.end(),
            [&OBJID](Img *obj){ return obj->GetID() == OBJID; });
            (*ImgObj)->SetPos(luaL_checkinteger(L,2),luaL_checkinteger(L,3));
            return RET_OK;
}

int App::LUA_SetImgDimensions(lua_State* L) {
 int argnum = lua_gettop(L);
    if (argnum < 3) {
        lua_pushstring(L,"Not enought arguments for SetImgDimensions");
        lua_pushnumber(L,1);
        lua_error(L);
        return RET_ERR;
    }
    int OBJID = luaL_checkinteger(L,1);
    std::vector<Img  *>::iterator ImgObj = 
            std::find_if(this->imgList.begin(),this->imgList.end(),
            [&OBJID](Img *obj){ return obj->GetID() == OBJID; });
            (*ImgObj)->SetDimensions(luaL_checkinteger(L,2),luaL_checkinteger(L,3));
            return RET_OK;
}

int App::LUA_SendImgToFront(lua_State* L) {
int argnum = lua_gettop(L);
    if (argnum < 1) {
        lua_pushstring(L,"Not enought arguments for SendImgToFront");
        lua_pushnumber(L,1);
        lua_error(L);
        return RET_ERR;
    }
    int OBJID = luaL_checkinteger(L,1);
    std::vector<Img  *>::iterator ImgObj = 
            std::find_if(this->imgList.begin(),this->imgList.end(),
            [&OBJID](Img *obj){ return obj->GetID() == OBJID; });
            if (ImgObj != this->imgList.end()) {         
    std::rotate(ImgObj,ImgObj+1,this->imgList.end());
   }
            return RET_OK;
}

int App::LUA_HideImg(lua_State* L) {
 int argnum = lua_gettop(L);
    if (argnum < 1) {
        lua_pushstring(L,"Not enought arguments for HideImg");
        lua_pushnumber(L,1);
        lua_error(L);
        return RET_ERR;
    }
    int OBJID = luaL_checkinteger(L,1);
    std::vector<Img  *>::iterator ImgObj = 
            std::find_if(this->imgList.begin(),this->imgList.end(),
            [&OBJID](Img *obj){ return obj->GetID() == OBJID; });
            (*ImgObj)->SetHiden(true);
            return RET_OK;
}

int App::LUA_UnHideImg(lua_State* L) {
 int argnum = lua_gettop(L);
    if (argnum < 1) {
        lua_pushstring(L,"Not enought arguments for UnHideImg");
        lua_pushnumber(L,1);
        lua_error(L);
        return RET_ERR;
    }
    int OBJID = luaL_checkinteger(L,1);
    std::vector<Img  *>::iterator ImgObj = 
            std::find_if(this->imgList.begin(),this->imgList.end(),
            [&OBJID](Img *obj){ return obj->GetID() == OBJID; });
            (*ImgObj)->SetHiden(false);
            return RET_OK;
}

int App::LUA_APPQUIT(lua_State* L) {
    this->appQuit = true;
    return RET_OK;
}

int App::LUA_APPRUNFILE(lua_State* L) {
    int argnum = lua_gettop(L);
    if (argnum < 1) {
        lua_pushstring(L,"Not enought arguments for RunFile");
        lua_pushnumber(L,1);
        lua_error(L);
        return RET_ERR;
    }
    
    this->luaScriptFileName = luaL_checkstring(L,1);
    DEBUG("NEW FILE EXECUTION REQUEST. "<< this->luaScriptFileName);
    this->SetExec_new_file(true);
    return RET_OK;
}


int App::AppRun() {
    SDL_Event e;
    this->appQuit = false;
    this->camera->SetScale(1);
    /*
    this->camera->SetScale(1);
    this->player->SetX(150);
    this->player->SetY(250);
    this->player->SetSpeed(3);
    this->cameraSpd = 3;
    int x=10;
    if (this->activeMap->LoadMap("img/map.png") != RET_OK) {
        DEBUG("APP QUITED");
        return RET_ERR;
    };
     */
    //initial clear of our viewport
    SDL_RenderClear(this->renderer);
    
    if (this->execLuaFileFunc != nullptr) {
        this->execLuaFileFunc();
    }
    float screenCellSizeW = 0;
    float screenCellSizeH = 0;
    int VP_W = 0;
    int VP_H = 0;
    int maxVP_W = 0;
    int maxVP_H = 0;
    int startXIndex = 0;
    int startXOffset = 0;
    int startYIndex = 0;
    int startYOffset = 0;
    if (this->activeMap != nullptr && this->player != nullptr) {
    screenCellSizeW = this->activeMap->GetCellW()*this->camera->GetScale();
    screenCellSizeH = this->activeMap->GetCellH()*this->camera->GetScale();
    VP_W = this->wSurface->w / screenCellSizeW;
    VP_H = this->wSurface->h / screenCellSizeH;
    maxVP_W = this->activeMap->GetMapW() / screenCellSizeW;
    maxVP_H = this->activeMap->GetMapH() / screenCellSizeH;
    }
    while (!appQuit) {
        
    if (this->activeMap != nullptr && this->player != nullptr) {        
    startXIndex = (this->camera->GetX() / screenCellSizeW);
    startXOffset = startXIndex*screenCellSizeW - this->camera->GetX();
    startYIndex = (this->camera->GetY() / screenCellSizeH);
    startYOffset = startYIndex*screenCellSizeH - this->camera->GetY();
    }
   
    if (this->IsExec_new_file()) {
        //DEBUG("EXEC NEW FILE FLAG RAISED! ");
        this->execLuaFileFunc();
        this->SetExec_new_file(false);
        }
  //Handle events on queue
     while( SDL_PollEvent( &e ) != 0 ) {
         //User requests quit
                    if( e.type == SDL_QUIT ) {
                        appQuit = true;
                    }
                    //Handle mouse events
                    if( e.type == SDL_MOUSEMOTION || 
                        e.type == SDL_MOUSEBUTTONDOWN || 
                        e.type == SDL_MOUSEBUTTONUP ) {
                    this->mState = SDL_GetMouseState(&this->mouseX, &this->mouseY);
                    if (e.type == SDL_MOUSEBUTTONDOWN) {
                        this->mButtonState = MOUSE_BUTTON_DOWN;
                    }
                    if (e.type == SDL_MOUSEBUTTONUP) {
                        this->mButtonState = MOUSE_BUTTON_UP;
                    }
                    
                    } // mouse button handling
                    
                     //provide mouse event to LUA Script handler if any
                    lua_getglobal(this->luaState,"mouseHandler");
                    if (lua_isfunction(this->luaState,lua_gettop(this->luaState))) {
                        //we have in our lua script mouseevents handler
                        lua_pushnumber(this->luaState,this->mouseX);
                        lua_pushnumber(this->luaState,this->mouseY);
                    if (this->mButtonState != MOUSE_BUTTON_NONE) {
                        lua_pushnumber(this->luaState,SDL_BUTTON(this->mState));    
                        } else {
                        lua_pushnumber(this->luaState,0);        
                        }
                        lua_pushnumber(this->luaState,this->mButtonState);
                    // do the call (4 arguments, 1 result) 
                    if (lua_pcall(this->luaState,4,1,0) != LUA_OK) {
                    printf("error running function 'mouseHandler': %s\n",lua_tostring(this->luaState, -1));
                    }
                    } else { lua_pop(this->luaState,lua_gettop(this->luaState));   }
                      //Keyboard Events
                    if (e.type == SDL_KEYDOWN){
                        switch( e.key.keysym.sym ){
                         case SDLK_UP:
                             if (this->activeMap != nullptr && this->player != nullptr) {
                             if (this->player->GetY() > 0 
                                     && 
                                 this->activeMap->ColisionCheck( floor(this->player->GetX() / screenCellSizeW),
                                     floor((this->player->GetY() - this->player->GetSpeed()) / screenCellSizeH), 
                                     floor((this->player->GetCellW()*this->camera->GetScale())/screenCellSizeW),
                                     floor((this->player->GetCellH()*this->camera->GetScale())/screenCellSizeH)
                                     ) == 0 
                                     ) {
                                 this->player->SetY(this->player->GetY() - this->player->GetSpeed());
                             if (this->player->GetY() < 0 ) {this->player->SetY(0);};
                             }
                             }
                             break;
                        case SDLK_DOWN:
                            if (this->activeMap != nullptr && this->player != nullptr) {
                            if (this->player->GetY() < this->activeMap->GetMapH()*screenCellSizeH 
                                    && 
                                this->activeMap->ColisionCheck(floor(this->player->GetX() / screenCellSizeW),
                                     floor((this->player->GetY() + this->player->GetSpeed()) / screenCellSizeH), 
                                     floor((this->player->GetCellW()*this->camera->GetScale())/screenCellSizeW),
                                     floor((this->player->GetCellH()*this->camera->GetScale())/screenCellSizeH)
                                     ) == 0 
                                    ) {
                                 this->player->SetY(this->player->GetY() + this->player->GetSpeed());
                                if (this->player->GetY() > this->activeMap->GetMapH()*screenCellSizeH ) { this->player->SetY(this->activeMap->GetMapH()*screenCellSizeH); };                                        
                             }
                            }
                             break;
                         case SDLK_LEFT:
                             if (this->activeMap != nullptr && this->player != nullptr) {
                            if (this->player->GetX() > 0 
                                    && 
                                    this->activeMap->ColisionCheck(floor((this->player->GetX()- this->player->GetSpeed()) / screenCellSizeW),
                                     floor(this->player->GetY() / screenCellSizeH), 
                                     floor((this->player->GetCellW()*this->camera->GetScale())/screenCellSizeW),
                                     floor((this->player->GetCellH()*this->camera->GetScale())/screenCellSizeH)
                                     ) == 0 
                                    ) {
                                 this->player->SetX(this->player->GetX() - this->player->GetSpeed());
                                 if ( this->player->GetX() < 0 ) { this->player->SetX(0);};                                        
                             }
                             }
                             break;
                         case SDLK_RIGHT:
                            if (this->activeMap != nullptr && this->player != nullptr) {
                             if (this->player->GetX() < this->activeMap->GetMapW() * screenCellSizeW  
                                     && 
                                     this->activeMap->ColisionCheck(floor((this->player->GetX()+ this->player->GetSpeed()) / screenCellSizeW),
                                     floor(this->player->GetY() / screenCellSizeH), 
                                     floor((this->player->GetCellW()*this->camera->GetScale())/screenCellSizeW),
                                     floor((this->player->GetCellH()*this->camera->GetScale())/screenCellSizeH)
                                     ) == 0 
                                     ) {
                                 this->player->SetX(this->player->GetX() + this->player->GetSpeed());
                                 if (this->player->GetX() > this->activeMap->GetMapW() * screenCellSizeW )  { this->player->SetX(this->activeMap->GetMapW() * screenCellSizeW); };                                        
                             }
                            }
                             break;                             
                        } //switch
                    } //SDL_KEYDOWN
     } //SDL_PollEvent
      //provide background animation timer functional
                    lua_pushcfunction(this->luaState, this->LuaErrorHandlerFunc); // stack: errorHandler
                    lua_getglobal(this->luaState,"LoopHandler");
                    if (lua_isfunction(this->luaState,lua_gettop(this->luaState))) {
                    // do the call (0 arguments, 1 result) 
                    if (lua_pcall(this->luaState,0,1,-2) != LUA_OK) {
                    printf("Engine: error running function 'LoopHandler': %s\n",lua_tostring(this->luaState, -1));
                    }
                    } else { lua_pop(this->luaState,lua_gettop(this->luaState));   }
                    
    if (this->activeMap != nullptr && this->player != nullptr) {
            this->camera->SetY(this->player->GetY()- this->wSurface->h/2);
            if (this->camera->GetY() < 0) {
            this->camera->SetY(0);
                                          }
            this->camera->SetX(this->player->GetX()-this->wSurface->w/2);
            if (this->camera->GetX() < 0) {
            this->camera->SetX(0);
                                          }

    this->activeMap->Draw(this->camera,this->renderer,this->wSurface);
    this->player->Draw(this->camera,this->renderer,this->wSurface);
    }
    for (std::vector<Img *>::iterator it = this->imgList.begin(); it != this->imgList.end();++it) {
         (*it)->Draw(this->camera,this->renderer,this->wSurface);
     }
    for (std::vector<Label *>::iterator it = this->labelList.begin(); it != this->labelList.end();++it) {
         (*it)->Draw(this->camera,this->renderer,this->wSurface);
     }
    SDL_RenderPresent(this->renderer);     
    this->mButtonState = MOUSE_BUTTON_NONE; //clear mouse state;
      } //while
  
    return RET_OK;
}
