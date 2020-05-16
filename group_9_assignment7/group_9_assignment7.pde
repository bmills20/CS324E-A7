import processing.sound.*;
import controlP5.*;
SoundFile pop;
Circle[] circles = new Circle[50];
Player p1;
Power pwr1, pwr2;
PFont loseFont, gooeyFont, invisFont, scoreFont, buttonFont;
int totalRounds = 0;
int turnCount = 0;
ArrayList numDead = new ArrayList<Integer>();
ControlP5 cp5;
controlP5.Bang b;
controlP5.Textfield txt;
PShape endcolor;
String plName, name;

void setup() {
  numDead.clear();
  loseFont = createFont("AYearWithoutRain.ttf", 50, true);
  scoreFont = createFont("AYearWithoutRain.ttf", 35, true);
  buttonFont = createFont("AYearWithoutRain.ttf", 15, true);
  gooeyFont = createFont("AYearWithoutRain.ttf", 25, true);

  pop = new SoundFile(this, "popsound.mp3");
  size(1000, 800);
  cp5 = new ControlP5(this);
  frameRate(24);
  for ( int i = 0; i < circles.length; i++ ) {
    circles[i] = new Circle( random(15, 25), random(12, 24) );
  }
  p1 = new Player(25);
  shapeMode(CORNERS);
  fill(230);
  endcolor = createShape(RECT, 0, 0, 1000, 800);
  shapeMode(CORNER);
  if (plName == null || plName.isEmpty()) {
    textFont(loseFont);
    textAlign(CENTER);
    fill(0);
    text("Please enter your name below:", width/2, 3*height/9);
    txt = cp5.addTextfield("Your Name Here").setPosition(200, 400).setSize(600, 80).setAutoClear(true).setColorCaptionLabel(color(0, 0, 0));
    txt.getCaptionLabel().setFont(buttonFont);
    b = cp5.addBang("Submit").setPosition(200, (6 * height /9)-20).setSize(80, 40).setColorCaptionLabel(color(0, 0, 0));
    b.getCaptionLabel().setFont(buttonFont);
  }
}

void draw() {
  if (plName != null && !plName.isEmpty()) {
    runGame();
  }
}

void runGame() {
  background(230);
  if ( turnCount % 500 == 0 ) {
    pwr1 = new Power();
    pwr2 = new Power();
  }
  pwr1.update();
  pwr2.update();
  turnCount += 1;
  p1.update();

  for ( int i = 0; i < circles.length; i++ ) {
    if (circles[i].isAlive == false) {
      if (!numDead.contains(i)) {
        numDead.add(i);
      }
    }
    if (numDead.size() >= 50) {
      noLoop();
      winGame();
      break;
    }
  }
  p1.shouldAbsorbPower(pwr1);
  p1.shouldAbsorbPower(pwr2);
  for ( Circle c1 : circles ) {
    c1.update();
    c1.shouldAbsorbPower(pwr1);
    c1.shouldAbsorbPower(pwr2);
    p1.shouldAbsorb(c1);
    for ( Circle c2 : circles ) {
      c1.shouldAbsorb(c2);
      c2.shouldAbsorb(c1);
    }

    if (c1.playerDead(p1) == true) {
      endGame();      
      noLoop();
      break; //Break out of for loop, necessary so no circles will be generated upon loss
    }
  }
  p1.updateCooldown();
  showGUI();
}

void endGame() {
  totalRounds++;
  background(230);
  textFont(loseFont);
  fill(0);
  textAlign(CENTER);
  text("Sorry, "+plName+", You Lose! \n Final size: " + round(p1.r), (width/2) - 95, 3*height/9);
  text("Click anywhere to play again.", (width/2) - 95, 5 * height /9);
  textFont(scoreFont);
  addScore(round(p1.r));
  textAlign(LEFT);
  text("High scores:", width - width/4, height/8);
  textFont(buttonFont);
  String[] highscores = showHighScores();
  int w = 0;
  for ( int i = 0; i < 10; i++ ) {
    text(highscores[i], width - width/4, height/8 + (w += 40));
  }

}

void winGame() {
  totalRounds++;
  background(230);
  textFont(loseFont);
  fill(0);
  textAlign(CENTER);
  textFont(scoreFont);
  text("Congrats, "+plName+", You Win! \n Final size: " + round(p1.r), (width/2) - 95, 3*height/9);
  text("Click anywhere to play again.", (width/2) - 95, 5 * height /9);
  textFont(scoreFont);
  addScore(round(p1.r));
  textAlign(LEFT);
  text("High scores:", width - width/4, height/8);
  textFont(buttonFont);
  String[] highscores = showHighScores();
  int w = 0;
  for ( int i = 0; i < 10; i++ ) {
    text(highscores[i], width - width/4, height/8 + (w += 40));
  }

}

void Submit() {
  plName = cp5.get(Textfield.class, "Your Name Here").getText();
  b.hide();
  txt.hide();
}

void showGUI() {
  textFont(gooeyFont);
  fill(0);
  textAlign(CENTER);
  text("Number consumed: " + p1.numConsumed, width/5, 30);
  text("Total rounds: " + totalRounds, 3*width / 4, 30);
  if (p1.soundOn == true) {
    text("Sound on", width-65, 30);
  } else { 
    text("Sound off", width-65, 30);
  }
  textSize(18);
  text("Q toggle sound", width-65, 45);
}

//ADDS SCORE TO XML FILE
void addScore( int sc ) {
  XML xml = loadXML("scores.xml");
  XML newChild = xml.addChild("score");
  newChild.setContent(str(sc)+"    -    "+plName);
  saveXML(xml, "scores.xml");
}

//RETURNS ARRAY OF TOP TEN SCORES
String[] showHighScores() {
  XML xml = loadXML("scores.xml");
  XML[] children = xml.getChildren("score");
  String[] all_scores = new String[children.length];
  int[] matches = new int[children.length];
  
  for (int i = 0; i < children.length; i++) {
    String sc = children[i].getContent();
    all_scores[i] = sc;
    matches[i] = i;
  }
  //String[] doubles = sc.split("\\s+");
  //int actualscore = parseInt(doubles[0]);
  //all_scores.sort(key=lambda x: int(x.split(" ")[0]));
  //all_scores = reverse(sort(sc));
  //sorted(
  all_scores = reverse(sort(all_scores));
  String[] top_ten_scores;
  if ( all_scores.length > 10 ) {
    top_ten_scores = new String[10];
  } else {
    top_ten_scores = new String[all_scores.length];
  }
  for ( int i = 0; i < top_ten_scores.length; i++ ) {
    top_ten_scores[i] = all_scores[i];
  }
  //printArray(top_ten_scores);
  return top_ten_scores;
}

void keyPressed() {
  if ( key == 'p' || key == 'P' ) {
    looping = !looping;
    textFont(gooeyFont);
    fill(0);
    textAlign(CENTER);
    text("PAUSED", width/2, height/2);
  }
  if (key == 'q' || key == 'q') {
    p1.soundOn = !p1.soundOn;
  } else {
    p1.keyPressed();
  }
}

void keyReleased() {
  p1.keyReleased();
}

void mousePressed() {
  if (!((mouseX >= 190 && mouseX <= 810) && (mouseY >= 380 && mouseY <= 500))) {
    if (!((mouseX >= 190 && mouseX <= 290) && (mouseY >= 500 && mouseY <= 560))) {
      setup();
      loop();
    }
  }
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
