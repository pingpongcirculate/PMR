/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/* 
 * File:   camera.hpp
 * Author: gordeev
 *
 * Created on October 15, 2018, 5:28 PM
 */

#ifndef CAMERA_HPP
#define CAMERA_HPP

class Camera {
public:
    Camera();
    Camera(const Camera& orig);
    virtual ~Camera();
    void SetScale(float scale);
    float GetScale() const;
    void SetY(float y);
    float GetY() const;
    void SetX(float x);
    float GetX() const;
private:
    float x;
    float y;
    float scale;
};

#endif /* CAMERA_HPP */

