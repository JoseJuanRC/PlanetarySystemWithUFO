// Variables del sol
PShape sun; 
float ang = 0;

// Variables que nos indican propiedades para dibujar planetas
int numberOfPlanets = 5;
PShape[] planets = new PShape[numberOfPlanets]; 
float[] planetAngle = {100.0f, 20.0f, 200.0f, 140.0f, 340};
float[] planetDistance = {0.25f, 0.32f, 0.40f, 0.14f, 0.5f};
float[] planetSpeed = {0.25f, 0.1f, 0.2f, -0.3f, -0.15f};
float[] planetRotationAngle = {100.0f, 20.0f, 200.0f, 140.0f, 340};
float[] planetRotationSpeed = {0.5f, -1.5f, 1f, 0f, 0.15f};
float[] planetSize = {20f, 30f, 25f, 10f, 10f};

// Variables que nos indica el texto de cada planeta
int size = 22;
int[] Yposition = {40, 50, 50, 30, 40};
String[] planetNames = {"Neptune", "Jupiter", "Earth", "Green Planet", "Ice Planet"};

// Para dibujar lunas
int totalNumberOfMoons = 5;
PShape[] moons = new PShape[totalNumberOfMoons]; 
int[] numberOfMoons = {1, 1, 1, 2, 0};
int numberMoonsPainted = 0;

float[] moonDistance = {20f, 35f, 28f, -35f, 20f};
float[] moonVelocityY = {0.3f, 0.5f, 0.1f, 0.25f, -1f};
float[] moonAngleY = {0f, 60f, 20f, 120, 300.5f};
float[] moonVelocityX = {-0.4f, 0.25f, -0.4f, -0.25f, 0.3f};
float[] moonAngleX = {40f,120f, 0f, 320, 40.5f};
float[] moonSize = {7f, 12f, 5f, 10f, 3f};


void initSystem() {
  // Creamos los planetas y sus texturas
  PImage sunTexture = loadImage( "Textures/Sun.png");
  sun = createShape(SPHERE, 50); 
  sun.setTexture(sunTexture);
  
  for (int i= 0; i<numberOfPlanets; i++) {
    planets[i] = createShape(SPHERE, planetSize[i]); 
    PImage planetTexture = loadImage( "Textures/Planet"+i+".jpg");
    planets[i].setTexture(planetTexture);
  }
  
  for (int i= 0; i<totalNumberOfMoons; i++) {
    moons[i] = createShape(SPHERE, moonSize[i]); 
    PImage moonTexture = loadImage( "Textures/Moon"+i+".jpg");
    moons[i].setTexture(moonTexture);
  }
  
}

void drawSystem() {

  numberMoonsPainted = 0; // Reseteamos el numero de lunas dibujas
  
  // Centro
  translate(width/2, height/2, 0);
  
  drawSun();

  for (int i= 0; i<numberOfPlanets; i++)
    drawPlanet(i);
}
void drawSun() {
  pushMatrix();
  rotateY(radians(ang));
  shape(sun);
  popMatrix();
  
  //Resetea tras giro completo
  ang=ang+0.25;
  if (ang>360)
    ang=0;
}

void drawPlanet(int index) {
  pushMatrix();
  
  // Rotamos y trasladamos el planeta a la posición que se indica
  rotateY(radians(planetAngle[index]));
  translate(-width*planetDistance[index],0,0);
  
  // Escribimos el nombre del planeta si la camara no se mueve
  if (!camMovement) writeText(index);
  
  // Aplicamos rotación sobre el eje del planeta
  rotateY(radians(planetRotationAngle[index]));
  
  // Dibujamos el planeta
  shape(planets[index]);
  
  // Dibujamos las lunas que se encuentren en dicho planeta
  for (int i= 0; i<numberOfMoons[index]; i++)
    drawMoon();

  popMatrix();
  
  //Resetea rotación con respecto al sol tras giro completo
  planetAngle[index]=planetAngle[index]+planetSpeed[index];
  if (planetAngle[index]>360)
    planetAngle[index]=0;
  else if (planetAngle[index]<0)
    planetAngle[index]=360;
    

  //Resetea rotación con respecto a si mismo tras giro completo
  planetRotationAngle[index]=planetRotationAngle[index]+planetRotationSpeed[index];
  if (planetRotationAngle[index]>360)
    planetRotationAngle[index]=0;
  else if (planetRotationAngle[index]<0)
    planetRotationAngle[index]=360;

}

void writeText(int index) {
  pushMatrix();
  rotateY(radians(-planetAngle[index])); // Invertimos la rotación hecha para que el texto sea visible frontalmente al usuario
  textAlign(CENTER);
  textSize(size);
  text(planetNames[index], 0,Yposition[index]);
  popMatrix();
  
}

void drawMoon() {
  pushMatrix();
  
  // Aplicamos dos rotaciones a la posición de la luna y posteriormente la trasladamos
  rotateY(radians(moonAngleY[numberMoonsPainted]));
  rotateX(radians(moonAngleX[numberMoonsPainted]));
  translate(moonDistance[numberMoonsPainted],moonDistance[numberMoonsPainted],0);
  shape(moons[numberMoonsPainted]);
  popMatrix();

  //Resetea rotación con respecto al planeta
  
  moonAngleX[numberMoonsPainted]+= moonVelocityX[numberMoonsPainted];
  if (moonAngleX[numberMoonsPainted]>360)
    moonAngleX[numberMoonsPainted]=0;
  else if (moonAngleX[numberMoonsPainted]<0)
    moonAngleX[numberMoonsPainted]=360;
    
  moonAngleY[numberMoonsPainted]+= moonVelocityY[numberMoonsPainted];
  if (moonAngleY[numberMoonsPainted]>360)
    moonAngleY[numberMoonsPainted]=0;
  else if (moonAngleY[numberMoonsPainted]<0)
    moonAngleY[numberMoonsPainted]=360;
    
  
    
  numberMoonsPainted++; // Incrementamos en uno el número de lunas dibujadas en esta iteración
}
