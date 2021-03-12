PImage backgroundImage;

boolean isInIntro;
PFont f;

// Variables movimiento camara
float incX = 0, incY = 0, incZ = 0;
int posX, posY, posZ;
float[] camLookingPoint = {100,0,0};
float camSpeed = 2f;

float velocityX = 3f, velocityY = 3f, velocityZ = 3f;
float velocityReduction = 0.8;
float reductionMinValue = 0.4;

float Xangle = 0, totalAngle = 0; 

float camRotX;
float camRotY;

boolean camMovement = false;

PShape ufo;

void setup()
{
  size(800,800,P3D);
  noStroke();
  
  // Monstramos la pestaña de introducción
  drawIntro();
  // Iniciamos la configuración y posición de la cámara y del planeta
  camSetUp();
  initSystem();
  
  // Cargamos el ovni que utilizamos
  ufo = loadShape("ovni/source/ufo4.obj");
  ufo.rotateX(-radians(180));
  PImage UFOTexture = loadImage( "ovni/textures/finalTexture.png");
  ufo.setTexture(UFOTexture);
  
  // Cargamos la imagen de fondo
  backgroundImage = loadImage("background.jpg");
}

void drawIntro() {
  isInIntro = true;
  background(0);
  textAlign(CENTER);
  f = createFont("Arial",62,true); 
  textFont(f);
  text("Sistema Planetario",width/2,height/8); 
  
  textAlign(CENTER);
  f = createFont("Arial",28,true); 
  textFont(f);
  text("Controles",width/2,height/3.8); 
  textAlign(LEFT);
  f = createFont("Arial",24, true); 
  textFont(f);
  text("Teclas:",width/20,height/3);
  f = createFont("Arial",20, true); 
  textFont(f);
  text("Enter:      Cambia el modo de vista (posición de la cámara)",width/20,height/2.4);
  text("A/D:        Mueve la nave a la izquierda o derecha",width/20,height/2.18);  
  text("W/S:        Mueve la nave para arriba o abajo",width/20,height/2);  
  text("↑ / ↓:        Mueve la nave hacia delante o atrás",width/20,height/1.85);  
  text("←/→:       Rota la nave hacia la derecha o izquierda",width/20,height/1.7);  

  
  textAlign(CENTER);
  f = createFont("Arial",16,true); 
  textFont(f);
  text("Pulsa enter para jugar\n",width/2,height/1.25); 
}


void draw()
{
  if (!isInIntro) {
    background(backgroundImage);
  
    // Comprobamos el movimiento de la cámara si esta activada la opción
    if (camMovement) cam();
    
    // Dibujamos el ovni y todos los objetos del sistema
    drawUFO(); 
    drawSystem();
  }
}

// Configuración inicial de la cámara
void camSetUp() {
  posX = 238;
  posY = 355;
  posZ = 83;
}

// Comprobamos y realizamos la rotación y movimiento de la cámara.
void cam() {
  if (camRotX!=0) rotateCam();
  moveCam();
  
  camera(posX , posY, posZ, posX+camLookingPoint[0], posY+camLookingPoint[1], posZ-1+camLookingPoint[2], 0 , 1, 0);  
}

// Dibujamos el ovni
void drawUFO() {
  pushMatrix();
  translate(posX+camLookingPoint[0],posY+camLookingPoint[1],posZ-1+camLookingPoint[2]);
  rotateY(-radians(totalAngle)); // Rotamos el ovni para que el usuario no aprecie su rotación
  shape(ufo, 0, 0);
  popMatrix();
}

// Movimiento de la cámara
void moveCam() {
  
  // Si ya no se pulsan las teclas de movimiento se producirá una desaceleración
  checkAcceleration();
  
  // Se mueve al usuario de forma correspondiente a donde este rotada la cámara
  if (incZ != 0) {
    posX+= incZ*(camLookingPoint[0])/100;
    posZ+= incZ*(camLookingPoint[2])/100;
  }
  
  if (incX != 0) {
    posX+= incX*(-camLookingPoint[2])/100;;
    posZ+= incX*(camLookingPoint[0])/100;
  }
  
  posY+=incY;
}

