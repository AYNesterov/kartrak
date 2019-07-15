import processing.serial.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

Serial myPort; 
String val = null; 
int sensor1, sensor2;
int[] nums;
JSONArray values;
int r;
Minim beepSound;
AudioPlayer beepPlayer;
PFont mono;
PImage img;
int delay_true = 0;

void setup()
{
  fullScreen();
  background(255);
  textAlign(CENTER, CENTER);
  values = loadJSONArray("barcode.json");
  String portName = Serial.list()[3];
  myPort = new Serial(this, portName, 9600);
  beepSound = new Minim(this);
  beepPlayer = beepSound.loadFile("data/beep.wav");
}


void draw(){
  
  if (delay_true > 0) { 
    delay_true--;
    println(delay_true);
  }
  
  // ------- GET DATA FROM ARDUINO -------//
  
  if ( myPort.available() > 0) { 
    val = myPort.readStringUntil('\n'); 
  } 
  
  
  // ------- CREATE STRIPES -------//

  if (delay_true == 0){
    int myArray_w[] = {20, 40, 60, 80}; // width of the stripes
    int myArray_color[] = {0,255}; // color of the stripes
    int randw = (int)random(myArray_w.length);
    int randx = (int)random(1,200) * 10; // x position of the stripes
    int rand_color = (int)random(myArray_color.length);
    fill(myArray_color[rand_color]);
    noStroke();
    rect(randx,0,myArray_w[randw],displayHeight); // stripe
  }
  float text_size_start=0;
  img = loadImage("bdfbrh.png");
  String message="WHAT YOU"; // a message goes here
  
  while (textWidth(message)<width-6) { // adjusting message to the screen resolution
    text_size_start++;
    textSize(text_size_start);
    mono = createFont("PTM55FT.ttf", text_size_start, false);
  }
  
  fill(255);
  textFont(mono);
  
  // ------- JSON LOGIC -------//
  
  r = int(random(15));
  JSONObject barcode = values.getJSONObject(r);
  
  img = loadImage(barcode.getString("image"));
  message = barcode.getString("word");
  message = message.toUpperCase();
  
  // ------- CONDITIONAL LOGIC FOR SENSORS -------//

  if (val != null){
    String clean = val.replaceAll("[^\\d,]", "" );
    nums = int(split(clean, ','));
    
    if(nums.length > 1){
      sensor1 = int(nums[0]);
      sensor2 = int(nums[1]);
      
      if (sensor2 < 170 && sensor2 != 0 && delay_true == 0) { // THE LEFT ONE
        beepPlayer.rewind();
        beepPlayer.play();
        //println("sensor 2: ");
        //print(sensor2);
        image(img, 0, 0, width, height);
        text(message, width/2+10, height/2); // show text
        delay_true = 300;
      }
      if (sensor1 < 170 && sensor1 != 0 && delay_true == 0) { // THE RIGHT ONE
        beepPlayer.rewind();
        beepPlayer.play();
        //println("sensor 1: ");
        //println(sensor1);
        image(img, 0, 0, width, height);
        text(message, width/2+10, height/2); // show text
        delay_true = 300;
      }
    }
  } 
  
}
