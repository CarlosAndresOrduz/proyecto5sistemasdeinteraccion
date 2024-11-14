import oscP5.*;
import netP5.*;

// Configuración de OSC
OscP5 oscP5;
int puerto;

// Parámetros y configuración
float x, y;
ArrayList<Circulo> circulos = new ArrayList<Circulo>();
float[] alturas = {50, 125, 200, 275, 350};
float diametro = 50;
int maxCirculos = 500;
int numCirculosActual = 0; // Contador de círculos creados

// Colores y teclas
color[] coloresTeclas = {color(255, 0, 0), color(0, 255, 0), color(0, 0, 255), color(255, 255, 0), color(255, 165, 0)};
color colorCorrecto = color(173, 216, 230);
boolean[] teclasPresionadas = new boolean[5];

// Contadores y fondo
int contadorAciertos = 0;
int nivel = 0;
int contadorEstrellas = 0; // Nuevo contador de estrellas
color[] coloresFondo = {color(0), color(50, 50, 150), color(100, 50, 100), color(50, 150, 50), color(150, 100, 50), color(100, 50, 50)};

// Inicialización del programa
void setup() {
  size(400, 400);
  background(255);

  // Configurar puerto OSC
  puerto = 11111;
  oscP5 = new OscP5(this, puerto);

  // Cargar y procesar los datos del archivo CSV
  cargarDatosDeArchivo("mental_health_diagnosis_treatment_.csv");
}

void draw() {
  background(coloresFondo[nivel]);
  noStroke();

  // Dibujar las filas de rectángulos en el fondo
  for (int i = 0; i < alturas.length; i++) {
    color rectColor = color(184, 134, 11); // Dorado
    boolean hayCirculoEnArea = false;

    // Verificar si hay algún círculo en el área de la tecla
    for (Circulo c : circulos) {
      if (c.x - c.diametro / 2 <= 80 && c.x + c.diametro / 2 >= 0 && c.y >= alturas[i] - 25 && c.y <= alturas[i] + 25) {
        hayCirculoEnArea = true;
        break;
      }
    }

    if (teclasPresionadas[i]) {
      // Cambiar a color azul claro si la tecla se presiona cuando hay un círculo en el área correspondiente
      rectColor = hayCirculoEnArea ? colorCorrecto : color(255, 0, 0);
    }

    drawRectangle(0, alturas[i] - 25, 400, 50, color(255)); // Rectángulo blanco
    drawRectangle(0, alturas[i] - 25, 80, 50, rectColor); // Rectángulo dorado o cambiado
  }

  // Actualizar y mostrar todos los círculos
  for (int i = circulos.size() - 1; i >= 0; i--) {
    Circulo c = circulos.get(i);
    if (millis() >= c.tiempoGeneracion) {
      c.update();
      c.display();

      // Verificar si el círculo toca el área de un rectángulo y si la tecla correspondiente está presionada
      for (int j = 0; j < alturas.length; j++) {
        if (c.x - c.diametro / 2 <= 80 && c.x + c.diametro / 2 >= 0 && c.y >= alturas[j] - 25 && c.y <= alturas[j] + 25) {
          if (teclasPresionadas[j] && !c.mensajeImpreso) {
            println("¡Nota del círculo: " + c.Nota + "!");
            c.mensajeImpreso = true;
            
            // Enviar mensaje OSC a Pure Data para nota correcta
            OscMessage mensajeOSC = new OscMessage("/notaCorrecta");
            mensajeOSC.add(c.Nota); // Enviar la nota como un parámetro
            oscP5.send(mensajeOSC, new NetAddress("192.168.115.25", 11111)); // Puerto de PD (ajustar si es necesario)
            
            // Incrementar el contador de aciertos
            contadorAciertos++;
            
            // Verificar si el contador de aciertos es múltiplo de 10
            if (contadorAciertos % 10 == 0) {
              contadorEstrellas++; // Incrementar el contador de estrellas
              if (contadorEstrellas > 10) contadorEstrellas = 10; // Limitar a un máximo de 10 estrellas
              nivel++;
              if (nivel >= coloresFondo.length) nivel = coloresFondo.length - 1; // Limitar el nivel
              
              // Enviar mensaje OSC de avance de nivel
              OscMessage nextLevelMsg = new OscMessage("/nextLevel");
              nextLevelMsg.add(true);
              oscP5.send(nextLevelMsg, new NetAddress("192.168.115.25", 11111));
            }
          }
        }
      }
    }

    // Eliminar el círculo si sale de la pantalla
    if (c.x < -c.diametro) {
      circulos.remove(i);
    }
  }

  // Verificar teclas presionadas sin círculos en el área
  for (int i = 0; i < alturas.length; i++) {
    if (teclasPresionadas[i]) {
      boolean hayCirculoEnArea = false;

      for (Circulo c : circulos) {
        if (c.x - c.diametro / 2 <= 80 && c.x + c.diametro / 2 >= 0 && c.y >= alturas[i] - 25 && c.y <= alturas[i] + 25) {
          hayCirculoEnArea = true;
          break;
        }
      }

      if (!hayCirculoEnArea) {
        println("No hay círculos en el área de la tecla " + (i + 1) + ".");
        
        // Enviar mensaje OSC para nota incorrecta
        OscMessage mensajeOSC = new OscMessage("/notaIncorrecta");
        mensajeOSC.add(true); 
        oscP5.send(mensajeOSC, new NetAddress("192.168.115.25", 11111));

        // Reiniciar el contador de aciertos, nivel y estrellas al fallar
        contadorAciertos = 0;
        nivel = 0;
        contadorEstrellas = 0; // Reiniciar las estrellas
      }
    }
  }

  // Mostrar el contador de aciertos en la esquina de la pantalla
  fill(255);
  textSize(16);
  text("Aciertos: " + contadorAciertos, 10, 20);

  // Dibujar las estrellas en la esquina superior izquierda
  for (int i = 0; i < contadorEstrellas; i++) {
    fill(255, 215, 0); // Color dorado para las estrellas
    text("★", 10 + i * 15, 40); // Espacio entre estrellas
  }
}

