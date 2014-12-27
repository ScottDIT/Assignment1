import ddf.minim.*; // Library for audio
AudioPlayer jump;
AudioPlayer crowdboo;
AudioPlayer bonustick;
AudioPlayer bgmusic;


Minim minim;

Box baddies[] = new Box[6]; // New array of custom class.
Box goodies[] = new Box[4];
Box user;
Box bonus[] = new Box[1];


PImage bg;
String game_state = "ready";

int score = 0, lives = 3, level = 1;// Beginning score and live for player

void setup() {
  size(600, 600);
  minim = new Minim(this);
  jump = minim.loadFile("jump.mp3");
  crowdboo = minim.loadFile("crowdboo.mp3");
  bonustick = minim.loadFile("bonustick.mp3");
  bgmusic = minim.loadFile("bgmusic.mp3");
  bg = loadImage("pitch.jpg");

  println(lives);


  //Creating the baddies and passing in variables
  for (int i=0; i<baddies.length; i++) {
    float w = 30, h = 30;
    float x = random(0, width - w);
    float y = random(-height, -h);
    //float speed = random(2, 5);
    float speed = 4.0f;
    baddies[i] = new Box(x, y, w, h, speed, "redcard.png"); // Change to image for bad blocks
  }
  //Creating the goodies and passing in variables
  for (int i=0; i<goodies.length; i++) {
    float w = 30, h = 30;
    float x = random(0, width - w);
    float y = random(-height, -h);
    //float speed = random(2, 5);
    float speed = 4.0f;
    goodies[i] = new Box(x, y, w, h, speed, "football.png"); // Change to image for good blocks
  }

  //Creating the bonus
  for (int i=0; i<bonus.length; i++) {
    float w = 30, h = 30;
    float x = (width/2)-(w/2);
    float y = height-h;
    float speed = 5;
    bonus[i] = new Box(x, y, w, h, speed, "bonus.png"); // Box is drawn
  }


  //Creating the user box
  float w = 30, h = 30;
  float x = (width/2)-(w/2);
  float y = height-h;
  float speed = 30;
  user = new Box(x, y, w, h, speed, "player.png"); // Box is drawn
}  //End of setup



void draw() {  
  background(bg);
  if (!bgmusic.isPlaying()) {
    bgmusic.play();
    bgmusic.rewind();
  }
  if (game_state == "ready") {

    drawInstuctions();
  } //End of Gamestate Ready 

  else   
    if (game_state == "running") {
    background(bg);

    //Drawing the baddies and calling fall method
    for (int i=0; i<baddies.length; i++) {
      baddies[i].draw();
      baddies[i].fall();
      collideBaddie(i, user); // Pass in i and user to collideBaddie method
      if (baddies[i].y > height) {
        baddies[i].y = random(-height, -baddies[i].h);
        baddies[i].x = random(0, width - baddies[i].w);
      }
    }

    //Drawing the goodies and calling the fall method
    for (int i=0; i<goodies.length; i++) {
      goodies[i].draw();
      goodies[i].fall();
      collideGoodie(i, user);
      if (goodies[i].y > height) {
        goodies[i].y = random(-height, -goodies[i].h);
        goodies[i].x = random(0, width - goodies[i].w);
      }
    }

    //Drawing the bonus and calling fall method
    for (int i=0; i<bonus.length; i++) {
      bonus[i].draw();
      bonus[i].fall();
      collideBonus(i, user); // Pass in i and user to collideBonus method
      if (bonus[i].y > height) {
        bonus[i].y = random(-height * 15, -bonus[i].h);
        bonus[i].x = random(0, width - bonus[i].w);
      }
    }


    user.draw();
    fill(255);
    textAlign(CENTER);
    textSize(15);

    text(" Press 'P' to pause the game! ", width/2, 35);

    textSize(20);
    text("Score: " + score, 40, 30);
    text("Lives: " + lives, 40, 55);
    text("Level: " + level, 40, 80);
  } // End of Gamestate Running

  else
    if (game_state == "paused") {
    background(bg);



    //Drawing the baddies and calling fall method
    for (int i=0; i<baddies.length; i++) {
      baddies[i].draw();
    }

    //Drawing the goodies and calling the fall method
    for (int i=0; i<goodies.length; i++) {
      goodies[i].draw();
    }
    user.draw();
    fill(255);
    textAlign(CENTER);
    textSize(15);

    text(" You're game is paused! Press 'S' to continue ", width/2, 35);

    textSize(20);
    text("Score: " + score, 40, 30);
    text("Lives: " + lives, 40, 55);
    text("Level: " + level, 40, 80);
  }//End of Gamestate Paused

  else
    if (game_state =="over") {
    background(bg);
    fill(255);
    textAlign(CENTER);
    textSize(30);
    text("GAME OVER!", width/2, 30);


    textSize(15);
    text("Your Final Score Was: " + score, width/2, 60);
    text("You Finished On Level: " + level, width/2, 80);
    text("If you would like to restart game press 'R': ", width/2, 100);
  }// End of Gamestate Over

  else
    if (game_state == "restart") { // Start of restart
    background(bg);

    float w = 30, h = 30;
    float x = (width/2)-(w/2);
    float y = height-h;
    float speed = 30;
    user = new Box(x, y, w, h, speed, "player.png"); // Box is drawn
    user.draw();


    fill(255);
    textAlign(CENTER);
    textSize(15);

    text(" Press 'S' To Begin A New Game! ", width/2, 35);

    textSize(20);
    text("Score: " + score, 40, 30);
    text("Lives: " + lives, 40, 55);
    text("Level: " + level, 40, 80);

    for (int i = 0; i < baddies.length; i++) {
      baddies[i].y = random(-height, -baddies[i].h);
    }

    for (int i = 0; i < goodies.length; i++) {
      goodies[i].y = random(-height, -goodies[i].h);
    }
  } // End of Restart
}  //End of draw


