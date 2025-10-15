#include <Servo.h>

Servo motor;
int trigPin = 10;
int echoPin = 11;

void setup() {
  Serial.begin(9600);
  motor.attach(9);

  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);
}

long mesafeOlc() {
  digitalWrite(trigPin, LOW);
  delayMicroseconds(2);
  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);

  long sure = pulseIn(echoPin, HIGH);
  long mesafe = (sure / 2) / 29.1; 
  return mesafe;
}

void loop() {

  for (int aci = 0; aci <= 180; aci++) {
    motor.write(aci);
    delay(20);
    long mesafe = mesafeOlc();
    Serial.print(aci);
    Serial.print(",");
    Serial.println(mesafe);
  }


  for (int aci = 180; aci >= 0; aci--) {
    motor.write(aci);
    delay(20);
    long mesafe = mesafeOlc();
    Serial.print(aci);
    Serial.print(",");
    Serial.println(mesafe);
  }
}