// Procesar eventos de teclado
void keyPressed() {
  if (key == 'q' || key == 'Q') teclasPresionadas[0] = true;
  if (key == 'w' || key == 'W') teclasPresionadas[1] = true;
  if (key == 'e' || key == 'E') teclasPresionadas[2] = true;
  if (key == 'r' || key == 'R') teclasPresionadas[3] = true;
  if (key == 't' || key == 'T') teclasPresionadas[4] = true;
}

void keyReleased() {
  if (key == 'q' || key == 'Q') teclasPresionadas[0] = false;
  if (key == 'w' || key == 'W') teclasPresionadas[1] = false;
  if (key == 'e' || key == 'E') teclasPresionadas[2] = false;
  if (key == 'r' || key == 'R') teclasPresionadas[3] = false;
  if (key == 't' || key == 'T') teclasPresionadas[4] = false;
}

int asignarNota(String diagnosis, String estadoEmocional) {
  int[] escala;

  // Selección de la escala según el diagnóstico
  switch (diagnosis) {
    case "Major Depressive Disorder":
      escala = new int[] {62, 64, 66, 67, 69, 71, 73, 74}; // Escala de Re mayor (D)
      break;
    case "Panic Disorder":
      escala = new int[] {64, 66, 68, 69, 71, 73, 75, 76}; // Escala de Mi mayor (E)
      break;
    case "Generalized Anxiety":
      escala = new int[] {65, 67, 69, 70, 72, 74, 76, 77}; // Escala de Fa mayor (F)
      break;
    case "Bipolar Disorder":
      escala = new int[] {67, 69, 71, 72, 74, 76, 78, 79}; // Escala de Sol mayor (G)
      break;
    default:
      escala = new int[] {60}; // Nota por defecto en caso de error
      break;
  }

  // Asignación de la nota según el estado emocional
  switch (estadoEmocional) {
    case "Anxious":
      return escala[0];
    case "Neutral":
      return escala[1];
    case "Happy":
      return escala[2];
    case "Excited":
      return escala[3];
    case "Stressed":
      return escala[4];
    case "Depressed":
      return escala[5];
    default:
      return escala[0]; // Nota por defecto si el estado emocional no coincide
  }
}

// Modificar la función de carga de datos para incluir la asignación de nota
void cargarDatosDeArchivo(String rutaArchivo) {
  Table tabla = loadTable(rutaArchivo, "header");

  for (TableRow row : tabla.rows()) {
    if (numCirculosActual >= maxCirculos) break;

    int tiempoGeneracion = int(row.getInt("Patient ID") * 1000);
    color col = color(row.getInt("Symptom Severity (1-10)") * 20, row.getInt("Mood Score (1-10)") * 20, row.getInt("Sleep Quality (1-10)") * 20);
    float velocidad = map(row.getInt("Stress Level (1-10)"), 1, 10, 1, 3);
    int filaGeneracion = constrain(int(row.getInt("Physical Activity (hrs/week)") / 2) - 1, 0, alturas.length - 1);

    String diagnosis = row.getString("Diagnosis"); // Obtener diagnóstico
    String estadoEmocional = row.getString("AI-Detected Emotional State"); // Obtener estado emocional

    // Asignar la nota según el diagnóstico y el estado emocional
    int nota = asignarNota(diagnosis, estadoEmocional);
    
    circulos.add(new Circulo(width, alturas[filaGeneracion], diametro, col, velocidad, tiempoGeneracion, nota));
    numCirculosActual++;
  }
}

// Clase de círculo con atributos
class Circulo {
  float x, y, diametro, velocidad;
  color col;
  int tiempoGeneracion;
  float Nota;
  boolean mensajeImpreso = false;

  Circulo(float x, float y, float diametro, color col, float velocidad, int tiempoGeneracion, float Nota) {
    this.x = x;
    this.y = y;
    this.diametro = diametro;
    this.col = col;
    this.velocidad = velocidad;
    this.tiempoGeneracion = tiempoGeneracion;
    this.Nota = Nota;
  }

  void update() {
    x -= velocidad;
  }

  void display() {
    fill(col);
    ellipse(x, y, diametro, diametro);
  }
}

void drawRectangle(float x, float y, float w, float h, color c) {
  fill(c);
  rect(x, y, w, h);
}
