class Box {
  PImage img; // Needed to insert image
  float x, y, w, h, speed;
  Box(float argX, float argY, float argW, float argH, float argSpeed, String tmpImg) {
    x = argX;
    y = argY;
    w = argW;
    h = argH;
    speed = argSpeed;

    img = loadImage(tmpImg); //tmpImage called in the box and now when drawing the image they can be called when drawing the boxes
  }  //End of box

  void draw() {
    image(img, x, y, w, h);
  }  //End of draw

  void fall() {
    y += speed;
  }  //End of fall


  void moveLeft() {
    x -= 15;
  }  //End of moveLeft, Moving the user paddle left

  void moveRight() {
    x +=15;
    
  }  //End of moveRight, Moving the user paddle right
}   // End of class Box

