class Head{
  ArrayList<Integer> x = new ArrayList<Integer>();
  ArrayList<Integer> y = new ArrayList<Integer>();
  
  //Movement Array
  /* 
  Anlge of snake
  0 = Down
  1 = Up
  2 = Right
  3 = Left
  */
  int angle = 2;
  int newAngle;
  float speed;
  //               0  1  2   3
  int[]xDirection={0, 0, 1, -1};
  int[]yDirection={1, -1, 0, 0};
  
  //Size Controllers
  int blocks = 24;
   
  void update(){
   //Draws Snake
   fill(0);
   noStroke();
   for(int i = 0; i < x.size(); i++){ //Loops each block of the snake that is in the arraylist
   rect(x.get(i)*blocks, y.get(i)*blocks, blocks, blocks);
   }
   stroke(0);
   //Prints location of point.h and point.w (30, 30)
   println("x: " + x.get(0));
   println("y: " + y.get(0));

   //Gameplay
   if(!stopPlay && !startScreen) {
     //If 10 goes up into 60 and leaves a rest of 0 = true
     if(frameCount%speed == 0) {
       if(newAngle != -1){
         angle = newAngle;
       }
       
       x.add(0, x.get(0) + xDirection[angle]);
       y.add(0, y.get(0) + yDirection[angle]);

       //If point is picked up, then spawn random place
       if(x.get(0) == point.pointx && y.get(0) == point.pointy){
        for(int i = 0; i < x.size(); i++)
          if(x.get(i) != point.pointx || y.get(i) != point.pointy){
           pointC.play();
           point.pointx = (int)random(2, point.w);
           point.pointy = (int)random(2, point.h);
           println(x.size());
          } 
         }else { //Removes the tail behind the player
           x.remove(x.size()-1);
           y.remove(y.size()-1);
         }
        } //Frame count end
        
       // DYING 
        //Die if in/over walls
        if(x.get(0) >= point.w || y.get(0) >= point.h || x.get(0) <= 1 || y.get(0) <= 1){
          death.play();
          stopPlay = true;
          angle = 2; //Sets starting angle to right
          bestScore = x.size();
        }
        
        //Die in self
        for(int i = 1; i < x.size(); i++)
        if(x.get(0) == x.get(i) && y.get(0) == y.get(i)){
          death.play();
          stopPlay = true;
          angle = 2; //Sets starting angle to right
          bestScore = x.size();
        }
       // DYING END
       }
     } //Update end
    
  
  void controls(){
    // if keyCode == D/U/R/L != opposite D/U/R/L if true : if false
    newAngle = keyCode == DOWN && angle !=1 ? 0 :(keyCode == UP && angle !=0 ? 1 :(keyCode == RIGHT && angle !=3 ? 2 :(keyCode == LEFT && angle !=2 ? 3:-1)));
    }
}
