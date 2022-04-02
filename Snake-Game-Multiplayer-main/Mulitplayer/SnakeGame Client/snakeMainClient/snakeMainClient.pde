import websockets.*;

WebsocketClient wsc;

Head head = new Head();
Point point = new Point();
playerServer playerServer = new playerServer();

int time;

//Startscreen
PImage playButton;
PImage startImage;
PImage menuButton;
PImage endImage;
PFont pixelFont;

// Game state
public boolean stopPlay;
public boolean restartPlay;
public boolean startScreen;

//Score best
public int bestScore;
int oldBest;

//Buttons
int rectX; 
int rectY;
color baseColor = color(137, 166, 105);
color currentColor = baseColor;
boolean rectOverPlay = false;
boolean rectOverMenu = false;

//Levels / Difficulty
int lvl;
String lvlText;
PImage rightArrow;
PImage leftArrow;
int rightArrowX = 245;
int rightArrowY = 372;
int leftArrowX = 27;
int leftArrowY = 372;
boolean overRight = false;
boolean overLeft = false;
boolean up;
boolean down;

int sx1; 
int sy1;
float px1;
float py1;
PVector poi1;

void setup(){
  size(720, 720);
  
  wsc= new WebsocketClient(this, "ws://localhost:8025/hello");
  
  time = 0;
  lvl = 2;
  
  stopPlay = false;
  restartPlay = true;
  startScreen = true;
  
  playButton = loadImage("Data/playButton.png");
  startImage = loadImage("Data/startScreen.png");
  endImage = loadImage("Data/endScreen.png");
  menuButton = loadImage("Data/menuButton.png");
  leftArrow = loadImage("Data/leftArrow.png");
  rightArrow = loadImage("Data/rightArrow.png");
  pixelFont = createFont("Data/Windows Regular.ttf", 24);
  textFont(pixelFont, 30);
  
  //Head Starting Placement
  head.x.add(15);
  head.y.add(10);
}

void webSocketEvent(String msg){
   println(msg);
  
   JSONObject snake = parseJSONObject(msg);
   sx1 = snake.getInt("x1");
   sy1 = snake.getInt("y1");
   poi1 =new PVector (snake.getFloat("pointx1"),snake.getFloat("pointy1"));
   
}

void draw() {
  background(baseColor);
  
  //Multiplayer Stuff
  JSONObject snake = new JSONObject();
  for(int i = 0; i < head.x.size(); i++)
  snake.setFloat("x2", head.x.get(0));
  snake.setFloat("y2", head.y.get(0));
  snake.setInt("size", head.x.size());
  snake.setFloat("pointx2", point.pointx);
  snake.setFloat("pointy2", point.pointy);
  wsc.sendMessage(snake.toString());
  
  bupdate(mouseX, mouseY);
  if(bestScore > oldBest){
    oldBest = bestScore;
  }
  if (stopPlay) {
    //GAME OVER SCREEN //
       background(endImage);
       textAlign(CENTER);
       textSize(40);
       fill(255);
         //text("GAME OVER", 360, 280 );
       text("Score: " + head.x.size(), 220, 340);
       text("Best: " + oldBest, 500, 340);
         //text("Press SPACE to play again", 360, 440);
       textSize(10);  
       text("Credit to: Demu", 30, 10);
       if (keyPressed&&key == ' ') {
         head.x.clear(); head.y.clear();
         head.x.add(15); head.y.add(10);
         point.pointx = 15; point.pointy = 20;
         bestScore = oldBest;
         stopPlay = false;
       }
       //Menu button
       rectX = 230;
       rectY = 330;
       image(menuButton, rectX, rectY);
       
  } else if(startScreen) {
    background(startImage);
    textAlign(LEFT);
    textSize(10);
    text("Credit to: Demu", 2, 10);
    
    //Level / Difficulty
    textSize(55);
    text("Difficulty", 75, 420);
    image(rightArrow, rightArrowX, rightArrowY);
    image(leftArrow, leftArrowX, leftArrowY);
    textSize(40);

    switch(lvl){
      case 1:
        lvlText = "Boa";
        head.speed = 15;
        text(" " + lvlText, 115, 460);
        break;
      case 2:
        lvlText = "Python";
        head.speed = 10;
        text(" " + lvlText, 95, 460);
        break;
      case 3:
        lvlText = "Mamba";
        head.speed = 5;
        text(" " + lvlText, 95, 460);
        break;
      default:
        text("ERROR: Restart Game", 95, 460);
        println("ERROR");
        break;
      }
      
    //Play button
    rectMode(CORNER);
    rectX = 30;
    rectY = 250;
    stroke(0);
    image(playButton, rectX, rectY);
      
  } else {
  head.update();
  point.pointDisplay();
  playerServer.plySUp();
  
  //Outskirts
  rectMode(CENTER);
  fill(83, 102, 64);
  noStroke();
  rect(0, 0, 1440, 72);
  rect(0, 0, 72, 1440);
  rect(720, 720, 72, 1440);
  rect(0, 720, 1440, 72);
  stroke(0);
  
  
  //In-Game Score
    textAlign(LEFT);
    textSize(25);
    //Outline maker - https://forum.processing.org/two/discussion/16700/how-to-outline-text
      fill(0);
      for(int i = -1; i < 2; i++){
      text("Score: " + head.x.size(), 40+i, 25);
      text("Score: " + head.x.size(), 40, 25+i);
      }
      fill(255);
      text("Score: " + head.x.size(), 40, 25);
      fill(0);
      for(int i = -1; i < 2; i++){
      text("Best: " + oldBest, 40+i, 710);
      text("Best: " + oldBest, 40, 710+i);
      }
      fill(255);
      text("Best: " + oldBest, 40, 710);
  
  
  //Draws stationary stuff
  time+=1;
  fill(50, 168, 111);
  }
  rectMode(CENTER);
}

void keyPressed(){
  head.controls();
}

void mousePressed() {
  if (startScreen && rectOverPlay) {
    startScreen = false;
  }
  if (stopPlay && rectOverMenu) {
    stopPlay = false;
    head.x.clear(); head.y.clear();
    head.x.add(15); head.y.add(10);
    point.pointx = 15; point.pointy = 20;
    startScreen = true;
  }
  if(startScreen && overRight && lvl != 3){
    lvl++;
  }
  if(startScreen && overLeft && lvl != 1){
    lvl--;
  }
}

void bupdate(int x, int y) {
    rectOverPlay = false;
    rectOverMenu = false;
    overRight = false;
    overLeft = false;
  if ( overRect(rectX, rectY, 256, 108) ) {
    rectOverPlay = true;
    rectOverMenu = true;
  }
  if ( overRightArrow(rightArrowX, rightArrowY, 45, 70) ) {
    overRight = true;
    overLeft = false;
  }
  if ( overLeftArrow(leftArrowX, leftArrowY, 45, 70) ) {
    overLeft = true;
    overRight = false;
  }
}

boolean overRect(int x, int y, int width, int height)  {
  if (mouseX >= x && mouseX <= x+width && mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  }
}

boolean overRightArrow(int x, int y, int width, int height)  {
  if (mouseX >= x && mouseX <= x+width && mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  }
}

boolean overLeftArrow(int x, int y, int width, int height)  {
  if (mouseX >= x && mouseX <= x+width && mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  }
}