void keyPressed() {
  if (key == CODED) {
    if (keyCode == LEFT) {
      user.moveLeft();
      if (user.x < 0) {
        user.x = width - user.w;
      }
    }
    if (keyCode == RIGHT) {
      user.moveRight();
      if (user.x > width - user.w) {
        user.x = 0;
      }
    }
  } else {
    if (key == 's' || key == 'S') {
      game_state = "running";
    } else if (key == 'p' || key == 'P') {

      game_state = "paused";
    } else if (key == 'r' || key == 'R') {

      game_state = "restart";
      lives = 3;
      score = 0;
      level = 1;
    }
  }
}  // End of keyPressed


//When the red card hits the player you will lose a life and the box will be re allocated
void collideBaddie(int tmp_i, Box tmpUser) { //Pass the i in from the loop previously created in the draw 
  if (baddies[tmp_i].y + baddies[tmp_i].h > tmpUser.y && baddies[tmp_i].x + baddies[tmp_i].w > tmpUser.x && baddies[tmp_i].x < tmpUser.x + tmpUser.w) {
    crowdboo.play();
    crowdboo.rewind();
    lives--; // minus a life for collision with baddies
    baddies[tmp_i].y = random(-height, -baddies[tmp_i].h); // Where the baddies will respawn on the x
    baddies[tmp_i].x = random(0, width - baddies[tmp_i].w); // Where the baddies will respawn on the x
    if (lives == 0) {
      game_state = "over";
    }
  }
}  //End of collideBaddie

//When the ball hits the player you will gain a score
void collideGoodie(int tmp_i, Box tmpUser) { //Pass the i in from the loop previously created in the draw 
  if (goodies[tmp_i].y + goodies[tmp_i].h > tmpUser.y && goodies[tmp_i].x + goodies[tmp_i].w > tmpUser.x && goodies[tmp_i].x < tmpUser.x + tmpUser.w) {
    jump.play();
    jump.rewind();
    score++; // Increase score when you collect the ball
    if (score % 4 == 0) {
      for (int i = 0; i < baddies.length; i++) {
        baddies[i].speed++;
      }
    }
    if (score % 4 == 0) {
      level++;
    }
    goodies[tmp_i].y = random(-height, -goodies[tmp_i].h);
    goodies[tmp_i].x = random(0, width - 40); // Where the goodies will respawn on the x
  }
}  //End of collideGoodie

void collideBonus(int tmp_i, Box tmpUser) { //Pass the i in from the loop previously created in the draw 
  if (bonus[tmp_i].y + bonus[tmp_i].h > tmpUser.y && bonus[tmp_i].x + bonus[tmp_i].w > tmpUser.x && bonus[tmp_i].x < tmpUser.x + tmpUser.w) {
    // Add a life for collision with bonus

    bonus[tmp_i].y = random(-height * 15, -bonus[tmp_i].h); // Where the baddies will respawn on the x
    bonus[tmp_i].x = random(0, width - bonus[tmp_i].w); // Where the baddies will respawn on the x
    bonustick.play();
    bonustick.rewind();

    if (lives < 3) {
      lives++;
    }
  }
}//End of collideBonus

void drawInstuctions() {

  fill(255);
  textAlign(CENTER);
  textSize(30);
  text("Footballer Goals", width/2, 50);

  textSize(15);
  text("1) Control the player with the LEFT and RIGHT arrow keys ", width/2, 80);
  text("2) Collect the football's to increase your score.", width/2, 100);
  text("3) Avoid the red cards as they will take a life away.", width/2, 120);
  text("4) Collect the golden boot to gain an extra life!", width/2, 140);
  text("5) Now you are ready to play the game! Press 'S' to start!", width/2, 160);
}//End of draw instuctions

