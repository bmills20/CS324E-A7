Circle[] circles = new Circle[50];
Player p1;
PFont f;

void setup(){
  //Will probably change font later when GUI is worked on
  f = createFont("Arial",100,true);
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
    p1.shouldAbsorb(c1);
    //c1.playerDead(p1);
    for( Circle c2: circles ){
      c1.shouldAbsorb(c2);
    }
    if(c1.playerDead(p1) == true){
      background(127);
      noLoop();
      endGame();
      break; //Break out of for loop, necessary so no circles will be generated upon loss
    }
  }
}

void endGame(){
  background(127);
  //Possibly change to new font later
  textFont(f);
  fill(0);
  textAlign(CENTER);
  text("You Lose!",width/2,height/2);
  
}

void keyPressed(){
  p1.keyPressed();
}

void keyReleased(){
  p1.keyReleased();
}
