/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/* 
 * File:   App.hpp
 * Author: gordeev
 *
 * Created on October 15, 2018, 12:32 PM
 */

#ifndef APP_HPP
#define APP_HPP

#include <iostream>
#include <cassert>
#include <algorithm>
#include <vector>
#include <unordered_map>
#include "SimpleIni.h"
#include <SDL2/SDL.h>
#include <SDL2/SDL_image.h>
#include "SDL2/SDL_ttf.h"
#include "lua.hpp"
#include "const.hpp"
#include "Camera.hpp"
#include "Map.hpp"
#include "Npc.hpp"
#include "Img.hpp"
#include "Label.hpp"

typedef void (*luaFileExecFunc)();

class App {
public:
    App();
    App(const App& orig);
    virtual ~App();
    int AppInit();
    int AppRun();
    void ClearObjects();
    void SetLuaState(lua_State* luaState);
    lua_State* GetLuaState() const;
    void SetExec_new_file(bool exec_new_file);
    bool IsExec_new_file() const;
    void SetLuaScriptFileName(std::string luaScriptFileName);
    std::string GetLuaScriptFileName() const;
    void SetExecLuaFileFunc(void (*F)());
    int windowH;
    int windowW;
    //LUA BEGIN
    //IMG
    int LUA_LoadImg(lua_State* L);
    int LUA_SetImgAlpha(lua_State* L);
    int LUA_SetImgPos(lua_State* L);
    int LUA_SetImgRotation(lua_State* L);
    int LUA_SetImgDimensions(lua_State* L);
    int LUA_SendImgToFront(lua_State* L);
    int LUA_HideImg(lua_State* L);
    int LUA_UnHideImg(lua_State* L);
    int LUA_DelImg(lua_State* L);
    //APP CONTROL
    int LUA_APPQUIT(lua_State* L);
    int LUA_APPRUNFILE(lua_State* L);
    //TEXT LABELS
    int LUA_CreateLabel(lua_State* L);
    int LUA_DelLabel(lua_State* L);
    int LUA_HideLabel(lua_State* L);
    int LUA_UnHideLabel(lua_State* L);
    int LUA_SetLabelPos(lua_State* L);
    int LUA_SetLabelText(lua_State* L);
    void SetWindowW(int windowW);
    int GetWindowW() const;
    void SetWindowH(int windowH);
    int GetWindowH() const;
    //LUA END
    
private:
    //LUA
    lua_State* luaState;
    bool exec_new_file;
    std::string luaScriptFileName;
    luaFileExecFunc execLuaFileFunc;
    Uint32 mState; //mouse buttons state
    int mouseX;
    int mouseY;
    int mButtonState; //button down or button up
    
    SDL_Window* window;
    SDL_Surface* wSurface;
    SDL_Texture* wTexture;
    SDL_Renderer* renderer;
    bool appQuit;
    float cameraSpd;
    Map* activeMap;
    Camera* camera;
    Npc* player;
    
    std::vector <Img *> imgList;
    std::vector <Label *> labelList;
};

#endif /* APP_HPP */

