// reads the csv file and adds the 
void setupTable() {
  Table oldTable =  loadTable("stats.csv", "header");
  table.clearRows();
  if (table.getRowCount() >= 1) {
    TableRow row=null;
    for (int i=0; i < table.getRowCount (); i++) {
      row = table.getRow(i);
      new Data(row.getInt("song"), row.getInt("time"), row.getInt("age"), row.getInt("gender")).add(false);
    }
    experimentId_ = 1 + row.getInt("exp-id");
    personId_ = 1 + row.getInt("person-id");
  }
}

void cleanOutLiners(int min, int max) {
  writeHeader();  
  if (table.getRowCount() >= 1) {
    TableRow row=null;
    for (int i=0; i < table.getRowCount (); i++) {
      row = table.getRow(i);
      long time = table.getRow(i).getInt("time");
      if (time >= min && time <= max) {
        new Data(row.getInt("song"), row.getInt("time"), row.getInt("age"), row.getInt("gender")).add(false);
        row = table.getRow(i);
      } else {
      println("removing: "+row.getInt("exp-id")+","+row.getLong("time"));
      }
    }
    if (row != null) {
      experimentId_ += row.getInt("exp-id");
      personId_ += row.getInt("person-id");
    }
  }
    saveTable(table, "data/stats.csv");
}

// only call this in the setup, when new columns are added
void initTable() {
  writeHeader();
  saveTable(table, "data/stats.csv");
}

void writeHeader() {
  table.addColumn("exp-id");
  table.addColumn("person-id");  
  table.addColumn("age");  
  table.addColumn("gender");  
  table.addColumn("song");
  table.addColumn("time");
  table.addColumn("date");
}
