class Circle {
  float r, x, y, theta, vmag;
  float turnCounter, currentTurn;
  color c;
  int numConsumed;
  boolean isAlive;
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
  }

  void updateTheta() {
    currentTurn++;
    if ( currentTurn >= turnCounter ) {
      theta = random(0, 2*PI);
      currentTurn = 0;
    }
  }

  void update() {
    ellipseMode(RADIUS);
    updateTheta();
    x += vmag*cos(theta);
    y += vmag*sin(theta);

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
  }

  void destroy() {
    r = 0;
    vmag = 0;
    x = -2000;
    y = -2000;
    isAlive = false;
  }

  void shouldAbsorb( Circle smaller ) {

    float dist = sqrt( sq( smaller.x - x ) + sq( smaller.y - y ) );
    if ( dist < r && sq(r) > 1.2*sq(smaller.r) ) {
      r = sqrt( sq(r) + sq(smaller.r) );
      smaller.destroy();
      numConsumed ++;
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
