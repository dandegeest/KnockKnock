import processing.serial.*;
import garciadelcastillo.dashedlines.*;

String[] columns = {"Timestamp", "Command"}; // Modify this array to match your data
String filename = "data/tkdata.csv"; // Name of the CSV file to save
DataManager data;
String version = "TK";

DashedLines dash;
float dashDist = 0;
Serial sPort;
float knock = 50;
String message;

int currS = 0;
int currY = 0;
int gridX = 0;
int gridY = 0;
int knockDecay = 1;

int x;
int y;

int ss = 50;

float factor = 1;
float delay = 5;
int octave = 0;

void setup()
{
  size(1200, 800);
  //fullScreen();
  gridX = width / ss;
  gridY = height / ss;
  //frameRate(30);
  
  x = width/2;
  y = height/2;
  
  dash = new DashedLines(this);
  dash.pattern(30, 10);
  
  data = new DataManager();
  data.createCsvFile(columns);

  printArray(Serial.list());
  int comPort = -1;
  String[] ports = Serial.list();
  for (int i = 0; i < ports.length; i++) {
    if (ports[i].equals("COM6")) {
      comPort = i;
      break; // If found, exit the loop
    }
  }
  
  if (comPort > 0) {
    println("OPENPORT:", Serial.list()[comPort]);
    sPort = new Serial(this, Serial.list()[comPort], 9600);
  }
  
  background(0);
  noLoop();
}

void exit() {
  data.saveFile(filename);
  if (sPort != null) {
    sPort.stop();
    sPort.dispose();
  }
}

int draw0Min = 700;
int draw1Min = 800;
int draw2Min = 900;
int draw3Min = 1000;

void draw() {
  draw0();
  
  if (knock > draw1Min)
    draw1();
  
  if (knock > draw2Min)
    draw2();
  
  if (knock > draw3Min)
    draw3();
    
  currS++;
  if (currS > gridX)  {
    currS = 0;
    currY += ss;
  }
  
  if (currY > height) {
    println("Saving");
    saveFrame("trainframes/image" + version + "#########.png");
    currY = 0;
    background(0);
  }
}

void draw0() {
  rectMode(CENTER);
  noFill();
  stroke(map(knock, draw0Min, draw0Min+200, 128, 255), 0, 0);
  rect(currS * ss, currY, 5, 5);
}

void draw1() {
  rectMode(CENTER);
  
  float f = map(knock, draw1Min, draw1Min+200, 0, 255);

  float size = min(map(knock, draw1Min, draw1Min+200, 0, ss), ss);
  strokeWeight(1);

  stroke(f);
  noFill();
  if (knock > 1300)
    strokeWeight(2);
  rect(currS * ss, currY, size, size);  
}

void draw2() {  
  ellipseMode(CENTER);
  rectMode(CENTER);
  float c = map(knock, draw2Min, draw2Min+200, 0, 200) * factor;
  float s = map(knock, draw2Min, draw2Min+200, 0, height);
  //float s = map(angleY, 0, 1000, 20, 0);
  noFill();
  strokeWeight(1);
  stroke(c, floor(255-c), random(255));
  ellipse(x, y, s, s);
}

void draw3() {
   noFill();
   stroke(#CC7722);
   strokeCap(SQUARE);
   float by = map(knock, draw3Min, draw3Min+200, 0, height);
   dash.pattern(2, 2);
   strokeWeight(1.5);
   //dash.line(currS * ss, currY, mouseX, mouseY);

   dash.bezier(0, height/2, random(width), random(height), currS * ss, currY, width, by); 
   //dash.offset(dashDist);
   dashDist += 1;
}

void mousePressed() {
  if (mouseButton == LEFT) {
    int r = (int)map(mouseX, 0, width, 0, 127);
    sPort.write("CC:" + "111:15:" + r + "\n");
  }
  else if (mouseButton == RIGHT) { 
  }
}

void keyPressed() {
  if (keyCode == LEFT) {
    knockDecay += 10;
    sPort.write("OCTAVE:" + octave + "\n");
  }
  
  if (keyCode == RIGHT) {
    knockDecay -= 10;
    sPort.write("OCTAVE:" + octave + "\n");
  }
  
  if (keyCode == ENTER) {
    println("Saving2");
    saveFrame("trainframes/image" + version + "#########.png");
  }
}

void mouseWheel(MouseEvent event) {
  // Adjust the scale factor based on the mouse wheel movement
  float delta = event.getCount();
  if (delta > 0) factor += .1;
  else factor -= .1;
}

void serialEvent(Serial port) {
  //Read from port
  String inString = port.readStringUntil('\n');
  if (inString != null) {
    //Trim
    inString = inString.trim();
    //Record it
    String[] values = new String[2];
    values[0] = Long.toString(System.currentTimeMillis());
    values[1] = inString;
    data.addRow(values);
    // Process the command
    String[] command = inString.split(":");
    switch(command[0]) {
      case "KNOCK":
        //println(inString);
        onKnockCommand(float(command[1]));
        break;
      case "EXTCMD":
        println(inString);
        break;
      case "CC":
        println(inString);
    }
  }
}

void onKnockCommand(float k) {
  println("KNOCK:", k);
  knock = k; //map(k, 0, 65536, 0, 5000);
  redraw();
}