// Método para desacelerar si fuera necesario
void checkAcceleration() {
  if (incX != 0 && abs(incX) < velocityX) incX=incX*velocityReduction;
  if (abs(incX) < reductionMinValue) incX = 0;
  
  if (incY != 0 && abs(incY) < velocityY) incY=incY*velocityReduction;
  if (abs(incY) < reductionMinValue) incY = 0;
  
  if (incZ != 0 && abs(incZ) < velocityZ) incZ=incZ*velocityReduction;
  if (abs(incZ) < reductionMinValue) incZ = 0;
  
}

// Rotamos la cámara si se pulsan las flechas
void rotateCam() {
  Xangle=camRotX;
  totalAngle=(totalAngle+Xangle)%360;
  if (totalAngle <0) totalAngle = 360+totalAngle;
  
  // Rotamos con respecto a Y
  float[] xAxis = {cos(radians(Xangle)) ,0, sin(radians(Xangle))};  // 1 unit long
  float[] yAxis = {0, 1,0};  // 1 unit long
  float[] zAxis = {-sin(radians(Xangle)), 0, cos(radians(Xangle))};  // 1 unit long
  
  float pointX = camLookingPoint[0];
  float pointY = camLookingPoint[1];
  float pointZ = camLookingPoint[2];
  
  camLookingPoint[0] = pointX * xAxis[0] + pointY * yAxis[0] + pointZ * zAxis[0] + 0;
  camLookingPoint[1] = pointX * xAxis[1] + pointY * yAxis[1] + pointZ * zAxis[1] + 0;
  camLookingPoint[2] = pointX * xAxis[2] + pointY * yAxis[2] + pointZ * zAxis[2] + 0;
}

// Método para cambiar el estado del sistema y fijar la posición de la cámara cuando esta no se mueve
void changeCamaraState() {
  if (isInIntro) {
    isInIntro = false;
    background(0);
    textAlign(CENTER);
    f = createFont("Arial",24,true); 
    textFont(f);
    text("Cargando...",width/2,height/2); 
  } else {
    if (camMovement) {
      camera(width/2.0, height/2.0, (height/2.0) / tan(PI*30.0 / 180.0), width/2.0, height/2.0, 0, 0, 1, 0);
      
      // Quitamos el incremento de velocidad de la nave
      incX = 0;
      incY = 0;
      incZ = 0;
    }
    camMovement=!camMovement;
  }
}

void keyPressed() {
  if (key == 'w' || key == 'W') incY = -velocityY;
  if (key == 's' || key == 'S') incY = velocityY;
  
  if (key == 'a' || key == 'A') incX = -velocityX;
  if (key == 'd' || key == 'D') incX = velocityX;

  if (keyCode == UP) incZ = velocityZ;
  if (keyCode == DOWN) incZ = -velocityZ;
  if (keyCode == LEFT) camRotX = -camSpeed;
  if (keyCode == RIGHT) camRotX = camSpeed;
  if (keyCode == ENTER) changeCamaraState();
}


void keyReleased() {
  if (key == 'w' || key == 'W' || key == 's' || key == 'S') incY = velocityReduction*incY;
  if (key == 'a' || key == 'A' || key == 'd' || key == 'D') incX = velocityReduction*incX;
  if (keyCode == UP || keyCode == DOWN) incZ = velocityReduction*incZ;
  
  // Dejamos de rotar la camara en el caso de que la tecla que se deje de pulsar corresponda
  // a la velocidad actual de la camara (si no hay coincidencia significa que se pulso la tecla
  // contraria)
  if (keyCode == LEFT && camRotX == -camSpeed)  camRotX = 0;
  if (keyCode == RIGHT && camRotX == camSpeed) camRotX = 0;
}
