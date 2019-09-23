/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/* 
 * File:   main.cpp
 * Author: gordeev
 *
 * Created on October 15, 2018, 12:29 PM
 */

#include <cstdlib>
#include <SDL2/SDL.h>
extern "C" {
#include "lua.h"
#include "lauxlib.h"
#include "lualib.h"
}

#include "hpp/const.hpp"
#include "hpp/App.hpp"

/*
 *MAIN PROGRAMM
 */
#ifdef main
#undef main
#endif


App game;

int ENGINE_LUA_APPQUIT(lua_State *L) {
    ::game.LUA_APPQUIT(L);
    return RET_OK;
}

int ENGINE_LUA_APPRUNFILE(lua_State *L) {
    ::game.LUA_APPRUNFILE(L);
    return RET_OK;
}

int ENGINE_LUA_LoadImg(lua_State *L) {
    ::game.LUA_LoadImg(L);
    return RET_OK;
}

int ENGINE_LUA_SetImgAlpha(lua_State *L) {
    ::game.LUA_SetImgAlpha(L);
    return RET_OK;
}

int ENGINE_LUA_SetImgAngle(lua_State *L) {
    ::game.LUA_SetImgRotation(L);
    return RET_OK;
}

int ENGINE_LUA_SetImgHiden(lua_State *L) {
    ::game.LUA_HideImg(L);
    return RET_OK;
}

int ENGINE_LUA_SetImgUnHiden(lua_State *L) {
    ::game.LUA_UnHideImg(L);
    return RET_OK;
}

int ENGINE_LUA_DelImg(lua_State *L) {
    ::game.LUA_DelImg(L);
    return RET_OK;
}

int ENGINE_LUA_BringImgToFront(lua_State *L) {
    ::game.LUA_SendImgToFront(L);
    return RET_OK;
}

int ENGINE_LUA_SetImgPos(lua_State *L) {
    ::game.LUA_SetImgPos(L);
    return RET_OK;
}

int ENGINE_LUA_CreateLabel(lua_State *L) {
    ::game.LUA_CreateLabel(L);
    return RET_OK;
}

int ENGINE_LUA_DelLabel(lua_State *L) {
    ::game.LUA_DelLabel(L);
    return RET_OK;
}

int ENGINE_LUA_HideLabel(lua_State *L) {
    ::game.LUA_HideLabel(L);
    return RET_OK;
}

int ENGINE_LUA_unHideLabel(lua_State *L) {
    ::game.LUA_UnHideLabel(L);
    return RET_OK;
}


int ENGINE_LUA_SetLabelPos(lua_State *L) {
    ::game.LUA_SetLabelPos(L);
    return RET_OK;
}

int ENGINE_LUA_SetLabelText(lua_State *L) {
    ::game.LUA_SetLabelText(L);
    return RET_OK;
}


void runLuaScript() {
    DEBUG("EXECUTIN FILE: "<<game.GetLuaScriptFileName());
    game.ClearObjects();
    if (game.GetLuaState() != nullptr) {
    lua_close(game.GetLuaState());
    }
    
    game.SetLuaState(luaL_newstate());
    luaL_openlibs(game.GetLuaState());
    lua_pushinteger(game.GetLuaState(), game.GetWindowH());
    lua_setglobal(game.GetLuaState(), "LUA_WindowH");
    lua_pushinteger(game.GetLuaState(), game.GetWindowW());
    lua_setglobal(game.GetLuaState(), "LUA_WindowW");
    //APP OBJECT
    lua_register(game.GetLuaState(),"LUA_APPQUIT",ENGINE_LUA_APPQUIT);
    lua_register(game.GetLuaState(),"LUA_APPRUNFILE",ENGINE_LUA_APPRUNFILE);
    //IMG OBJECT
    lua_register(game.GetLuaState(),"LUA_LoadImg",ENGINE_LUA_LoadImg);
    lua_register(game.GetLuaState(),"LUA_SetImgAlpha",ENGINE_LUA_SetImgAlpha);
    lua_register(game.GetLuaState(),"LUA_BringImgToFront",ENGINE_LUA_BringImgToFront);
    lua_register(game.GetLuaState(),"LUA_SetImgPos",ENGINE_LUA_SetImgPos);
    lua_register(game.GetLuaState(),"LUA_SetImgHiden",ENGINE_LUA_SetImgHiden);
    lua_register(game.GetLuaState(),"LUA_SetImgUnHiden",ENGINE_LUA_SetImgUnHiden);
    lua_register(game.GetLuaState(),"LUA_DelImg",ENGINE_LUA_DelImg);
    lua_register(game.GetLuaState(),"LUA_SetImgRotation",ENGINE_LUA_SetImgAngle);
    //LABEL OBJECT
    lua_register(game.GetLuaState(),"LUA_CreateLabel",ENGINE_LUA_CreateLabel);
    lua_register(game.GetLuaState(),"LUA_DelLabel",ENGINE_LUA_DelLabel);
    lua_register(game.GetLuaState(),"LUA_HideLabel",ENGINE_LUA_HideLabel);
    lua_register(game.GetLuaState(),"LUA_ShowLabel",ENGINE_LUA_unHideLabel);
    lua_register(game.GetLuaState(),"LUA_SetLabelPos",ENGINE_LUA_SetLabelPos);
    lua_register(game.GetLuaState(),"LUA_SetLabelText",ENGINE_LUA_SetLabelText);
    
    int status = luaL_dofile(game.GetLuaState(),game.GetLuaScriptFileName().c_str());
    if (status) {
    const char *msg;  
    msg = lua_tostring(game.GetLuaState(), lua_gettop(game.GetLuaState()));
    if (msg == NULL) msg = "(error with no message)";
    std::cout << "ERROR WHILE EXECUTING LUA FILE! "<<status<<" MESSAGE: "<<msg<<"\n";
    std::flush(std::cout);
    lua_pop(game.GetLuaState(), 1);
    }
  
}

int main(int argc, char** argv) {
          
    game.SetExecLuaFileFunc(runLuaScript);
    game.AppInit();
    game.AppRun();

    return 0;
}

