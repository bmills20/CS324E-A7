class Power extends Circle{
  Power(){
    super(5, 0);
    c = color(255,0,0);
  }
  
  void update(){
    ellipseMode(RADIUS);
    fill(c);
    ellipse(x, y, r, r);
  }
}
