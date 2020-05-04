class Circle {
  float r, x, y, theta, vmag, ptheta;
  float turnCounter, currentTurn;
  color c;
  int numConsumed, powerFrames;
  boolean isAlive, isPowered;
  Circle( float rad, float tc ) {
    r = rad;
    turnCounter = tc;
    currentTurn = random(0, 24);
    theta = random(0, 2*PI);
    x = random(0, 1000);
    y = random(0, 800);
    vmag = 2;
    c = color(random(0,100), random(0,100), random(0,100));
    numConsumed = 0;
    isAlive = true;
    isPowered = false;
    ptheta = 0;
    powerFrames = 1000;
  }

  void updateTheta() {
    currentTurn++;
    if ( currentTurn >= turnCounter ) {
      theta = random(0, 2*PI);
      currentTurn = 0;
    }
  }

  void update() {
    if( isAlive ){
      ellipseMode(RADIUS);
      updateTheta();
      if( theta != -1 ){
        x += vmag*cos(theta);
        y += vmag*sin(theta);
      }
  
      if ( x > width ) {
        x = 0;
      } else if ( x < 0 ) {
        x = width;
      }
      if ( y > height ) {
        y = 0;
      } else if ( y < 0 ) {
        y = height;
      }
      fill(c);
      ellipse(x, y, r, r);
      if( isPowered ){
        fill(255,0,0);
        ellipse(x + 1.5*r*cos(ptheta), y + 1.5*r*sin(ptheta), 5, 5);
        ellipse(x + 1.5*r*cos(ptheta + PI), y + 1.5*r*sin(ptheta + PI), 5, 5);
        ptheta += 0.05;
        powerFrames -= 1;
        if( powerFrames <= 0 ){
          isPowered = false;
        }
      }
    }
  }

  void destroy() {
    r = 0;
    vmag = 0;
    x = -20000;
    y = -20000;
    isAlive = false;
  }

  void shouldAbsorb( Circle smaller ) {

    float dist = sqrt( sq( smaller.x - x ) + sq( smaller.y - y ) );
    if ( dist < r && sq(r) > 1.5*sq(smaller.r) ) {
      r = sqrt( sq(r) + sq(smaller.r) );
      smaller.destroy();
      numConsumed ++;
    }
    if( isPowered ){
      float dist1 = sqrt( sq( smaller.x - (x + 1.5*r*cos(ptheta)) ) + sq( smaller.y - (y + 1.5*r*sin(ptheta)) ) );
      float dist2 = sqrt( sq( smaller.x - (x + 1.5*r*cos(ptheta + PI)) ) + sq( smaller.y - (y + 1.5*r*sin(ptheta + PI)) ) );
      if ( dist1 < 5 || dist2 < 5 ) {
        smaller.r = smaller.r - 5;
      }
      dist = 0;
    }
  }
  
  void shouldAbsorbPower( Power pwr ) {
    float dist = sqrt( sq( pwr.x - x ) + sq( pwr.y - y ) );
    if ( dist < r ) {
      isPowered = true;
      powerFrames = 1000;
      pwr.destroy();
    }
    dist = 0;
  }

  boolean playerDead( Circle ply ) {
    float dist = sqrt( sq( ply.x - x ) + sq( ply.y - y ) );
    if (ply instanceof Player) {
      if ( dist < r && sq(r) > 1.2*sq(ply.r) ) {
        return true;
      }
      else{
        return false;
      }
    } 
    else {
      return false;
    }
  }
}
