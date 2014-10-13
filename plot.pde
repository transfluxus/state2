// plot
// 1. time/count, 4 graphs (no gender,age)
// 2. age/time(avg),  1 graph( munch gender & experiment)
// 3. gender/time(avg), histogram: 4 categories for the 4 songs, each cat has 3 histograms (f,m,other)


void setupDiagrams() {
  PVector diagramPos = new PVector();
  PVector  diagramSize = new PVector(width/2, height/2);
  diagrams[0] = new TimeCountDiagram(diagramPos.get(), diagramSize, "Time/Count");
  diagramPos.add(width/2, 0, 0);
  diagrams[1] = new DummyD(diagramPos.get(), diagramSize, "2");
  diagramPos= new PVector(0, height/2);
  diagrams[2] = new DummyD(diagramPos.get(), diagramSize, "3");
  diagramPos.add(width/2, 0, 0);
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

  abstract  void display();
}

public class TimeCountDiagram extends Diagram {

  //  ArrayList<HashMap<Integer, Integer>> graphs = new   ArrayList<HashMap<Integer, Integer>>();
  GPointsArray[] points = new GPointsArray[4];
  GLayer[] layers = new GLayer[4];
  color[] clrs = {
    color(255, 0, 0), color(255, 255, 0), color(0, 255, 0), color(0, 0, 255)
  };


  TimeCountDiagram(PVector pos, PVector size, String title) {
    super(pos, size, title);
    for (int i=0; i < 4; i++) {
      //    graphs.add(new HashMap<Integer, Integer>());
      points[i] = new GPointsArray();
      //    points[i].add(50, 5);
      layers[i] = plot.addLayer("exp "+i, points[i]);
      plot.getLayer("exp "+i).setLineColor(clrs[i]);
      //    layers[i].setLineColor(color(255, 0, 0));
    }
    //         

    plot.getXAxis().getAxisLabel().setText("Time");
    plot.getYAxis().getAxisLabel().setText("Amount");
  }

  void add(Data data) {
    int time = (int)(data.time/1000);
    int sel = data.soundSel;
    println("adding "+sel);
    GPointsArray array = points[sel];
    for (int i=0; i <4; i++)
      print(points[i].getNPoints() +" ");
    println();
    GPoint p = array.getPointWithX(time);
    if (p!=null)
      p.setY(p.getY()+1);
    else 
      array.add(time, 1 );
    //    GLayer layer =  plot.getLayer("exp "+sel);
    //    layer.setPoints(array );
    plot.removeLayer("exp "+sel);
    plot.addLayer("exp "+sel, array);
    //    layer.getPointsRef().set(array);
    /*    println(layer.getPointsRef().getNPoints());
     if(sel==0);
     for(int i=0; i < layer.getPointsRef().getNPoints();i++ )
     println(layer.getPointsRef().get(i).getX()+","+layer.getPointsRef().get(i).getY()); */
    //   plot.getLayer("layer 1").setLineColor(color(150, 150, 255));
    //    plot.addLayer("exp 2", points1c);
  }

  void display() {
    plot.beginDraw();
    plot.drawBackground();
    plot.drawBox();
    plot.drawXAxis();
    plot.drawYAxis();
    plot.drawTopAxis();
    plot.drawRightAxis();
    plot.drawTitle();
    plot.drawLines();
    plot.drawPoints();
    plot.drawFilledContours(GPlot.HORIZONTAL, 0.05);
    plot.drawLabels();
    plot.endDraw();
    //    println("nag");
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
