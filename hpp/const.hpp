/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/* 
 * File:   const.hpp
 * Author: gordeev
 *
 * Created on October 15, 2018, 1:32 PM
 */

#ifndef CONST_HPP
#define CONST_HPP

#include <ostream>

//img extension library flags
#define IMG_INIT_ALL IMG_INIT_JPG|IMG_INIT_PNG|IMG_INIT_TIF|IMG_INIT_WEBP

#define DEBUG_FLAG 1

#define DEBUG(x) do { \
if (DEBUG_FLAG) { std::cerr << x << std::endl;} \
                    } while (0)

#define RET_OK 0
#define RET_ERR -1

#define APP_TITLE "simple app"

#define SCREEN_WIDTH 800 
#define SCREEN_HEIGHT 600

#define MOUSE_BUTTON_UP 2
#define MOUSE_BUTTON_DOWN 3
#define MOUSE_BUTTON_NONE 4

#endif /* CONST_HPP */

