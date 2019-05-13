/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/* 
 * File:   camera.cpp
 * Author: gordeev
 * 
 * Created on October 15, 2018, 5:28 PM
 */

#include "Camera.hpp"

Camera::Camera() {
    this->x=0;
    this->y=0;
    this->scale=1;
}

Camera::Camera(const Camera& orig) {
}

Camera::~Camera() {
}

void Camera::SetScale(float scale) {
    this->scale = scale;
}

float Camera::GetScale() const {
    return scale;
}

void Camera::SetY(float y) {
    this->y = y;
}

float Camera::GetY() const {
    return y;
}

void Camera::SetX(float x) {
    this->x = x;
}

float Camera::GetX() const {
    return x;
}

