// plot
// 1. time/count, 4 graphs (no gender,age)
// 2. age/time(avg),  1 graph( munch gender & experiment)
// 3. gender/time(avg), histogram: 4 categories for the 4 songs, each cat has 3 histograms (f,m,other)

void setupDiagrams() {
  PVector diagramPos = new PVector();
  PVector  diagramSize = new PVector(width, height);
  diagrams[0] = new TimeCountDiagram(diagramPos.get(), diagramSize, "Time/Count");
  diagrams[1] = new AgeDiagram(diagramPos.get(), diagramSize, "Age/Time");
  diagrams[2] = new DummyD(diagramPos.get(), diagramSize, "3");
  //   diagrams[3] = new DummyD(diagramPos.get(), diagramSize, "4");
}

void displayDiagrams() {
  for (Diagram d : diagrams)
    if (d!=null) // test
      d.display();
}

abstract class Diagram {

  GPlot plot;

  Diagram(PVector pos, PVector size, String title) {
    plot = new GPlot(ap, pos.x, pos.y, size.x, size.y);
    plot.activatePointLabels();
    plot.getTitle().setText(title);
    //    plot.getXAxis().getAxisLabel().setText("Time");
    //    plot.getYAxis().getAxisLabel().setText("Count");
    plot.setFontColor(color(0));
  }

  abstract  void add(Data data);

  void display() {
    plot.beginDraw();
    plot.drawBackground();
    plot.drawBox();
    plot.drawXAxis();
    plot.drawYAxis();
    plot.drawTopAxis();
    plot.drawRightAxis();
    plot.drawTitle();
    plot.drawLabels();
  }
}

public class TimeCountDiagram extends Diagram {

  //  ArrayList<HashMap<Integer, Integer>> graphs = new   ArrayList<HashMap<Integer, Integer>>();
  GPointsArray[] points = new GPointsArray[4];
  GLayer[] layers = new GLayer[4];
  color[] clrs = {
    color(255, 0, 0, 150), color(155, 155, 0, 150), color(0, 255, 0, 150), color(0, 0, 255, 150)
  };


  TimeCountDiagram(PVector pos, PVector size, String title) {
    super(pos, size, title);
    for (int i=0; i < 4; i++) {
      points[i] = new GPointsArray();
      //      layers[i] = plot.addLayer("exp "+i, points[i]);
      //     plot.getLayer("exp "+i).setLineColor(clrs[i]);
      //    layers[i].setLineColor(color(255, 0, 0));
    }
    plot.getXAxis().getAxisLabel().setText("Time");
    plot.getYAxis().getAxisLabel().setText("Amount");
  }

  void add(Data data) {
    int time = (int)(data.time/1000);
    int sel = data.soundSel;
    GPointsArray array = points[sel];
    GPoint p = array.getPointWithX(time);
    if (p!=null) {
      p.setY(p.getY()+1);
      p.setLabel("exp"+(sel+1)+ "-"+time+": "+(int)(p.getY()+1));
    } else 
      array.add(time, 1, ("exp"+(sel+1)+ "-"+time+"secs: "+1));
    array.sortX();
    //    GLayer layer =  plot.getLayer("exp "+sel);
    //    layer.setPoints(array );
    // this is so fucked up. cant add points(there is a bug) other then
    // removing the laying and adding a new one.
    // this didnt work: layer.getPointsRef().set(array);    
    plot.removeLayer("exp "+(sel+1));
    GLayer layer =  plot.addLayer("exp "+(sel+1), array);
    layer.setPointColor(clrs[sel]);
    layer.setPointSize(5);
    layer.setLineColor(clrs[sel]);

    //    
    /*    println(layer.getPointsRef().getNPoints());
     if(sel==0);
     for(int i=0; i < layer.getPointsRef().getNPoints();i++ )
     println(layer.getPointsRef().get(i).getX()+","+layer.getPointsRef().get(i).getY()); */
    //   plot.getLayer("layer 1").setLineColor(color(150, 150, 255));
    //    plot.addLayer("exp 2", points1c);
  }

  void display() {
    super.display();
    plot.drawLines();
    plot.drawPoints();
    //    plot.drawFilledContours(GPlot.HORIZONTAL, 0.05);
    plot.endDraw();
  }
}

public class AgeDiagram extends Diagram {

  // mapping: age > list of times (to calc the average)
  HashMap<Integer, ArrayList<Long>> data = new HashMap<Integer, ArrayList<Long>>();
  GPointsArray points = new GPointsArray();

  AgeDiagram(PVector pos, PVector size, String title) {
    super(pos, size, title);
  }

  void add(Data d) {
    int age = d.age;
    // updating the map: data
    if (data.containsKey(age))
      data.get(age).add(d.time);
    else {
      data.put(age, new ArrayList<Long>());
      add(d);
      return;
    }
    // update average time for age:
    ArrayList<Long> times = data.get(age);
    long sum=0;
    for (Long time : times)
      sum +=time;            
    int avgTime = (int)(sum/1000/times.size());    
    //    println(sum,avgTime);
    // adding the point to the plot, or updating existing point
    GPoint p = points.getPointWithX(age);
    String label = "age:"+age+ " - Avg. Time:"+ avgTime;
    if (p!=null) {
      p.setY(avgTime);
      p.setLabel(label);
    } else 
      points.add(age, avgTime, label);
    plot.setPoints(points);
  }

  void display() {
    super.display();
    plot.drawLines();
    plot.drawPoints();
    plot.endDraw();
  }
}


public class DummyD extends Diagram {

  DummyD(PVector pos, PVector size, String title) {
    super(pos, size, title);
  }

  void add(Data d) {
  }

  void display() {
  }
}
