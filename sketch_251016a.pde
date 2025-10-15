import processing.serial.*;

Serial myPort; 
int radar_aci = 0; 
int radar_mesafe = 0; 
String veriDizesi = "";
int aciDegisikligi = 0; 
int maksimumMesafe = 200; 


class ObjeNoktasi {
  float x, y; 
  int aci;
  int zaman;
  
  ObjeNoktasi(float x, float y, int aci) {
    this.x = x;
    this.y = y;
    this.aci = aci;
    this.zaman = millis(); 
  }
}


ArrayList<ObjeNoktasi> objeler = new ArrayList<ObjeNoktasi>();

void setup() {
  size(800, 700, P2D); 
  background(0);
  

  String portName = "COM5"; 
  
  
  println("Kullanılabilir Portlar:");
  println(Serial.list());
  
  try {
    myPort = new Serial(this, portName, 9600);
    myPort.bufferUntil('\n'); // Yeni satır ('\n') gelene kadar tamponla
    println("\nSeri port " + portName + " (9600 baud) başarıyla açıldı.");
  } catch (Exception e) {
    println("\n----------------------------------------------------");
    println("HATA: " + portName + " portu bulunamadı veya açılamadı.");
    println("Lütfen yukarıdaki listeden doğru port adını 'portName' değişkenine girin.");
    println("----------------------------------------------------");
  }
}

void draw() {
  
  pushMatrix();
  translate(width / 2, height);
  
  
  fill(0, 15);
  noStroke();
  rect(-width/2, -height, width, height);
  
  
  drawRadarIzgarasi(maksimumMesafe);
  
  drawObjeler();
  
  drawTaramaCizgisi();
  
  drawBilgiMetni();
  
  popMatrix();
}

void serialEvent(Serial myPort) {
  try {
    veriDizesi = myPort.readStringUntil('\n');
    
    if (veriDizesi != null) {
      veriDizesi = trim(veriDizesi);
      
      String[] parcalar = split(veriDizesi, ',');
      
      if (parcalar.length == 2) {
  
        int yeniAci = (int)float(parcalar[0]); 
        int yeniMesafe = (int)float(parcalar[1]); 

        if (yeniAci >= 0 && yeniAci <= 180 && yeniMesafe >= 0 && yeniMesafe <= maksimumMesafe) {
          radar_aci = yeniAci;
          radar_mesafe = yeniMesafe;
          
         aciDegisikligi += (yeniAci - aciDegisikligi) * 0.1;
          
          if (yeniMesafe > 0) {
            float r = map(yeniMesafe, 0, maksimumMesafe, 0, width/2 * 0.9); 
            float aciRadyan = radians(180 - yeniAci); 
            float x = r * cos(aciRadyan);
            float y = r * sin(aciRadyan) * -1; 
            
            objeler.add(new ObjeNoktasi(x, y, yeniAci));
          }
        }
      }
    }
  } catch (Exception e) {
    }
}


void drawRadarIzgarasi(int maksMesafe) {
  int cemberSayisi = 4;
  float radarYariCap = width / 2 * 0.9;
  float cemberAraligi = radarYariCap / cemberSayisi;
  
  noFill();
  strokeWeight(1);
  stroke(30, 255, 30, 100); 


  for (int i = 0; i <= 180; i += 30) {
    float radyan = radians(180 - i);
    line(0, 0, radarYariCap * cos(radyan), radarYariCap * sin(radyan) * -1);
  }


  textSize(12);
  fill(30, 255, 30, 200);
  

  for (int i = 1; i <= cemberSayisi; i++) {
    float r = i * cemberAraligi;
    arc(0, 0, r * 2, r * 2, PI, TWO_PI);
    

    float mesafeCm = (float)maksMesafe / cemberSayisi * i;
    textAlign(CENTER);
    text(nfc(mesafeCm, 0) + " cm", 0, -r + 15);
  }
  

  for (int i = 0; i <= 180; i += 30) {
    float radyan = radians(180 - i);
    float etiketX = radarYariCap * cos(radyan) * 1.05;
    float etiketY = radarYariCap * sin(radyan) * -1.05;
    
    textAlign(CENTER, CENTER);
    text(i + "°", etiketX, etiketY);
  }
}

void drawTaramaCizgisi() {

  float cizimAci = aciDegisikligi;
  
  stroke(50, 255, 50); 
  strokeWeight(3);
  
  float aciRadyan = radians(180 - cizimAci);
  float cizgiX = width / 2 * 0.9 * cos(aciRadyan);
  float cizgiY = width / 2 * 0.9 * sin(aciRadyan) * -1;
  
  line(0, 0, cizgiX, cizgiY);
  
  fill(50, 255, 50);
  noStroke();
  ellipse(cizgiX, cizgiY, 8, 8);
}

void drawObjeler() {
  for (int i = objeler.size() - 1; i >= 0; i--) {
    ObjeNoktasi obje = objeler.get(i);
    
    int maxYas = 1000; 
    int yas = millis() - obje.zaman;
    
 
    int alpha = (int)map(yas, 0, maxYas, 255, 0); 
    
    if (alpha > 0) {
      fill(255, 100, 100, alpha); 
      noStroke();
      
      ellipse(obje.x, obje.y, 8, 8);
    } else {
      objeler.remove(i);
    }
  }
}

void drawBilgiMetni() {
  fill(255); 
  textSize(16);
  
 
  textAlign(LEFT);
  text("Açı: " + (int)aciDegisikligi + "°", -width/2 + 20, -height + 20); // aciDegisikligi float olabilir, int'e çevir.
  text("Mesafe: " + radar_mesafe + " cm", -width/2 + 20, -height + 40); 
  
 
  textAlign(RIGHT);
  text("Maks. Menzil: " + maksimumMesafe + " cm", width/2 - 20, -height + 20); 
}
