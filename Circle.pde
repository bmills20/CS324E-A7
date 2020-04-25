class Circle{
  float r, x, y, theta, vmag;
  float turnCounter, currentTurn;
  color c;
  Circle( float rad, float tc ){
    r = rad;
    turnCounter = tc;
    currentTurn = random(0,24);
    theta = random(0,2*PI);
    x = random(0,1000);
    y = random(0,800);
    vmag = 2;
    c = color(random(0,255));
  }
  
  void updateTheta(){
    currentTurn++;
    if( currentTurn >= turnCounter ){
      theta = random(0,2*PI);
      currentTurn = 0;
    }
  }
  
  void update(){
    ellipseMode(RADIUS);
    updateTheta();
    x += vmag*cos(theta);
    y += vmag*sin(theta);
    
    if( x > width ){
      x = 0;
    }
    else if( x < 0 ){
      x = width;
    }
    if( y > height ){
      y = 0;
    }
    else if( y < 0 ){
      y = height;
    }
    fill(c);
    ellipse(x,y,r,r);
  }
  
  void destroy(){
    r = 0;
    vmag = 0;
    x = -2000;
    y = -2000;
  }
  
  void shouldAbsorb( Circle smaller ){
    float dist = sqrt( sq( smaller.x - x ) + sq( smaller.y - y ) );
    if( dist < r && sq(r) > 1.2*sq(smaller.r) ){
      r = sqrt( sq(r) + sq(smaller.r) );
      smaller.destroy();
    }
    dist = 0;
  }
  
}
