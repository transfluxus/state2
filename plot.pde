void setupDiagrams() {
  PVector diagramPos = new PVector();
  PVector  diagramSize = new PVector(width/2, height/2);
  diagrams[0] = new Diagram(diagramPos.get(), diagramSize, "1");
  diagramPos.add(width/2, 0, 0);
  diagrams[1] = new Diagram(diagramPos.get(), diagramSize, "2");
  diagramPos= new PVector(0, height/2);
  diagrams[2] = new Diagram(diagramPos.get(), diagramSize, "3");
  diagramPos.add(width/2, 0, 0);
  diagrams[3] = new Diagram(diagramPos.get(), diagramSize, "4");
  //
  tDiagram = new TimeDiagram(new PVector(20,20),new PVector(width-20,height-20),"");
}

void displayDiagrams() {
  for (Diagram d : diagrams)
    if (d!=null) // test
      d.display();
}

class Diagram {

  HashMap<Integer, Integer> entries = new HashMap<Integer, Integer>();
  GPlot plot;

  Diagram(PVector p, PVector s, String t) {
    plot = new GPlot(ap, p.x, p.y, s.x, s.y);
    plot.activatePointLabels();
    plot.getTitle().setText(t);
    plot.getXAxis().getAxisLabel().setText("Time");
    plot.getYAxis().getAxisLabel().setText("Count");
    plot.setFontColor(color(0));
  }

  void add(int time) {
    int c=1; 
    if (entries.containsKey(time)) 
      c = entries.get(time)+1;
    entries.put(time, c);
    int sz = entries.size();
    GPointsArray pArray = new GPointsArray(sz);
    for (Integer k : entries.keySet ()) {
      int val = entries.get(k);
      pArray.add(new GPoint(k,val ,k+" sec.: "+val));
    }
    plot.setPoints(pArray);
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
    plot.getMainLayer().drawPoints();
    plot.drawLabels();
    plot.endDraw();
  }
}
