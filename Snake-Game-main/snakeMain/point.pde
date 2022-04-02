class Point {
  
  int w = 29;
  int h = 29;
  
  int pointx = 15;
  int pointy = 20;
  
  //PVector point = new PVector((int)(random(0, w)), (int)(random(0, head.h)));
  
  
  void pointDisplay() {
    noStroke();
    fill(255,215,0);
    rect(pointx*head.blocks, pointy*head.blocks, head.blocks, head.blocks);
    //println(point.x, point.y);
  }
}
