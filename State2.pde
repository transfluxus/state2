// YOU NEED THIS TWO LIBRARIES. IF COMPILER COMPLAING Sketch>Import Library> Add Library, ... //<>//
import grafica.*;
import ddf.minim.*;
// This library is already in the core included
// IF YOU HAVE NO SERIAL DEVICE (MAKEY MAKEY,ARDUINO) ATTACHED SET useSerial TO FALSE (just above setup)
// ALSO MAKE SURE TO SELECT THE RIGHT PORT IN initSerial  (They will be printed out)
import processing.serial.*;
// ADD SAMPLES BY DRAG AND DROP INTO THIS. EDIT THE PURPLE LINE WITH THE SOUND NAME ACCORDINGLY.
// OR NAME IT "1.mp3" - "4.mp3" AND IT WILL BE AUTOMATICALLY DETECTED (IF THE SAMPLE IN THE LIST DOESNT EXIST)
// sound files (need to be in the data folder, or drop them into this)
String[] sounds = {
  "Frances9.mp3", "Frances9b-final.mp3", "s1.mp3", "marcus_kellis_theme.mp3"
};


// Audio library object,play
Minim minim;
AudioPlayer player;
// starttime
long timer;
// last time estimation
long recTime;

// sketch-states
final int AGESCREEN = -1, GENDERSCREEN = -2, INFOSCREEN = 0, PLAYSCREEN = 1, RESULTSCREEN = 2, STATSSCREEN=3;
// actuall state
int screen = STATSSCREEN;
int soundSelected = 0;
boolean playing;
PVector textPos;
PFont font, font2;
int personId_ = 0;
int experimentId_ = 0;
PImage warningImg;

ArrayList<Data> data = new ArrayList<Data>();

// plots
Diagram[] diagrams = new Diagram[3];
long sketchStart;
// storage into csv
Table table = new Table();

PApplet ap;
boolean useSerial= false;

int age = 18;
int gender = 0; // female, male, other

void setup() {
  //  size(640, 480)
  size(displayWidth, displayHeight);
  ap = this;
  minim = new Minim(this);
  player = minim.loadFile(sounds[soundSelected]);
  font = loadFont("font.vlw");
  font2 = loadFont("font-200.vlw");
  textAlign(CENTER, CENTER);
  textPos = new PVector(width/2, 100);
  warningImg = loadImage("warnung-experiment.gif");
  imageMode(CENTER);
  setupDiagrams();
  //initTable();// add this line and the csv file will be cleared
  setupTable();
  sketchStart = System.currentTimeMillis();
  if (useSerial)
    initSerial();
  // test fills
  //  Data d;
  //  for (int i = 0; i < 200; i++)
  //    d =new Data(0, (long)(60000+random(12000)));
}

void draw() {
  background(0);
  if (screen == AGESCREEN) {
    textFont(font, 35);
    text("How old do you feel?", textPos.x, textPos.y); 
    textFont(font2, 205);
    text(age, textPos.x, textPos.y+150);
  } else if ( screen == GENDERSCREEN) {
    textFont(font, 35);
    text("Gender", textPos.x, textPos.y); 
    textFont(font2, 205);
    String genderS = "";
    if (gender == 0)
      genderS = "Female";
    else if (gender == 1)
      genderS = "Male";
    else if (gender == 2) 
      genderS = "Other";
    text(genderS, textPos.x, textPos.y+150);
  }
  if (screen == INFOSCREEN) {
    textFont(font, 35);
    text("Press start to start the experiment.", textPos.x, textPos.y);
    //    textFont(font2, 235);
    //    text(soundSelected+1, textPos.x, textPos.y+150);
  } else if (screen == PLAYSCREEN) {
    if (playing) {
      long rTime = millis() -  timer;
      //      if ((rTime/600) % 2 == 0)
      image(warningImg, width/2, 200);
      textFont(font, 35);
      text((rTime/1000)+"    "+rTime, textPos.x, textPos.y-70);
      stroke(255, 0, 0);
    }
  } else if (screen == RESULTSCREEN) {
    text("Result: "+recTime +" ms\n Deviation: "+ (long)abs(recTime-60000) + " ms", textPos.x, textPos.y);
    text("More!", 100, 200);  
    text("Done", width-100, 200);
  } else if (screen == STATSSCREEN) {
    displayDiagrams();
  }
}

