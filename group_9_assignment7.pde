Circle[] circles = new Circle[50];
Player p1;
PFont loseFont, gooeyFont, invisFont;
int totalRounds = 0;
ArrayList numDead = new ArrayList<Integer>();

void setup(){
  numDead.clear();
  loseFont = createFont("AYearWithoutRain.ttf",50,true);
  gooeyFont = createFont("AYearWithoutRain.ttf",25,true);
  size(1000,800);
  frameRate(24);
  for( int i = 0; i < circles.length; i++ ){
    circles[i] = new Circle( random(5, 25), random(12, 24) );
  }
  p1 = new Player(20);
}

void draw(){
  background(230);
  p1.update();
  for( int i = 0; i < circles.length; i++ ){
    if(circles[i].isAlive == false){
      if(!numDead.contains(i)){
        numDead.add(i);
      }
    }
    if(numDead.size() >= 50){
      noLoop();
      winGame();
      break;
    }
    
  }
  
  for( Circle c1: circles ){
    p1.shouldAbsorb(c1);
    c1.update();
    p1.shouldAbsorb(c1);
    for( Circle c2: circles ){
      c1.shouldAbsorb(c2);
    }
    
    if(c1.playerDead(p1) == true){
      totalRounds ++;
      noLoop();
      endGame();      
      break; //Break out of for loop, necessary so no circles will be generated upon loss
    }
  }
  showGUI();
}

void endGame(){
  background(230);
  textFont(loseFont);
  fill(0);
  textAlign(CENTER);
  text("You Lose! \n Final size: " + round(p1.r),width/2,3*height/8);
  text("Click anywhere to play again.", width/2, 5 * height /8);
}

void winGame(){
  background(230);
  textFont(loseFont);
  fill(0);
  textAlign(CENTER);
  text("You Win! \n Final size: " + round(p1.r),width/2,3*height/8);
  text("Click anywhere to play again.", width/2, 5 * height /8);
}

void showGUI() {
  textFont(gooeyFont);
  fill(0);
  textAlign(CENTER);
  text("Number consumed: " + p1.numConsumed, width/5,30);
  text("Total rounds: " + totalRounds, 4*width / 5,30);
}

void keyPressed(){
  if( key == 'p' || key == 'P' ){
    looping = !looping;
    textFont(gooeyFont);
    fill(0);
    textAlign(CENTER);
    text("PAUSED",width/2,height/2);
  }
  else{
    p1.keyPressed();
  }
}

void keyReleased(){
  p1.keyReleased();
}

void mousePressed(){
  frameCount = -1;
  loop();
}

void mouseReleased(){
  loop();
}
