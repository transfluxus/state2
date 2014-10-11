Serial serial;

void initSerial() {
  String[] ports = Serial.list();
  for (int i=0; i < ports.length; i++)
    println(i+": "+ports[i]);
  // 2nd parameter is the port
  serial = new Serial(this, Serial.list()[0], 9600);
  serial.bufferUntil('\n');
}

final int LED1=0, LED2=1, LED3=2, LED4=3, BLINK=4, OFF=5;

void sendSerial(int n) {
  if (useSerial)
    serial.write(n);
}
/*
void serialEvent(Serial e) {
  String s = e.readString();
  print(s);
}
*/
