class Point {
  
  int w = 29;
  int h = 29;
  
  int pointx = 15;
  int pointy = 20;  
  
  void pointDisplay() {
    noStroke();
    fill(255,215,0);
    rect(poi1.x*head.blocks, poi1.y*head.blocks, head.blocks, head.blocks);
    //println(point.x, point.y);
  }
}
