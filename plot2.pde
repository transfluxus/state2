long sketchStart;


public class TimeDiagram extends Diagram {

  long actTime;

  int timePerFrame = 1; // secs per frame

  String layerNames[] = {
    "s1", "s2", "s3", "s4"
  };

  GPointsArray[] gpArrays = new GPointsArray[4];

  ArrayList<TimePlotData> data = new ArrayList<TimePlotData>();

  TimeDiagram(PVector p, PVector s, String t) {
    super(p, s, t);
    for (int i=0; i <4; i++) 
      gpArrays[i] = new GPointsArray();
    sketchStart = System.currentTimeMillis();
  }

  void add(TimePlotData tpd) {
    data.add(tpd);
  }

  void reset() {
    actTime = 0;
  }
}


class TimePlotData {

  int sel, time, date;

  TimePlotData(int sel, int time, int date) {
    this.sel = sel;
    this.time = time;
    this.date = date;
  }
}
