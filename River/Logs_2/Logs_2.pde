int log1X = 0;
int log1Y = 0;
void setup() {
  size(1000,1000);
  


}

void draw(){
  background(255);
  fill(#711010);
  log1X += 1;
  log1Y += 1;
  //noFill();
  beginShape();
 
  vertex(log1X + 100,log1Y + 100);//1
  vertex(log1X + 200,log1Y + 100);//2
  vertex(log1X + 202,log1Y + 90);//3
  vertex(log1X + 207,log1Y + 90);//4
  vertex(log1X + 209,log1Y + 100);//5
  vertex(log1X + 250,log1Y + 100);//6
  vertex(log1X + 250,log1Y + 105);//7
  vertex(log1X + 240,log1Y + 110);//8
  vertex(log1X + 250,log1Y + 115);//9
  vertex(log1X + 240,log1Y + 120);//10
  vertex(log1X + 250,log1Y + 125);//11
  vertex(log1X + 250,log1Y + 150);
  vertex(log1X + 100,log1Y + 150);

 endShape(CLOSE);
  
  
  
  beginShape();
  
  fill(#FC0F0F);
  vertex(400,400);
  vertex(500,400);
  vertex(480,420);
  vertex(500,439);
  vertex(480,460);
  vertex(500,470);
  vertex(400,470);
  
  endShape(CLOSE);
}
