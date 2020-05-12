boolean[] keys;
int up = 0;
int down = 0;
int left = 0;
int right = 0;
boolean cooldownFlag = false;
int cooldownFrames = 200; 
boolean boostActive = false;
int boostFrames = 24;

class Player extends Circle{
  
  Player( float rad ){
    super( rad, 0 );
    c = color(253, 115, 255);
  }
  
  void keyPressed( ){
    if( key == ' ' && cooldownFlag == false ){
      vmag *= 1.5;
      boostActive = true;
      cooldownFlag = true;
      boostFrames = 24;
      cooldownFrames = 0;
    }
    if( key == 'w' || key == 'W' ){
      up = 1;
    }
    else if( key == 'a' || key == 'A' ){
      left = 1;
    }
    else if( key == 's' || key == 'S' ){
      down = 1;
    }
    else if( key == 'd' || key == 'D' ){
      right = 1;
    }
  }
  
  void keyReleased( ){
    if( key == 'w' || key == 'W' ){
      up = 0;
    }
    else if( key == 'a' || key == 'A' ){
      left = 0;
    }
    else if( key == 's' || key == 'S' ){
      down = 0;
    }
    else if( key == 'd' || key == 'D' ){
      right = 0;
    }
  }
  
  void updateTheta(){
    if( up + down + left + right == 0 ){
      theta = -1;
    }
    else{
      int ydir = down - up;
      int xdir = right - left;
      theta = atan2(ydir, xdir);
    }
  }
  
  void updateCooldown(){
    if( boostActive ){
      boostFrames -= 1;
      if( boostFrames <= 0 ){
        vmag /= 1.5;
        boostActive = false;
      }
    }   
    if( cooldownFlag ){
      cooldownFrames += 1;
      if( cooldownFrames >= 200 ){
        cooldownFlag = false;
      }
    }
    //ADD IN RECTANGLE OR CIRCLE FOR COOLDOWN
    fill(0);
    rect(400,15,200,10);
    fill(255);
    rect(400,15,cooldownFrames,10);
  }
  
}