void keyPressed() {
  //  println(keyCode);
  if (screen == AGESCREEN) {
    screen = GENDERSCREEN;
  } else if (screen == GENDERSCREEN) 
    screen = INFOSCREEN;
  else if (screen == INFOSCREEN) {
    screen =  PLAYSCREEN;
    startRec();
    /*  // 1 .. 4
     if (keyCode >= 49 && keyCode <= 57) {
     setAndLoad(min(keyCode - 49, sounds.length-1));
     }
     if (keyCode == LEFT) 
     setAndLoad(0);
     else if (keyCode == RIGHT)
     setAndLoad(1);
     else if (keyCode == UP)
     setAndLoad(2);
     else if (keyCode == DOWN)
     setAndLoad(3);
     else if (key==' ') {
     startRec();
     } else if (key=='s') {
     screen = STATSSCREEN;
     sendSerial(OFF);
     }
     */
  } else if (screen == PLAYSCREEN && key==' ') {
    endRec();
  } else if (screen == RESULTSCREEN) {
    // a key for "more" one for "done" 
    if (key=='d') {
      screen = STATSSCREEN;
    } else if (key=='m') {
      screen = INFOSCREEN;
    }    
    sendSerial(soundSelected);
  } else if (screen == STATSSCREEN) {
    // anykey brings it back 
    screen = AGESCREEN;
    sendSerial(soundSelected);
  }
}

void setAndLoad(int selected) {
  if (playing)
    return;
  soundSelected = selected;
  if (!new File(sketchPath+"/data/"+sounds[soundSelected]).exists()) {
    if (new File(sketchPath+"/data/"+(soundSelected+1)+".mp3").exists())
      player = minim.loadFile((soundSelected+1)+".mp3");
    else
      soundSelected = 0;
  } else
    player = minim.loadFile(sounds[soundSelected]);
  sendSerial(selected);
}

void startRec() {
  playing = true;
  player.play();
  timer = millis();
  screen = PLAYSCREEN;
  sendSerial(BLINK);
}

void endRec() {
  playing = false;
  player.pause();
  recTime  =millis() -  timer;
  player.rewind(); 
  store();
  // println(recTime);
  screen = RESULTSCREEN;
  setAndLoad((int) random(4));
  sendSerial(OFF);
  experimentId_++;
}

void done() {
  personId_++;
} 

void store() {
  Data d = new Data(soundSelected, recTime, age, gender);
  d.add(true);
}


public class Data {
  int personId, experimentId;
  int soundSel;
  long time;
  int date;
  int age, gender;

  public Data(int soundSel, long recTime, int age, int gender) {
    this.soundSel  =soundSel;
    this.time = recTime;
    this.personId = personId_;
    this.experimentId = experimentId_;
    this.date =(int)( System.currentTimeMillis() - sketchStart);
    this.age = age;
    this.gender = gender;
  }

  void add(boolean toTable) {
    data.add(this);
    addToPlot();
    if (toTable)
      addToTable();
  }

  void addToPlot() {
    //    int timeS = (int)(time/1000);
    for(int i=0; i < 1;i++)
    diagrams[i].add(this);
  }

  void addToTable() {
    TableRow newRow = table.addRow();
    newRow.setInt("exp-id", experimentId);
    newRow.setInt("person-id", personId);
    newRow.setInt("age", age);
    newRow.setInt("gender", gender);
    newRow.setInt("song", soundSel);
    newRow.setLong("time", time);
    newRow.setLong("date", date);
    saveTable(table, "data/stats.csv");
  }
}
