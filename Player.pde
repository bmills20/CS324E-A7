boolean[] keys;
int up = 0;
int down = 0;
int left = 0;
int right = 0;

class Player extends Circle{
  
  Player( float rad ){
    super( rad, 0 );
    c = color(253, 115, 255);
  }
  
  void keyPressed( ){
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
    int ydir = down - up;
    int xdir = right - left;
    theta = atan2(ydir, xdir);
  }
  
}
