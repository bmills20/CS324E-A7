Circle[] circles = new Circle[50];
Player p1;

void setup(){
  size(1000,800);
  frameRate(24);
  for( int i = 0; i < circles.length; i++ ){
    circles[i] = new Circle( random(5, 25), random(12, 24) );
  }
  p1 = new Player(20);
}

void draw(){
  background(127);
  p1.update();
  /*
  for( Circle c1: circles ){
    p1.shouldAbsorb(c1);
    c1.update();
  }
  */
  for( Circle c1: circles ){
    p1.shouldAbsorb(c1);
    c1.update();
    c1.shouldAbsorb(p1);
    for( Circle c2: circles ){
      c1.shouldAbsorb(c2);
    }
  }
}

void keyPressed(){
  p1.keyPressed();
}

void keyReleased(){
  p1.keyReleased();
}
