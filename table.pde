

// reads the csv file and adds the 
void setupTable() {
  table =  loadTable("stats.csv", "header");
  if (table.getRowCount() >= 1) {
    TableRow row=null;
    for (int i=0; i < table.getRowCount (); i++) {
      row = table.getRow(i);
      new Data(row.getInt("song"), row.getInt("time"), row.getInt("age"), row.getInt("gender")).addToPlot();
    }
    experimentId_ = 1 + row.getInt("exp-id");
    personId_ = 1 + row.getInt("person-id");
  }
}



// only call this in the setup, when new columns are added
void initTable() {
  table.addColumn("exp-id");
  table.addColumn("person-id");  
  table.addColumn("age");  
  table.addColumn("gender");  
  table.addColumn("song");
  table.addColumn("time");
  table.addColumn("date");
  saveTable(table, "data/stats.csv");
}
