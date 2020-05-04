Circle[] circles = new Circle[50];
Player p1;
Power pwr1, pwr2;
PFont loseFont, gooeyFont, invisFont;
int totalRounds = 0;
int turnCount = 0;
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
  p1 = new Player(25);
}

void draw(){
  background(230);
  if( turnCount % 500 == 0 ){
    pwr1 = new Power();
    pwr2 = new Power();
  }
  pwr1.update();
  pwr2.update();
  turnCount += 1;
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
  p1.shouldAbsorbPower(pwr1);
  p1.shouldAbsorbPower(pwr2);
  for( Circle c1: circles ){
    c1.update();
    c1.shouldAbsorbPower(pwr1);
    c1.shouldAbsorbPower(pwr2);
    p1.shouldAbsorb(c1);
    for( Circle c2: circles ){
      c1.shouldAbsorb(c2);
      c2.shouldAbsorb(c1);
    }
    
    if(c1.playerDead(p1) == true){
      noLoop();
      endGame();      
      break; //Break out of for loop, necessary so no circles will be generated upon loss
    }
  }
  showGUI();
}

void endGame(){
  totalRounds++;
  background(230);
  textFont(loseFont);
  fill(0);
  textAlign(CENTER);
  text("You Lose! \n Final size: " + round(p1.r),width/2,3*height/8);
  text("Click anywhere to play again.", width/2, 5 * height /8);
  addScore(round(p1.r));
  print("ENDED");
}

void winGame(){
  totalRounds++;
  background(230);
  textFont(loseFont);
  fill(0);
  textAlign(CENTER);
  text("You Win! \n Final size: " + round(p1.r),width/2,3*height/8);
  text("Click anywhere to play again.", width/2, 5 * height /8);
  addScore(round(p1.r));
  print("WON");
}

void showGUI() {
  textFont(gooeyFont);
  fill(0);
  textAlign(CENTER);
  text("Number consumed: " + p1.numConsumed, width/5,30);
  text("Total rounds: " + totalRounds, 4*width / 5,30);
}

//ADDS SCORE TO XML FILE
void addScore( int sc ){
  XML xml = loadXML("scores.xml");
  XML newChild = xml.addChild("score");
  newChild.setContent(str(sc));
  saveXML(xml,"scores.xml");
  showHighScores();
}

//RETURNS ARRAY OF TOP TEN SCORES
int[] showHighScores() {
  XML xml = loadXML("scores.xml");
  XML[] children = xml.getChildren("score");
  int[] all_scores = new int[children.length];
  for (int i = 0; i < children.length; i++) {
    String sc = children[i].getContent();
    all_scores[i] = int(sc);
  }
  all_scores = reverse(sort(all_scores));
  int[] top_ten_scores;
  if( all_scores.length > 10 ){
    top_ten_scores = new int[10];
  }
  else{
    top_ten_scores = new int[all_scores.length];
  }
  for( int i = 0; i < top_ten_scores.length; i++ ){
    top_ten_scores[i] = all_scores[i];
  }
  //printArray(top_ten_scores);
  return top_ten_scores;
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
  setup();
  loop();
}
/*
REMOVED THIS BECAUSE IT WAS CAUSING DUPLICATE SCORES TO BE ADDED
WAS ORIGINALLY HAVING ISSUES WITH FRAMECOUNT, BUT CHANGING IT TO SETUP() SEEMS TO HAVE
FIXED IT
void mouseReleased(){
  print(2);
  setup();
  loop();
}*/
