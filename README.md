Arduino-Based Real-Time Sonar (Radar) System

A real-time radar system using Arduino, ultrasonic sensor, and servo motor. It scans the environment, measures object distances, and visualizes them on a dynamic radar interface in Processing.

Features

Real-time scanning: Servo sweeps ultrasonic sensor from 0° to 180°.

Distance measurement: Detects objects and sends distance data via serial communication.

Dynamic visualization: Processing sketch displays polar-to-Cartesian conversion, radar sweep line, distance rings, and fading effect.

Hardware

Arduino board (Uno, Nano, etc.)

Ultrasonic sensor (HC-SR04)

Servo motor (compatible with Arduino PWM)

Jumper wires, breadboard, and power supply

Software

Arduino IDE: Upload the .ino sketch to your Arduino.

Processing IDE: Run the .pde sketch to visualize the radar.

⚠ Important:

Make sure to select the correct serial port in Processing to match your Arduino connection.

In Processing 4.4.8, you may encounter processing.serial does not exist error because the serial library is not included automatically. It is recommended to use Processing 4.4.7, where the serial library comes pre-installed.

Usage

Connect Arduino to your PC.

Upload the Arduino sketch.

Open and run the Processing sketch.

Observe the real-time radar display.
