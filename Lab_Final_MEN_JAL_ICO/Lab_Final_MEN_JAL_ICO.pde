// LIBRERÍAS
import controlP5.*;
import gifAnimation.*;
import ddf.minim.*;

ControlP5 cp5;
Minim minim;
AudioOutput out;
AudioPlayer musicaFondo;

// VARIABLES GLOBALES
PImage logoImagen;
PFont fuente;
PFont fuentePequena;

int pantalla = 0;  // 0=MenuPrincipal, 1=MenuMiscelaniaVirus, 2=Virus, 3=PuntoFama, 4=MenuExtras, 5=HexConversor, 6=MenuOperaciones, 7=MultiplicacionRusa, 8=ClaveNumero, 9=FuncionesTrig, 10=MenuProcesosMat, 11=LaMargarita
boolean musicaActiva = true;
boolean coloresAzules = false;  // true cuando está en pantalla 10

// Fondo animado
float animacionFondo = 0;

// MENÚ OPERACIONES MATEMÁTICAS
// Pantalla 6 = Menú Operaciones
// Pantalla 7 = Multiplicación Rusa
// Pantalla 8 = Clave de un Número
// Pantalla 9 = Funciones Trigonométricas (Taylor)

// MULTIPLICACIÓN RUSA (Pantalla 7)
boolean rusaEscribiendoM = false;
boolean rusaEscribiendoN = false;
boolean rusaTieneM = false;
boolean rusaTieneN = false;
long rusaM = 0;
long rusaN = 0;
String rusaProceso = "";

// CLAVE DE UN NÚMERO (Pantalla 8)
boolean claveEscribiendo = false;
boolean claveSignoNeg = false;
boolean claveTieneValor = false;
long claveValorAbs = 0;
String claveProceso = "";

// FUNCIONES TRIGONOMÉTRICAS - TAYLOR (Pantalla 9)
int taylorFuncion = 1; // 1=sin,2=cos,3=tan,4=sec,5=csc,6=cot
boolean tAngEscribiendo = false;
boolean tNEscribiendo = false;
boolean tAngSignoNeg = false;
boolean tAngTieneValor = false;
int tAnguloAbs = 0;
boolean tNTieneValor = false;
int tN = 0;
String tResultado = "";
double tPi = 3.141592653589793;
double tEPS = 0.00000001;
// GIFs animados para funciones trigonométricas
Gif gifSIN;
Gif gifCOS;
Gif gifTAN;
Gif gifSEC;
Gif gifCSC;
Gif gifCOT;

// JUEGO VIRUS
boolean juegoVirus = false;
int turnoJugador = 1;
int ganador = 0;
int virus1 = 10;
int virus2 = 10;
int servidor1 = 0, servidor2 = 0, servidor3 = 0;
int servidor4 = 0, servidor5 = 0, servidor6 = 0;
// Conteo por jugador en cada servidor (1..5 capacidad limitada, 6 infinito)
int servidor1J1 = 0, servidor2J1 = 0, servidor3J1 = 0, servidor4J1 = 0, servidor5J1 = 0, servidor6J1 = 0;
int servidor1J2 = 0, servidor2J2 = 0, servidor3J2 = 0, servidor4J2 = 0, servidor5J2 = 0, servidor6J2 = 0;
int dado = 0;
int contadorDado = 0;
boolean dadoGirando = false;

// PUNTO Y FAMA
int codigo1 = 0, codigo2 = 0, codigo3 = 0, codigo4 = 0;
int intento1 = -1, intento2 = -1, intento3 = -1, intento4 = -1;
int intentos = 0;
boolean ganoFama = false;
int famas = 0;
int puntos = 0;

// CONVERSOR HEX
int hexDigito1 = -1, hexDigito2 = -1, hexDigito3 = -1, hexDigito4 = -1;
int hexDecimal = 0;
int hexContador = 0;

// LA MARGARITA (Pantalla 11)
int p1 = 1;
int p2 = 1;
int p3 = 1;
int p4 = 1;
int p5 = 1;
int p6 = 1;
int p7 = 1;
int p8 = 1;
int p9 = 1;

int turno = 1;          // 1 ó 2
int fichasRestantes = 9;

int sel1 = 0;           // primera ficha seleccionada en el turno
int sel2 = 0;           // segunda ficha (si la hay)

boolean juegoTerminado = false;
int ganadorMargarita = 0;
boolean mensajeError = false;

// centro de la margarita (un poco más abajo)
float cx = 400;
float cy = 460;
float radio = 260;
float radioPetalo = 120;

//=====================================================================
// SETUP - SE EJECUTA UNA VEZ AL INICIO
//=====================================================================
void setup() {
  pixelDensity(1);
  fullScreen();

  // Cargar logo
  logoImagen = loadImage("logo.png");

  // Cargar GIFs animados y ponerlos en loop
  gifSIN = new Gif(this, "gif/seno.gif");
  gifSIN.loop();
  gifCOS = new Gif(this, "gif/coseno.gif");
  gifCOS.loop();
  gifTAN = new Gif(this, "gif/tangente.gif");
  gifTAN.loop();
  gifSEC = new Gif(this, "gif/secante.gif");
  gifSEC.loop();
  gifCSC = new Gif(this, "gif/cosecante.gif");
  gifCSC.loop();
  gifCOT = new Gif(this, "gif/cotangente.gif");
  gifCOT.loop();

  // Fuentes
  fuente = createFont("Courier New", 28);
  fuentePequena = createFont("Courier New", 16);
  textFont(fuente);
  textAlign(CENTER, CENTER);
  rectMode(CENTER);

  // Inicializar ControlP5
  cp5 = new ControlP5(this);

  // Botón salir
  cp5.addButton("btnSalir")
    .setPosition(width - 160, 20)
    .setSize(150, 40)
    .setLabel("[ SALIR ]")
    .setColorBackground(color(100, 0, 0))
    .setColorForeground(color(255, 0, 0))
    .setFont(fuentePequena);

  // Botón música
  cp5.addButton("btnMusica")
    .setPosition(width - 160, 80)
    .setSize(150, 40)
    .setLabel("[ MUSICA: ON ]")
    .setColorBackground(color(0))
    .setColorForeground(color(0, 180, 60))
    .setFont(fuentePequena);

  // Botón volver
  cp5.addButton("btnVolver")
    .setPosition(10, 20)
    .setSize(140, 40)
    .setLabel("[ VOLVER ]")
    .setColorBackground(color(0))
    .setColorForeground(color(0, 180, 60))
    .setFont(fuentePequena)
    .hide();

  // Botones menú principal
  cp5.addButton("btnMiscelaniaVirus")
    .setPosition(width/2-200, height/2-120)
    .setSize(400, 70)
    .setLabel("[ MISCELANIA JUEGOS ]")
    .setColorBackground(color(0))
    .setColorForeground(color(0, 180, 60))
    .setFont(fuente);

  cp5.addButton("btnProcesosMat")
    .setPosition(width/2-200, height/2-20)
    .setSize(400, 70)
    .setLabel("[ PROCESOS MATEMATICOS ]")
    .setColorBackground(color(0))
    .setColorForeground(color(0, 180, 60))
    .setFont(fuente);

  cp5.addButton("btnExtras")
    .setPosition(width/2-200, height/2+80)
    .setSize(400, 70)
    .setLabel("[ EXTRAS ]")
    .setColorBackground(color(0))
    .setColorForeground(color(0, 180, 60))
    .setFont(fuente);

  // Botones dentro de Miscelania Virus
  cp5.addButton("btnVirus")
    .setPosition(width/2-200, height/2-60)
    .setSize(400, 70)
    .setLabel("[ CONTENIENDO VIRUS ]")
    .setColorBackground(color(0))
    .setColorForeground(color(0, 180, 60))
    .setFont(fuente)
    .hide();

  cp5.addButton("btnFama")
    .setPosition(width/2-200, height/2+40)
    .setSize(400, 70)
    .setLabel("[ PUNTO Y FAMA ]")
    .setColorBackground(color(0))
    .setColorForeground(color(0, 180, 60))
    .setFont(fuente)
    .hide();

  cp5.addButton("btnMargarita")
    .setPosition(width/2-200, height/2+140)
    .setSize(400, 70)
    .setLabel("[ LA MARGARITA ]")
    .setColorBackground(color(0))
    .setColorForeground(color(0, 180, 60))
    .setFont(fuente)
    .hide();

  // Botón Hex Conversor (dentro de Extras)
  cp5.addButton("btnHexConversor")
    .setPosition(width/2-200, height/2-60)
    .setSize(400, 70)
    .setLabel("[ HEX CONVERSOR ]")
    .setColorBackground(color(0))
    .setColorForeground(color(0, 180, 60))
    .setFont(fuente)
    .hide();

  // Botón Operaciones Matemáticas (dentro de Extras)
  cp5.addButton("btnOperaciones")
    .setPosition(width/2-200, height/2+40)
    .setSize(400, 70)
    .setLabel("[ OPERACIONES MATEMÁTICAS ]")
    .setColorBackground(color(0))
    .setColorForeground(color(0, 180, 60))
    .setFont(fuente)
    .hide();

  // Botón iniciar virus
  cp5.addButton("btnIniciar")
    .setPosition(width/2-300, height-160) // Posición inicial, luego se vuelve dinámica en draw
    .setSize(600, 120)
    .setLabel("[ INICIAR PARTIDA ]")
    .setColorBackground(color(10, 40, 20))
    .setColorForeground(color(0, 220, 100))
    .setFont(fuente)
    .hide();

  // Botón parar dado
  cp5.addButton("btnParar")
    .setPosition(width/2-300, 220) // Posición inicial, luego dinámica
    .setSize(600, 100)
    .setLabel("[ FIJAR DADO ]")
    .setColorBackground(color(40, 20, 0))
    .setColorForeground(color(255, 160, 60))
    .setFont(fuente)
    .hide();

  // Inicializar audio
  minim = new Minim(this);
  out = minim.getLineOut();
  musicaFondo = minim.loadFile("musica.mp3");
  musicaFondo.loop();

  // Generar código secreto (con dígitos repetibles)
  codigo1 = int(random(10));
  codigo2 = int(random(10));
  codigo3 = int(random(10));
  codigo4 = int(random(10));
}

//=====================================================================
// DRAW - SE EJECUTA CONTINUAMENTE (60 FPS)
//=====================================================================
void draw() {
  // ===== DIBUJAR FONDO CON CICLOS =====
  background(0);
  animacionFondo = animacionFondo + 0.5;
  if (animacionFondo > 400) {
    animacionFondo = 0;
  }

  // Colores del fondo según modo
  int colorLineas;
  int colorPuntos;

  if (coloresAzules) {
    colorLineas = color(0, 100, 255, 30);
    colorPuntos = color(0, 100, 255, 80);
  } else {
    colorLineas = color(0, 255, 70, 30);
    colorPuntos = color(0, 255, 70, 80);
  }

  // Líneas verticales
  stroke(colorLineas);
  strokeWeight(1);
  int x = 0;
  while (x < width) {
    line(x, 0, x, height);
    x = x + 50;
  }

  // Líneas horizontales
  int y = 0;
  while (y < height) {
    line(0, y, width, y);
    y = y + 50;
  }

  // Puntos animados con ciclos anidados
  fill(colorPuntos);
  noStroke();
  int px = 0;
  while (px < width) {
    int py = 0;
    while (py < height) {
      float offset = sin((animacionFondo + px + py) * 0.02) * 3;
      ellipse(px + offset, py + offset, 3, 3);
      py = py + 50;
    }
    px = px + 50;
  }

  // ===== ACTUALIZAR VISIBILIDAD DE BOTONES CON SWITCH =====
  switch (pantalla) {
  case 0:  // Menú principal
    cp5.getController("btnVolver").hide();
    cp5.getController("btnMiscelaniaVirus").show();
    cp5.getController("btnVirus").hide();
    cp5.getController("btnFama").hide();
    cp5.getController("btnMargarita").hide();
    cp5.getController("btnExtras").show();
    cp5.getController("btnProcesosMat").show();
    cp5.getController("btnHexConversor").hide();
    cp5.getController("btnOperaciones").hide();
    cp5.getController("btnIniciar").hide();
    cp5.getController("btnParar").hide();
    break;

  case 1:  // Menu Miscelania Virus
    cp5.getController("btnVolver").show();
    cp5.getController("btnMiscelaniaVirus").hide();
    cp5.getController("btnVirus").show();
    cp5.getController("btnFama").show();
    cp5.getController("btnMargarita").show();
    cp5.getController("btnExtras").hide();
    cp5.getController("btnProcesosMat").hide();
    cp5.getController("btnHexConversor").hide();
    cp5.getController("btnOperaciones").hide();
    cp5.getController("btnIniciar").hide();
    cp5.getController("btnParar").hide();
    break;

  case 2:  // Juego Virus
    cp5.getController("btnVolver").show();
    cp5.getController("btnMiscelaniaVirus").hide();
    cp5.getController("btnVirus").hide();
    cp5.getController("btnFama").hide();
    cp5.getController("btnMargarita").hide();
    cp5.getController("btnExtras").hide();
    cp5.getController("btnProcesosMat").hide();
    cp5.getController("btnHexConversor").hide();
    cp5.getController("btnOperaciones").hide();
    if (juegoVirus && dadoGirando) {
      cp5.getController("btnIniciar").hide();
      cp5.getController("btnParar").show();
    } else if (juegoVirus && !dadoGirando) {
      cp5.getController("btnIniciar").show();
      cp5.getController("btnParar").hide();
    } else {
      cp5.getController("btnIniciar").show();
      cp5.getController("btnParar").hide();
    }
    break;

  case 3:  // Punto y Fama
    cp5.getController("btnVolver").show();
    cp5.getController("btnMiscelaniaVirus").hide();
    cp5.getController("btnVirus").hide();
    cp5.getController("btnFama").hide();
    cp5.getController("btnMargarita").hide();
    cp5.getController("btnExtras").hide();
    cp5.getController("btnProcesosMat").hide();
    cp5.getController("btnHexConversor").hide();
    cp5.getController("btnOperaciones").hide();
    cp5.getController("btnIniciar").hide();
    cp5.getController("btnParar").hide();
    break;

  case 4:  // Menu Extras
    cp5.getController("btnVolver").show();
    cp5.getController("btnMiscelaniaVirus").hide();
    cp5.getController("btnVirus").hide();
    cp5.getController("btnFama").hide();
    cp5.getController("btnMargarita").hide();
    cp5.getController("btnExtras").hide();
    cp5.getController("btnProcesosMat").hide();
    cp5.getController("btnHexConversor").show();
    cp5.getController("btnOperaciones").hide();
    cp5.getController("btnIniciar").hide();
    cp5.getController("btnParar").hide();
    break;

  case 5:  // Hex Conversor
    cp5.getController("btnVolver").show();
    cp5.getController("btnMiscelaniaVirus").hide();
    cp5.getController("btnVirus").hide();
    cp5.getController("btnFama").hide();
    cp5.getController("btnMargarita").hide();
    cp5.getController("btnExtras").hide();
    cp5.getController("btnProcesosMat").hide();
    cp5.getController("btnHexConversor").hide();
    cp5.getController("btnOperaciones").hide();
    cp5.getController("btnIniciar").hide();
    cp5.getController("btnParar").hide();
    break;

  case 6:  // Menu Operaciones
  case 7:  // Multiplicacion Rusa
  case 8:  // Clave Numero
  case 9:  // Funciones Trig
  case 10:  // Menu Procesos Matematicos
  case 11:  // La Margarita
    cp5.getController("btnVolver").show();
    cp5.getController("btnMiscelaniaVirus").hide();
    cp5.getController("btnVirus").hide();
    cp5.getController("btnFama").hide();
    cp5.getController("btnMargarita").hide();
    cp5.getController("btnExtras").hide();
    cp5.getController("btnProcesosMat").hide();
    cp5.getController("btnHexConversor").hide();
    cp5.getController("btnOperaciones").hide();
    cp5.getController("btnIniciar").hide();
    cp5.getController("btnParar").hide();
    break;
  }

  // ===== DIBUJAR PANTALLA SEGÚN ESTADO CON SWITCH =====
  switch (pantalla) {
  case 0:  // MENÚ PRINCIPAL
    // Caja principal
    stroke(0, 255, 70);
    strokeWeight(3);
    noFill();
    rectMode(CENTER);
    rect(width/2, height/2, width*0.6, height*0.7);

    // Logo
    noStroke();
    imageMode(CENTER);
    image(logoImagen, width/2, height/2-200, 600, 225);

    fill(0, 255, 70);
    textSize(20);
    textAlign(LEFT, BASELINE);
    text("> SISTEMA INICIADO", width/2-300, height/2-280);
    rectMode(CORNER);
    textAlign(CENTER, CENTER);
    break;

  case 1:  // MENU MISCELANIA VIRUS
    // Caja principal
    stroke(0, 255, 70);
    strokeWeight(3);
    noFill();
    rectMode(CENTER);
    rect(width/2, height/2, width*0.6, height*0.7);

    // Título
    fill(0, 255, 70);
    textSize(48);
    textAlign(CENTER, CENTER);
    text("[ MISCELANIA JUEGOS ]", width/2, height/2-200);

    textSize(20);
    textAlign(LEFT, BASELINE);
    text("> SELECCIONA UN JUEGO", width/2-300, height/2-280);
    rectMode(CORNER);
    textAlign(CENTER, CENTER);
    break;

  case 4:  // MENU EXTRAS
    // Caja principal
    stroke(0, 255, 70);
    strokeWeight(3);
    noFill();
    rectMode(CENTER);
    rect(width/2, height/2, width*0.6, height*0.7);

    // Título
    fill(0, 255, 70);
    textSize(48);
    textAlign(CENTER, CENTER);
    text("[ EXTRAS ]", width/2, height/2-200);

    textSize(20);
    textAlign(LEFT, BASELINE);
    text("> SELECCIONA UNA OPCION", width/2-300, height/2-280);
    rectMode(CORNER);
    textAlign(CENTER, CENTER);
    break;

  case 2:  // JUEGO VIRUS
    // Recuadro contenedor del juego
    stroke(0, 255, 70);
    strokeWeight(4);
    noFill();
    rectMode(CORNER);
    int boxX = int(width*0.05);
    int boxY = int(height*0.05);
    int boxW = int(width*0.90);
    int boxH = int(height*0.88);
    rect(boxX, boxY, boxW, boxH, 15);

    // Título
    fill(0, 255, 70);
    textSize(38);
    text("[ CONTENIENDO VIRUS ]", width/2, boxY + 30);

    // Info turno
    if (turnoJugador == 1) {
      fill(100, 255, 150);
    } else {
      fill(255, 150, 100);
    }
    textSize(24);
    text("> TURNO: JUGADOR " + turnoJugador, width/2, boxY + 65);

    // Botones pequeños dentro del recuadro (alternan Iniciar/Parar)
    int btnW = 180;
    int btnH = 50;
    int btnX = boxX + 20;
    int btnY = boxY + 90;

    if (!juegoVirus) {
      cp5.getController("btnIniciar").setPosition(btnX, btnY);
      cp5.getController("btnIniciar").setSize(btnW, btnH);
      cp5.getController("btnIniciar").setLabel("[ INICIAR JUEGO ]");
      cp5.getController("btnParar").setPosition(btnX, btnY);
      cp5.getController("btnParar").setSize(btnW, btnH);
    } else if (dadoGirando) {
      cp5.getController("btnParar").setPosition(btnX, btnY);
      cp5.getController("btnParar").setSize(btnW, btnH);
      cp5.getController("btnParar").setLabel("[ PARAR DADO ]");
      cp5.getController("btnIniciar").setPosition(btnX, btnY);
      cp5.getController("btnIniciar").setSize(btnW, btnH);
    } else {
      cp5.getController("btnIniciar").setPosition(btnX, btnY);
      cp5.getController("btnIniciar").setSize(btnW, btnH);
      cp5.getController("btnIniciar").setLabel("[ INICIAR TURNO ]");
      cp5.getController("btnParar").setPosition(btnX, btnY);
      cp5.getController("btnParar").setSize(btnW, btnH);
    }

    // Animar dado
    if (juegoVirus && dadoGirando) {
      contadorDado = contadorDado + 1;
      if (contadorDado > 6) {
        dado = int(random(1, 7));
        contadorDado = 0;
      }
    }

    // Dibujar dado (más pequeño y dentro del recuadro)
    pushMatrix();
    int dadoSize = int(min(boxW, boxH) * 0.14);
    translate(boxX + int(boxW*0.25), boxY + int(boxH*0.35));
    rectMode(CENTER);
    stroke(0, 255, 70);
    strokeWeight(4);
    noFill();
    rect(0, 0, dadoSize, dadoSize, 16);
    noStroke();
    fill(0);
    rect(0, 0, dadoSize-8, dadoSize-8, 16);
    // Dibujar pips (círculos) del dado en vez del número
    fill(0, 255, 70);
    float r = dadoSize * 0.08;          // radio de cada pip
    float o = dadoSize * 0.25;          // offset desde el centro a esquinas
    noStroke();
    // Dibujar pips según cara del dado
    if (dado == 1) {
      ellipse(0, 0, r*2, r*2);
    } else {
      if (dado == 2) {
        ellipse(-o, -o, r*2, r*2);
        ellipse(o, o, r*2, r*2);
      } else {
        if (dado == 3) {
          ellipse(-o, -o, r*2, r*2);
          ellipse(0, 0, r*2, r*2);
          ellipse(o, o, r*2, r*2);
        } else {
          if (dado == 4) {
            ellipse(-o, -o, r*2, r*2);
            ellipse(o, -o, r*2, r*2);
            ellipse(-o, o, r*2, r*2);
            ellipse(o, o, r*2, r*2);
          } else {
            if (dado == 5) {
              ellipse(-o, -o, r*2, r*2);
              ellipse(o, -o, r*2, r*2);
              ellipse(0, 0, r*2, r*2);
              ellipse(-o, o, r*2, r*2);
              ellipse(o, o, r*2, r*2);
            } else {
              if (dado == 6) {
                ellipse(-o, -o, r*2, r*2);
                ellipse(-o, 0, r*2, r*2);
                ellipse(-o, o, r*2, r*2);
                ellipse(o, -o, r*2, r*2);
                ellipse(o, 0, r*2, r*2);
                ellipse(o, o, r*2, r*2);
              }
            }
          }
        }
      }
    }
    rectMode(CORNER);
    popMatrix();

    // Dibujar servidores con colores combinados y conteo por jugador
    int baseY = boxY + int(boxH*0.20);
    int espaciadoServ = int((boxH*0.60) / 6);
    for (int i = 1; i <= 6; i++) {
      int sy = baseY + (i-1) * espaciadoServ;

      int virusServ = 0;
      int capacidad = 0;
      int j1Count = 0;
      int j2Count = 0;
      switch (i) {
      case 1:
        virusServ = servidor1;
        capacidad = 1;
        j1Count = servidor1J1;
        j2Count = servidor1J2;
        break;
      case 2:
        virusServ = servidor2;
        capacidad = 2;
        j1Count = servidor2J1;
        j2Count = servidor2J2;
        break;
      case 3:
        virusServ = servidor3;
        capacidad = 3;
        j1Count = servidor3J1;
        j2Count = servidor3J2;
        break;
      case 4:
        virusServ = servidor4;
        capacidad = 4;
        j1Count = servidor4J1;
        j2Count = servidor4J2;
        break;
      case 5:
        virusServ = servidor5;
        capacidad = 5;
        j1Count = servidor5J1;
        j2Count = servidor5J2;
        break;
      case 6:
        virusServ = servidor6;
        capacidad = -1;
        j1Count = servidor6J1;
        j2Count = servidor6J2;
        break;
      }

      boolean highlight = (juegoVirus && !dadoGirando && i == dado);
      if (j1Count > 0 && j2Count > 0) {
        if (highlight) fill(190, 220, 130);
        else fill(177, 202, 125);
      } else {
        if (j1Count > 0) {
          if (highlight) fill(80, 255, 170);
          else fill(50, 220, 120);
        } else {
          if (j2Count > 0) {
            if (highlight) fill(255, 180, 90);
            else fill(255, 140, 60);
          } else {
            if (highlight) fill(0, 120, 50);
            else fill(0, 80, 30);
          }
        }
      }

      // Borde según ocupación
      if (j1Count > 0 && j2Count > 0) {
        stroke(255, 220, 120);
      } else {
        if (j1Count > 0) {
          stroke(0, 255, 140);
        } else {
          if (j2Count > 0) {
            stroke(255, 170, 40);
          } else {
            stroke(0, 150, 50);
          }
        }
      }
      strokeWeight(3);
      rectMode(CENTER);
      int servX = boxX + int(boxW*0.68);
      rect(servX, sy, 200, 56, 8);
      rectMode(CORNER);

      noStroke();
      // Texto servidor en negro para máximo contraste sobre fondos verdes/naranja
      fill(0);
      textAlign(CENTER, CENTER);
      textSize(16);
      text("[S" + i + "]", servX-80, sy);

      textSize(16);
      if (i == 6) {
        text("∞", servX-10, sy);
      } else {
        text(virusServ + "/" + capacidad, servX-10, sy);
      }
      textSize(14);
      // Conteos también en negro para evitar pérdida de legibilidad cuando J1 pinta verde
      fill(0);
      text("J1:" + j1Count, servX + 55, sy - 12);
      text("J2:" + j2Count, servX + 55, sy + 12);
    }

    // Info jugadores (debajo del recuadro de servidores)
    fill(100, 255, 150);
    textSize(22);
    text("[J1] Virus restantes: " + virus1, boxX + int(boxW*0.25), boxY + int(boxH*0.56));
    fill(255, 150, 100);
    text("[J2] Virus restantes: " + virus2, boxX + int(boxW*0.25), boxY + int(boxH*0.61));

    // Verificar ganador
    if (juegoVirus && ganador == 0) {
      if (virus1 == 0) {
        ganador = 1;
        juegoVirus = false;
        out.playNote(0, 0.3, 800);
      }
      if (virus2 == 0) {
        ganador = 2;
        juegoVirus = false;
        out.playNote(0, 0.3, 800);
      }
    }

    // Mostrar ganador - Overlay pantalla completa
    if (ganador != 0) {
      // Fondo negro semi-transparente
      rectMode(CORNER);
      fill(0, 0, 0, 230);
      rect(0, 0, width, height);

      // Recuadro de victoria
      if (ganador == 1) {
        stroke(color(100, 255, 150));
      } else {
        stroke(color(255, 150, 100));
      }
      strokeWeight(6);
      noFill();
      rectMode(CENTER);
      rect(width/2, height/2, width*0.7, height*0.5, 20);

      // Texto ganador
      noStroke();
      if (ganador == 1) {
        fill(100, 255, 150);
      } else {
        fill(255, 150, 100);
      }
      textSize(64);
      text("¡VICTORIA!", width/2, height/2 - 80);

      textSize(48);
      text("JUGADOR " + ganador + " GANA", width/2, height/2 - 20);

      // Estadísticas finales
      fill(200);
      textSize(28);
      text("Virus restantes:", width/2, height/2 + 40);
      fill(100, 255, 150);
      text("Jugador 1: " + virus1, width/2 - 150, height/2 + 80);
      fill(255, 150, 100);
      text("Jugador 2: " + virus2, width/2 + 150, height/2 + 80);

      // Botón volver al menú
      int btnVolverX = width/2 - 100;
      int btnVolverY = height/2 + 140;
      int btnVolverW = 200;
      int btnVolverH = 50;

      fill(0, 80, 30);
      rectMode(CORNER);
      rect(btnVolverX, btnVolverY, btnVolverW, btnVolverH, 10);
      stroke(0, 255, 70);
      strokeWeight(3);
      noFill();
      rect(btnVolverX, btnVolverY, btnVolverW, btnVolverH, 10);

      noStroke();
      fill(0, 255, 70);
      textSize(22);
      text("VOLVER AL MENÚ", width/2, btnVolverY + btnVolverH/2 + 2);

      rectMode(CORNER);
    }
    break;

  case 3:  // PUNTO Y FAMA
    fill(0, 255, 70);
    textSize(48);
    text("[ PUNTO Y FAMA ]", width/2, 80);

    textSize(24);
    text("Ingresa 4 dígitos diferentes (0-9)", width/2, 160);

    // Mostrar código ingresado
    textSize(80);
    fill(0, 200, 50);
    int espaciado = 100;
    int inicioX = width/2 - 150;

    // Mostrar digito 1
    if (intento1 == -1) {
      text("_", inicioX, 280);
    } else {
      text(intento1, inicioX, 280);
    }

    // Mostrar digito 2
    if (intento2 == -1) {
      text("_", inicioX + espaciado, 280);
    } else {
      text(intento2, inicioX + espaciado, 280);
    }

    // Mostrar digito 3
    if (intento3 == -1) {
      text("_", inicioX + espaciado*2, 280);
    } else {
      text(intento3, inicioX + espaciado*2, 280);
    }

    // Mostrar digito 4
    if (intento4 == -1) {
      text("_", inicioX + espaciado*3, 280);
    } else {
      text(intento4, inicioX + espaciado*3, 280);
    }

    fill(0, 255, 70);
    textSize(22);
    text("Presiona ENTER para verificar", width/2, 360);

    textSize(28);
    if (intentos > 0) {
      text("Famas: " + famas + " | Puntos: " + puntos, width/2, 420);
      text("Intentos: " + intentos, width/2, 470);
    }

    if (ganoFama) {
      textSize(60);
      fill(0, 255, 100);
      text("¡GANASTE!", width/2, 550);
      textSize(28);
      text("El código era: " + codigo1 + " " + codigo2 + " " + codigo3 + " " + codigo4, width/2, 620);
      text("Total de intentos: " + intentos, width/2, 670);
    }
    break;

  case 5:  // CONVERSOR HEX
    rectMode(CORNER);
    fill(0, 255, 70);
    textSize(48);
    textAlign(CENTER, CENTER);
    text("[ CONVERSOR HEX ]", width/2, height*0.06);

    textSize(16);
    text("Presiona 0-9, A-F para ingresar | Backspace para borrar", width/2, height*0.10);

    // DISEÑO OPTIMIZADO - Pantalla completa

    // Tabla de referencia (izquierda) - mejor escalada
    int tablaX = int(width*0.13);
    int tablaY = int(height*0.16);
    int tablaAncho = int(width*0.16);
    int tablaAltura = int(height*0.74);

    stroke(0, 255, 70);
    strokeWeight(3);
    noFill();
    rect(tablaX, tablaY, tablaAncho, tablaAltura);

    fill(0, 255, 70);
    textSize(28);
    textAlign(CENTER, CENTER);
    text("TABLA HEX-DEC", tablaX + tablaAncho/2, tablaY + 20);

    textSize(28);
    int yTabla = int(tablaY + 60);
    int espacioTabla = int((tablaAltura - 80) / 16);

    for (int i = 0; i <= 15; i++) {
      fill(0, 200, 80);
      if (i < 10) {
        text(i + "  =  " + i, tablaX + tablaAncho/2, yTabla);
      } else {
        if (i == 10) text("A  =  10", tablaX + tablaAncho/2, yTabla);
        else if (i == 11) text("B  =  11", tablaX + tablaAncho/2, yTabla);
        else if (i == 12) text("C  =  12", tablaX + tablaAncho/2, yTabla);
        else if (i == 13) text("D  =  13", tablaX + tablaAncho/2, yTabla);
        else if (i == 14) text("E  =  14", tablaX + tablaAncho/2, yTabla);
        else if (i == 15) text("F  =  15", tablaX + tablaAncho/2, yTabla);
      }
      yTabla = yTabla + espacioTabla;
    }

    // Cuadro de entrada (centro-superior)
    int entradaX = int(width*0.35);
    int entradaY = int(height*0.16);
    int entradaAncho = int(width*0.28);
    int entradaAlto = int(height*0.15);

    stroke(0, 255, 70);
    strokeWeight(2);
    noFill();
    rect(entradaX, entradaY, entradaAncho, entradaAlto);

    fill(0, 255, 70);
    textSize(22);
    text("ENTRADA HEX", entradaX + entradaAncho/2, entradaY + 15);

    textSize(50);
    fill(0, 255, 100);

    if (hexContador == 0) {
      text("_ _ _ _", entradaX + entradaAncho/2, entradaY + entradaAlto/2 + 10);
    } else {
      if (hexContador == 1) {
        if (hexDigito1 < 10) {
          text(hexDigito1 + " _ _ _", entradaX + entradaAncho / 2, entradaY + entradaAlto / 2 + 10);
        } else {
          String letra = "";
          switch(hexDigito1) {
          case 10:
            letra = "A";
            break;
          case 11:
            letra = "B";
            break;
          case 12:
            letra = "C";
            break;
          case 13:
            letra = "D";
            break;
          case 14:
            letra = "E";
            break;
          case 15:
            letra = "F";
            break;
          }
          text(letra + " _ _ _", entradaX + entradaAncho/2, entradaY + entradaAlto/2 + 10);
        }
      } else {
        if (hexContador == 2) {
          String d1 = "";
          String d2 = "";
          if (hexDigito1 < 10) d1 = str(hexDigito1);
          else {
            switch(hexDigito1) {
            case 10:
              d1 = "A";
              break;
            case 11:
              d1 = "B";
              break;
            case 12:
              d1 = "C";
              break;
            case 13:
              d1 = "D";
              break;
            case 14:
              d1 = "E";
              break;
            case 15:
              d1 = "F";
              break;
            }
          }
          if (hexDigito2 < 10) {
            d2 = str(hexDigito2);
          } else {
            switch(hexDigito2) {
            case 10:
              d2 = "A";
              break;
            case 11:
              d2 = "B";
              break;
            case 12:
              d2 = "C";
              break;
            case 13:
              d2 = "D";
              break;
            case 14:
              d2 = "E";
              break;
            case 15:
              d2 = "F";
              break;
            }
          }
          text(d1 + " " + d2 + " _ _", entradaX + entradaAncho/2, entradaY + entradaAlto/2 + 10);
        } else {
          if (hexContador == 3) {
            String d1 = "";
            String d2 = "";
            String d3 = "";
            if (hexDigito1 < 10) {
              d1 = str(hexDigito1);
            } else {
              switch(hexDigito1) {
              case 10:
                d1 = "A";
                break;
              case 11:
                d1 = "B";
                break;
              case 12:
                d1 = "C";
                break;
              case 13:
                d1 = "D";
                break;
              case 14:
                d1 = "E";
                break;
              case 15:
                d1 = "F";
                break;
              }
            }
            if (hexDigito2 < 10) {
              d2 = str(hexDigito2);
            } else {
              switch(hexDigito2) {
              case 10:
                d2 = "A";
                break;
              case 11:
                d2 = "B";
                break;
              case 12:
                d2 = "C";
                break;
              case 13:
                d2 = "D";
                break;
              case 14:
                d2 = "E";
                break;
              case 15:
                d2 = "F";
                break;
              }
            }
            if (hexDigito3 < 10) {
              d3 = str(hexDigito3);
            } else {
              switch(hexDigito3) {
              case 10:
                d3 = "A";
                break;
              case 11:
                d3 = "B";
                break;
              case 12:
                d3 = "C";
                break;
              case 13:
                d3 = "D";
                break;
              case 14:
                d3 = "E";
                break;
              case 15:
                d3 = "F";
                break;
              }
            }
            text(d1 + " " + d2 + " " + d3 + " _", entradaX + entradaAncho/2, entradaY + entradaAlto/2 + 10);
          } else {
            if (hexContador == 4) {
              String d1 = "";
              String d2 = "";
              String d3 = "";
              String d4 = "";
              if (hexDigito1 < 10) {
                d1 = str(hexDigito1);
              } else {
                if (hexDigito1 == 10) d1 = "A";
                else {
                  if (hexDigito1 == 11) d1 = "B";
                  else {
                    if (hexDigito1 == 12) d1 = "C";
                    else {
                      if (hexDigito1 == 13) d1 = "D";
                      else {
                        if (hexDigito1 == 14) d1 = "E";
                        else {
                          if (hexDigito1 == 15) d1 = "F";
                        }
                      }
                    }
                  }
                }
              }
              if (hexDigito2 < 10) {
                d2 = str(hexDigito2);
              } else {
                switch(hexDigito2) {
                case 10:
                  d2 = "A";
                  break;
                case 11:
                  d2 = "B";
                  break;
                case 12:
                  d2 = "C";
                  break;
                case 13:
                  d2 = "D";
                  break;
                case 14:
                  d2 = "E";
                  break;
                case 15:
                  d2 = "F";
                  break;
                }
              }
              if (hexDigito3 < 10) {
                d3 = str(hexDigito3);
              } else {
                if (hexDigito3 == 10) d3 = "A";
                else {
                  if (hexDigito3 == 11) d3 = "B";
                  else {
                    if (hexDigito3 == 12) d3 = "C";
                    else {
                      if (hexDigito3 == 13) d3 = "D";
                      else {
                        if (hexDigito3 == 14) d3 = "E";
                        else {
                          if (hexDigito3 == 15) d3 = "F";
                        }
                      }
                    }
                  }
                }
              }
              if (hexDigito4 < 10) {
                d4 = str(hexDigito4);
              } else {
                switch(hexDigito4) {
                case 10:
                  d4 = "A";
                  break;
                case 11:
                  d4 = "B";
                  break;
                case 12:
                  d4 = "C";
                  break;
                case 13:
                  d4 = "D";
                  break;
                case 14:
                  d4 = "E";
                  break;
                case 15:
                  d4 = "F";
                  break;
                }
              }
              text(d1 + " " + d2 + " " + d3 + " " + d4, entradaX + entradaAncho/2, entradaY + entradaAlto/2 + 10);
            }
          }
        }
      }
    }

    // Cuadro de resultado (derecha superior)
    int resultadoX = int(width*0.69);
    int resultadoY = entradaY;
    int resultadoAncho = int(width*0.20);
    int resultadoAlto = entradaAlto;

    stroke(0, 255, 70);
    strokeWeight(2);
    noFill();
    rect(resultadoX, resultadoY, resultadoAncho, resultadoAlto);

    fill(0, 255, 70);
    textSize(22);
    textAlign(CENTER, CENTER);
    text("RESULTADO DEC", resultadoX + resultadoAncho/2, resultadoY + 15);

    textSize(50);
    fill(0, 255, 200);
    text(hexDecimal, resultadoX + resultadoAncho/2, resultadoY + resultadoAlto/2 + 10);

    // Cuadro de proceso (abajo, a la derecha de la tabla, sin solapar)
    int margenGeneral = int(height*0.02);
    int margenInferior = int(height*0.08);
    int procesoX = entradaX;
    int procesoY = entradaY + entradaAlto + margenGeneral;
    int procesoAncho = (resultadoX + resultadoAncho) - procesoX - margenGeneral;
    int procesoAlto = height - procesoY - margenInferior;

    stroke(0, 255, 70);
    strokeWeight(2);
    noFill();
    rect(procesoX, procesoY, procesoAncho, procesoAlto);

    fill(0, 255, 70);
    textSize(32);
    textAlign(CENTER, CENTER);
    text("PROCESO DE CONVERSIÓN", procesoX + procesoAncho/2, procesoY + 25);

    textSize(28);
    textAlign(LEFT, CENTER);
    int procesoTextoY = procesoY + 70;
    int margenIzq = procesoX + int(width*0.02);

    if (hexContador > 0) {
      // Mostrar fórmula
      fill(0, 200, 80);
      text("Fórmula: (dígito × 16^posición)", margenIzq, procesoTextoY);

      procesoTextoY = procesoTextoY + 48;

      // Mostrar cálculos paso a paso
      if (hexDigito1 != -1) {
        int val1 = hexDigito1;
        int pot1 = 1;
        for (int i = 0; i < hexContador - 1; i++) {
          pot1 = pot1 * 16;
        }
        fill(0, 200, 70);
        text("Posición " + (hexContador-1) + ": " + val1 + " × " + pot1 + " = " + (val1 * pot1), margenIzq, procesoTextoY);
        procesoTextoY = procesoTextoY + 40;
      }

      if (hexDigito2 != -1 && hexContador >= 2) {
        int val2 = hexDigito2;
        int pot2 = 1;
        for (int i = 0; i < hexContador - 2; i++) {
          pot2 = pot2 * 16;
        }
        fill(0, 200, 70);
        text("Posición " + (hexContador-2) + ": " + val2 + " × " + pot2 + " = " + (val2 * pot2), margenIzq, procesoTextoY);
        procesoTextoY = procesoTextoY + 40;
      }

      if (hexDigito3 != -1 && hexContador >= 3) {
        int val3 = hexDigito3;
        int pot3 = 1;
        for (int i = 0; i < hexContador - 3; i++) {
          pot3 = pot3 * 16;
        }
        fill(0, 200, 70);
        text("Posición " + (hexContador-3) + ": " + val3 + " × " + pot3 + " = " + (val3 * pot3), margenIzq, procesoTextoY);
        procesoTextoY = procesoTextoY + 40;
      }

      if (hexDigito4 != -1 && hexContador >= 4) {
        int val4 = hexDigito4;
        fill(0, 200, 70);
        text("Posición 0: " + val4 + " × 1 = " + val4, margenIzq, procesoTextoY);
        procesoTextoY = procesoTextoY + 40;
      }

      // Suma total
      fill(0, 255, 100);
      text("TOTAL = " + hexDecimal + " (decimal)", margenIzq, procesoTextoY + 10);
    } else {
      fill(0, 180, 60);
      textSize(22);
      text("Ingresa un número hexadecimal para ver el proceso...", margenIzq, procesoTextoY + 20);
    }

    textAlign(CENTER, CENTER);
    break;

  case 6:  // MENÚ OPERACIONES MATEMÁTICAS
    stroke(0, 255, 70);
    strokeWeight(3);
    noFill();
    rect(width/2, height/2, width*0.7, height*0.75);

    fill(0, 255, 70);
    textSize(48);
    text("[ OPERACIONES MATEMÁTICAS ]", width/2, height*0.15);

    // Botón 1: Multiplicación Rusa
    int opBtn1X = width/2 - 350;
    int opBtn1Y = height/2 - 100;
    int opBtnW = 300;
    int opBtnH = 90;

    fill(0, 50, 20);
    rect(opBtn1X, opBtn1Y, opBtnW, opBtnH, 15);
    stroke(0, 255, 70);
    strokeWeight(2);
    noFill();
    rect(opBtn1X, opBtn1Y, opBtnW, opBtnH, 15);
    noStroke();
    fill(0, 255, 70);
    textSize(20);
    text("MULTIPLICACIÓN\nRUSA", opBtn1X + opBtnW/2, opBtn1Y + opBtnH/2);

    // Botón 2: Clave de un Número
    int opBtn2X = width/2 - 150;
    int opBtn2Y = opBtn1Y + 120;
    fill(0, 50, 20);
    rect(opBtn2X, opBtn2Y, opBtnW, opBtnH, 15);
    stroke(0, 255, 70);
    strokeWeight(2);
    noFill();
    rect(opBtn2X, opBtn2Y, opBtnW, opBtnH, 15);
    noStroke();
    fill(0, 255, 70);
    text("CLAVE DE UN\nNÚMERO", opBtn2X + opBtnW/2, opBtn2Y + opBtnH/2);

    // Botón 3: Funciones Trigonométricas
    int opBtn3X = opBtn1X + 350;
    int opBtn3Y = opBtn1Y;
    fill(0, 50, 20);
    rect(opBtn3X, opBtn3Y, opBtnW, opBtnH, 15);
    stroke(0, 255, 70);
    strokeWeight(2);
    noFill();
    rect(opBtn3X, opBtn3Y, opBtnW, opBtnH, 15);
    noStroke();
    fill(0, 255, 70);
    text("FUNCIONES\nTRIGONOMÉTRICAS", opBtn3X + opBtnW/2, opBtn3Y + opBtnH/2);
    break;

  case 7:  // MULTIPLICACIÓN RUSA
    // Colores condicionales
    int colorPrincipal7;
    int colorBoton7;

    if (coloresAzules) {
      colorPrincipal7 = color(0, 100, 255);
      colorBoton7 = color(0, 30, 80);
    } else {
      colorPrincipal7 = color(0, 255, 70);
      colorBoton7 = color(0, 80, 30);
    }

    fill(colorPrincipal7);
    textSize(42);
    text("[ MULTIPLICACIÓN RUSA ]", width/2, 80);

    // Campos de entrada
    textSize(20);
    textAlign(LEFT, BASELINE);
    fill(230);
    text("Multiplicador:", 150, 160);
    text("Multiplicando:", 550, 160);

    fill(245);
    stroke(colorPrincipal7);
    rect(150, 170, 320, 50, 10);
    rect(550, 170, 320, 50, 10);
    noStroke();

    fill(0);
    textSize(24);
    String txtRM = "";
    if (rusaTieneM) txtRM = "" + rusaM;
    String txtRN = "";
    if (rusaTieneN) txtRN = "" + rusaN;
    text(txtRM, 160, 205);
    text(txtRN, 560, 205);

    // Botones
    fill(colorBoton7);
    rect(width/2 - 180, 240, 180, 50, 12);
    rect(width/2 + 10, 240, 180, 50, 12);
    stroke(colorPrincipal7);
    strokeWeight(2);
    noFill();
    rect(width/2 - 180, 240, 180, 50, 12);
    rect(width/2 + 10, 240, 180, 50, 12);
    noStroke();
    fill(colorPrincipal7);
    textAlign(CENTER, CENTER);
    text("CALCULAR", width/2 - 90, 265);
    text("LIMPIAR", width/2 + 100, 265);

    // Panel Proceso
    fill(245);
    stroke(colorPrincipal7);
    rect(100, 310, 800, 320, 15);
    noStroke();
    fill(0);
    textAlign(LEFT, TOP);
    textSize(18);
    text(rusaProceso, 120, 330, 760, 290);
    textAlign(CENTER, CENTER);
    break;

  case 8:  // CLAVE DE UN NÚMERO
    // Colores condicionales
    int colorPrincipal8 = coloresAzules ? color(0, 100, 255) : color(0, 255, 70);
    int colorBoton8 = coloresAzules ? color(0, 30, 80) : color(0, 80, 30);

    fill(colorPrincipal8);
    textSize(42);
    text("[ CLAVE DE UN NÚMERO ]", width/2, 80);

    textSize(20);
    textAlign(LEFT, BASELINE);
    fill(230);
    text("Número entero:", 250, 160);

    fill(245);
    stroke(colorPrincipal8);
    rect(250, 170, 500, 50, 10);
    noStroke();

    String txtClave = "";
    if (claveSignoNeg) {
      if (claveTieneValor) {
        txtClave = "-" + claveValorAbs;
      } else {
        txtClave = "-";
      }
    } else {
      if (claveTieneValor) txtClave = "" + claveValorAbs;
    }
    fill(0);
    textSize(24);
    text(txtClave, 260, 205);

    fill(colorBoton8);
    rect(width/2 - 180, 240, 180, 50, 12);
    rect(width/2 + 10, 240, 180, 50, 12);
    stroke(colorPrincipal8);
    strokeWeight(2);
    noFill();
    rect(width/2 - 180, 240, 180, 50, 12);
    rect(width/2 + 10, 240, 180, 50, 12);
    noStroke();
    fill(colorPrincipal8);
    textAlign(CENTER, CENTER);
    text("CALCULAR", width/2 - 90, 265);
    text("LIMPIAR", width/2 + 100, 265);

    fill(245);
    stroke(colorPrincipal8);
    rect(100, 310, 800, 320, 15);
    noStroke();
    fill(0);
    textAlign(LEFT, TOP);
    textSize(18);
    text(claveProceso, 120, 330, 760, 290);
    textAlign(CENTER, CENTER);
    break;

  case 9:  // FUNCIONES TRIGONOMÉTRICAS
    // Colores condicionales
    int colorPrincipal9;
    int colorBotonActivo9;
    int colorBoton9;
    int colorBotonCalc9;

    if (coloresAzules) {
      colorPrincipal9 = color(0, 100, 255);
      colorBotonActivo9 = color(0, 60, 180);
      colorBoton9 = color(0, 30, 80);
      colorBotonCalc9 = color(0, 30, 80);
    } else {
      colorPrincipal9 = color(0, 255, 70);
      colorBotonActivo9 = color(0, 180, 60);
      colorBoton9 = color(0, 50, 20);
      colorBotonCalc9 = color(0, 80, 30);
    }

    fill(colorPrincipal9);
    textSize(38);
    text("[ FUNCIONES TRIGONOMÉTRICAS ]", width/2, 70);
    textSize(24);
    text("Series de Taylor", width/2, 110);

    // Selector de función
    textAlign(LEFT, BASELINE);
    textSize(22);
    fill(230);
    text("Función:", 100, 160);

    textAlign(CENTER, CENTER);
    int fX = 100;
    int fY = 180;
    int fW = 120;
    int fH = 50;
    int f = 0;
    while (f < 6) {
      int fx = fX + (f % 3) * 110;
      int fy = fY + (f / 3) * 50;
      if (taylorFuncion == f + 1) {
        fill(colorBotonActivo9);
      } else {
        fill(colorBoton9);
      }
      rect(fx, fy, fW, fH, 10);
      stroke(colorPrincipal9);
      noFill();
      rect(fx, fy, fW, fH, 10);
      noStroke();
      fill(colorPrincipal9);
      String fname = "";
      switch(f) {
      case 0:
        fname = "SIN";
        break;
      case 1:
        fname = "COS";
        break;
      case 2:
        fname = "TAN";
        break;
      case 3:
        fname = "SEC";
        break;
      case 4:
        fname = "CSC";
        break;
      default:
        fname = "COT";
        break;
      }
      text(fname, fx + fW/2, fy + fH/2);
      f = f + 1;
    }

    // Campos
    textAlign(LEFT, BASELINE);
    textSize(22);
    fill(230);
    text("Ángulo (grados):", 100, 340);
    text("Términos N:", 100, 430);

    fill(245);
    stroke(colorPrincipal9);
    rect(100, 350, 450, 60, 10);
    rect(100, 440, 450, 60, 10);
    noStroke();

    String txtAng = "";
    if (tAngSignoNeg) {
      if (tAngTieneValor) {
      txtAng = "-" + tAnguloAbs;
      } else {
        txtAng = "-";
      }
    } else {
      if (tAngTieneValor) {
        txtAng = "" + tAnguloAbs;
      }
    }
    String txtN = "";
    if (tNTieneValor) txtN = "" + tN;
    fill(0);
    textSize(28);
    text(txtAng, 120, 385);
    text(txtN, 120, 475);

    // Cuadro de resultado debajo de "Términos N"
    int resultCuadroX = 100;
    int resultCuadroY = 520;
    int resultCuadroW = 450;
    int resultCuadroH = 80;

    fill(245);
    stroke(colorPrincipal9);
    strokeWeight(2);
    rect(resultCuadroX, resultCuadroY, resultCuadroW, resultCuadroH, 10);
    noStroke();

    fill(colorPrincipal9);
    textSize(20);
    textAlign(LEFT, BASELINE);
    text("Resultado:", resultCuadroX + 10, resultCuadroY - 8);

    fill(0);
    textSize(24);
    textAlign(CENTER, CENTER);
    text(tResultado, resultCuadroX + resultCuadroW/2, resultCuadroY + resultCuadroH/2);

    fill(colorBotonCalc9);
    rect(100, 620, 200, 60, 12);
    rect(320, 620, 200, 60, 12);
    stroke(colorPrincipal9);
    strokeWeight(2);
    noFill();
    rect(100, 620, 200, 60, 12);
    rect(320, 620, 200, 60, 12);
    noStroke();
    fill(colorPrincipal9);
    textSize(22);
    textAlign(CENTER, CENTER);
    text("CALCULAR", 200, 650);
    text("LIMPIAR", 420, 650);

    // Panel Resultado (con GIF de la función seleccionada)
    int panelX = 580;
    int panelY = 200;
    int panelW = 420;
    int panelH = 480;
    fill(245);
    stroke(colorPrincipal9);
    rect(panelX, panelY, panelW, panelH, 15);
    noStroke();

    // Área de imagen dentro del panel
    int cMargin = 20;
    int imgMaxW = panelW - 2*cMargin;   // 380
    int imgMaxH = 220;                   // alto reservado para GIF
    int imgAreaX = panelX + cMargin + 100;
    int imgAreaY = panelY + cMargin + 180;

    Gif gifActual = null;
    switch(taylorFuncion) {
    case 1:
      gifActual = gifSIN;
      break;
    case 2:
      gifActual = gifCOS;
      break;
    case 3:
      gifActual = gifTAN;
      break;
    case 4:
      gifActual = gifSEC;
      break;
    case 5:
      gifActual = gifCSC;
      break;
    case 6:
      gifActual = gifCOT;
      break;
    }

    if (gifActual != null) {
      float iw = gifActual.width;
      float ih = gifActual.height;
      float s = min((float)imgMaxW/iw, (float)imgMaxH/ih);
      int dw = int(iw * s);
      int dh = int(ih * s);
      int dx = imgAreaX + (imgMaxW - dw)/2;
      int dy = imgAreaY + (imgMaxH - dh)/2;
      image(gifActual, dx, dy, dw, dh);
    } else {
      // Mensaje si falta el GIF
      fill(120);
      textAlign(CENTER, CENTER);
      textSize(16);
      text("Coloca el GIF de la función en la carpeta data", panelX + panelW/2, panelY + cMargin + imgMaxH/2);
    }

    // Fórmula de Taylor debajo del GIF
    fill(0);
    textAlign(CENTER, CENTER);
    textSize(14);
    int formulaY = imgAreaY + imgMaxH + 40;
    String formula = "";
    switch(taylorFuncion) {
    case 1:
      formula = "sin(x) ≈ x - x³/3! + x⁵/5! - x⁷/7! + ...";
      break;
    case 2:
      formula = "cos(x) ≈ 1 - x²/2! + x⁴/4! - x⁶/6! + ...";
      break;
    case 3:
      formula = "tan(x) = sin(x) / cos(x)";
      break;
    case 4:
      formula = "sec(x) = 1 / cos(x)";
      break;
    case 5:
      formula = "csc(x) = 1 / sin(x)";
      break;
    case 6:
      formula = "cot(x) = cos(x) / sin(x)";
      break;
    }
    text(formula, panelX + panelW/2, formulaY);
    textAlign(CENTER, CENTER);
    break;

  case 10:  // MENU PROCESOS MATEMATICOS (CON COLORES AZULES)
    // Caja principal
    rectMode(CENTER);
    stroke(0, 100, 255);
    strokeWeight(3);
    noFill();
    rect(width/2, height/2, width*0.6, height*0.7);

    // Título
    fill(0, 100, 255);
    textSize(48);
    textAlign(CENTER, CENTER);
    text("[ PROCESOS MATEMÁTICOS ]", width/2, height/2-200);

    textSize(20);
    textAlign(LEFT, BASELINE);
    text("> SELECCIONA UN PROCESO", width/2-300, height/2-280);

    // Configuración de botones
    textAlign(CENTER, CENTER);
    int procBtnW = 320;
    int procBtnH = 80;
    int espaciadoH = 220;

    // Botón 1: Multiplicación Rusa (izquierda)
    int procBtn1X = width/2 - espaciadoH;
    int procBtn1Y = height/2 - 30;

    fill(0, 30, 80);
    rect(procBtn1X, procBtn1Y, procBtnW, procBtnH, 15);
    stroke(0, 100, 255);
    strokeWeight(2);
    noFill();
    rect(procBtn1X, procBtn1Y, procBtnW, procBtnH, 15);
    noStroke();
    fill(0, 100, 255);
    textSize(22);
    text("MULTIPLICACIÓN\nRUSA", procBtn1X, procBtn1Y);

    // Botón 2: Funciones Trigonométricas (derecha)
    int procBtn2X = width/2 + espaciadoH;
    int procBtn2Y = height/2 - 30;

    fill(0, 30, 80);
    rect(procBtn2X, procBtn2Y, procBtnW, procBtnH, 15);
    stroke(0, 100, 255);
    strokeWeight(2);
    noFill();
    rect(procBtn2X, procBtn2Y, procBtnW, procBtnH, 15);
    noStroke();
    fill(0, 100, 255);
    textSize(22);
    text("FUNCIONES\nTRIGONOMÉTRICAS", procBtn2X, procBtn2Y);

    // Botón 3: Clave de un Número (centro abajo)
    int procBtn3X = width/2;
    int procBtn3Y = height/2 + 90;

    fill(0, 30, 80);
    rect(procBtn3X, procBtn3Y, procBtnW, procBtnH, 15);
    stroke(0, 100, 255);
    strokeWeight(2);
    noFill();
    rect(procBtn3X, procBtn3Y, procBtnW, procBtnH, 15);
    noStroke();
    fill(0, 100, 255);
    textSize(22);
    text("CLAVE DE UN\nNÚMERO", procBtn3X, procBtn3Y);

    rectMode(CORNER);
    break;

  case 11:  // LA MARGARITA
    // FONDO ESTILO "MATRIX" VERDE
    background(5, 25, 10);

    // Título / ganador
    fill(0, 255, 120);
    textSize(28);
    if (!juegoTerminado) {
      text("SISTEMA DE ACCESO - LA MARGARITA", width/2, 40);
    } else {
      if (ganadorMargarita == 1) {
        text("GANA EL JUGADOR 1", width/2, 40);
      } else {
        if (ganadorMargarita == 2) {
          text("GANA EL JUGADOR 2", width/2, 40);
        }
      }
    }

    // Texto de turno o reinicio
    textSize(18);
    if (!juegoTerminado) {
      text("Turno del jugador: " + turno, width/2, 70);
      text("1) Haz clic en 1 o 2 pétalos", width/2, 95);
      text("2) Pulsa ENTER para confirmar", width/2, 120);
    } else {
      text("Pulsa ENTER para jugar de nuevo", width/2, 80);
    }

    // Centro de la flor: estilo "candado"
    stroke(0, 255, 160);
    fill(0, 80, 40);
    ellipse(cx, cy, 140, 140);

    // arco del candado
    noFill();
    stroke(0, 255, 160);
    strokeWeight(6);
    arc(cx, cy - 40, 80, 90, PI, TWO_PI);

    // cuerpo del candado
    strokeWeight(2);
    fill(0, 100, 55);
    rectMode(CENTER);
    rect(cx, cy + 10, 90, 80, 12);

    // "chip" del candado
    fill(0, 180, 100);
    ellipse(cx, cy + 10, 18, 18);

    // Dibujo de los 9 pétalos
    int pos = 1;
    while (pos <= 9) {

      // indice en el anillo: 1-2-3-5-7-9-8-6-4
      int indice = 0;
      switch(pos) {
      case 1:
        indice = 0;
        break;
      case 2:
        indice = 1;
        break;
      case 3:
        indice = 2;
        break;
      case 5:
        indice = 3;
        break;
      case 7:
        indice = 4;
        break;
      case 9:
        indice = 5;
        break;
      case 8:
        indice = 6;
        break;
      case 6:
        indice = 7;
        break;
      case 4:
        indice = 8;
        break;
      }

      float ang = -HALF_PI + indice * (TWO_PI / 9.0);
      float petalX = cx + cos(ang) * radio;
      float petalY = cy + sin(ang) * radio;

      // Línea del centro al pétalo
      stroke(0, 120, 60);
      line(cx, cy, petalX, petalY);

      // Valor de la casilla (1 = hay ficha, 0 = vacío)
      int valor = 0;
      switch(pos) {
      case 1:
        valor = p1;
        break;
      case 2:
        valor = p2;
        break;
      case 3:
        valor = p3;
        break;
      case 4:
        valor = p4;
        break;
      case 5:
        valor = p5;
        break;
      case 6:
        valor = p6;
        break;
      case 7:
        valor = p7;
        break;
      case 8:
        valor = p8;
        break;
      case 9:
        valor = p9;
        break;
      }

      // Color del pétalo según si hay ficha o no
      if (valor == 1) {
        // pétalo con ficha: verde brillante
        fill(0, 220, 100);
      } else {
        // pétalo vacío: verde oscuro
        fill(10, 50, 25);
      }
      stroke(0, 0, 0);
      ellipse(petalX, petalY, radioPetalo, radioPetalo);

      // Resaltado si está seleccionado
      if (sel1 == pos || sel2 == pos) {
        noFill();
        stroke(0, 255, 0);
        strokeWeight(4);
        ellipse(petalX, petalY, radioPetalo + 14, radioPetalo + 14);
        strokeWeight(1);
      }

      // OJO: ya NO se muestran los números de posición
      pos = pos + 1;
    }

    // Mensaje de error
    if (mensajeError) {
      fill(255, 80, 80);
      textSize(16);
      text("Movimiento inválido", width/2, height - 40);
    }

    // Mensaje final de ACCESO CONCEDIDO
    if (juegoTerminado) {
      fill(0, 255, 120);
      textSize(22);
      text("ACCESO CONCEDIDO AL JUGADOR " + ganadorMargarita, width/2, height - 80);
    }
    break;
  }
  
  // Mostrar versión en la esquina inferior derecha
  if (coloresAzules) {
    fill(0, 100, 255, 150);
  } else {
    fill(0, 255, 70, 150);
  }
  textSize(14);
  textAlign(RIGHT, BOTTOM);
  text("Beta 1.0", width - 20, height - 10);
  textAlign(CENTER, CENTER);
}

//=====================================================================
// EVENTOS DE BOTONES
//=====================================================================
void controlEvent(ControlEvent e) {
  if (e.isController()) {
    boolean esMusica = false, esVolver = false, esMiscelaniaVirus = false, esVirus = false, esFama = false;
    boolean esMargarita = false, esExtras = false, esHexConversor = false, esOperaciones = false, esProcesosMat = false;
    boolean esIniciar = false, esParar = false, esSalir = false;

    if (e.getController() == cp5.getController("btnMusica")) {
      esMusica = true;}
    if (e.getController() == cp5.getController("btnVolver")) {
      esVolver = true;}
    if (e.getController() == cp5.getController("btnMiscelaniaVirus")) {
      esMiscelaniaVirus = true;}
    if (e.getController() == cp5.getController("btnVirus")) {
      esVirus = true;}
    if (e.getController() == cp5.getController("btnFama")) {
      esFama = true;}
    if (e.getController() == cp5.getController("btnMargarita")) {
      esMargarita = true;}
    if (e.getController() == cp5.getController("btnExtras")) {
      esExtras = true;}
    if (e.getController() == cp5.getController("btnHexConversor")) {
      esHexConversor = true;}
    if (e.getController() == cp5.getController("btnOperaciones")) {
      esOperaciones = true;}
    if (e.getController() == cp5.getController("btnProcesosMat")) {
      esProcesosMat = true;}
    if (e.getController() == cp5.getController("btnIniciar")) {
      esIniciar = true;}
    if (e.getController() == cp5.getController("btnParar")) {
      esParar = true;}
    if (e.getController() == cp5.getController("btnSalir")) {
      esSalir = true;}

    if (esSalir) {
      exit();
  }
    if (esMusica) {
      if (musicaActiva) {
        musicaFondo.pause();
        musicaActiva = false;
        cp5.getController("btnMusica").setLabel("[ MUSICA: OFF ]");
      } else {
        musicaFondo.play();
        musicaActiva = true;
        cp5.getController("btnMusica").setLabel("[ MUSICA: ON ]");
      }
    }

    if (esVolver) {
      if (coloresAzules && (pantalla == 7 || pantalla == 8 || pantalla == 9)) {
        // Volver al menú Procesos Matemáticos
        pantalla = 10;
      } else {
        if (pantalla == 2 || pantalla == 3 || pantalla == 11) {
          // Volver al menú Miscelania Juegos desde los juegos (Virus, Punto y Fama, La Margarita)
          pantalla = 1;
        } else {
          if (pantalla == 5) {
            // Volver al menú Extras desde Hex Conversor
            pantalla = 4;
          } else {
            if (pantalla == 1 || pantalla == 4 || pantalla == 10) {
              // Volver al menú principal desde los submenús
              pantalla = 0;
              coloresAzules = false;
            } else {
              pantalla = 0;
              coloresAzules = false;
            }
          }
        }
      }
      juegoVirus = false;
      ganador = 0;
      ganoFama = false;
      intento1 = intento2 = intento3 = intento4 = -1;
      intentos = 0;
      famas = 0;
      puntos = 0;
    }

    if (esMiscelaniaVirus) pantalla = 1;

    if (esVirus) {
      pantalla = 2;
      virus1 = 10;
      virus2 = 10;
      servidor1 = servidor2 = servidor3 = servidor4 = servidor5 = servidor6 = 0;
      servidor1J1 = servidor1J2 = servidor2J1 = servidor2J2 = 0;
      servidor3J1 = servidor3J2 = servidor4J1 = servidor4J2 = 0;
      servidor5J1 = servidor5J2 = servidor6J1 = servidor6J2 = 0;
      ganador = 0;
      juegoVirus = false;
      dadoGirando = false;
      intento1 = intento2 = intento3 = intento4 = -1;
    }

    if (esFama) {
      pantalla = 3;
      intento1 = intento2 = intento3 = intento4 = -1;
      intentos = 0;
      ganoFama = false;
      famas = 0;
      puntos = 0;
    }

    if (esMargarita) pantalla = 11;
    if (esExtras) {
      pantalla = 4;
      intento1 = intento2 = intento3 = intento4 = -1;
    }
    if (esHexConversor) {
      pantalla = 5;
      hexDigito1 = hexDigito2 = hexDigito3 = hexDigito4 = -1;
      hexDecimal = 0;
      hexContador = 0;
    }
    if (esOperaciones) pantalla = 6;
    if (esProcesosMat) {
      pantalla = 10;
      coloresAzules = true;
    }

    if (esIniciar) {
      if (!juegoVirus) {
        // Primer inicio del juego
        juegoVirus = true;
        turnoJugador = 1;
        dadoGirando = true;
        contadorDado = 0;
        out.playNote(0, 0.1, 400);
      } else if (!dadoGirando) {
        // Reiniciar dado después de colocar
        dadoGirando = true;
        contadorDado = 0;
        out.playNote(0, 0.1, 400);
      }
    }

    if (esParar) {
      if (dadoGirando && ganador == 0) {
        dadoGirando = false;
        out.playNote(0, 0.12, 600);
        // Colocación automática al parar
        if (pantalla == 2 && juegoVirus && dado >= 1 && dado <= 6) {
          int virusServ = 0, capacidad = 0;
          switch (dado) {
          case 1:
            virusServ = servidor1;
            capacidad = 1;
            break;
          case 2:
            virusServ = servidor2;
            capacidad = 2;
            break;
          case 3:
            virusServ = servidor3;
            capacidad = 3;
            break;
          case 4:
            virusServ = servidor4;
            capacidad = 4;
            break;
          case 5:
            virusServ = servidor5;
            capacidad = 5;
            break;
          case 6:
            virusServ = servidor6;
            capacidad = -1;
            break;
          }
          if (turnoJugador == 1 && virus1 > 0) {
            if (dado == 6) {
              virus1--;
              servidor6++;
              servidor6J1++;
              turnoJugador = 2;
              out.playNote(0, 0.15, 500);
            } else if (virusServ >= capacidad) {
              virus1 += virusServ;
              if (dado == 1) {
                servidor1 = 0;
                servidor1J1 = 0;
                servidor1J2 = 0;
              } else if (dado == 2) {
                servidor2 = 0;
                servidor2J1 = 0;
                servidor2J2 = 0;
              } else if (dado == 3) {
                servidor3 = 0;
                servidor3J1 = 0;
                servidor3J2 = 0;
              } else if (dado == 4) {
                servidor4 = 0;
                servidor4J1 = 0;
                servidor4J2 = 0;
              } else if (dado == 5) {
                servidor5 = 0;
                servidor5J1 = 0;
                servidor5J2 = 0;
              }
              turnoJugador = 2;
              out.playNote(0, 0.2, 150);
            } else {
              virus1--;
              if (dado == 1) {
                servidor1++;
                servidor1J1++;
              } else if (dado == 2) {
                servidor2++;
                servidor2J1++;
              } else if (dado == 3) {
                servidor3++;
                servidor3J1++;
              } else if (dado == 4) {
                servidor4++;
                servidor4J1++;
              } else if (dado == 5) {
                servidor5++;
                servidor5J1++;
              }
              turnoJugador = 2;
              out.playNote(0, 0.15, 500);
            }
          } else if (turnoJugador == 2 && virus2 > 0) {
            if (dado == 6) {
              virus2--;
              servidor6++;
              servidor6J2++;
              turnoJugador = 1;
              out.playNote(0, 0.15, 500);
            } else if (virusServ >= capacidad) {
              virus2 += virusServ;
              if (dado == 1) {
                servidor1 = 0;
                servidor1J1 = 0;
                servidor1J2 = 0;
              } else if (dado == 2) {
                servidor2 = 0;
                servidor2J1 = 0;
                servidor2J2 = 0;
              } else if (dado == 3) {
                servidor3 = 0;
                servidor3J1 = 0;
                servidor3J2 = 0;
              } else if (dado == 4) {
                servidor4 = 0;
                servidor4J1 = 0;
                servidor4J2 = 0;
              } else if (dado == 5) {
                servidor5 = 0;
                servidor5J1 = 0;
                servidor5J2 = 0;
              }
              turnoJugador = 1;
              out.playNote(0, 0.2, 150);
            } else {
              virus2--;
              if (dado == 1) {
                servidor1++;
                servidor1J2++;
              } else if (dado == 2) {
                servidor2++;
                servidor2J2++;
              } else if (dado == 3) {
                servidor3++;
                servidor3J2++;
              } else if (dado == 4) {
                servidor4++;
                servidor4J2++;
              } else if (dado == 5) {
                servidor5++;
                servidor5J2++;
              }
              turnoJugador = 1;
              out.playNote(0, 0.15, 500);
            }
          }
        }
      }
    }
  }
  // Fin controlEvent
}

//=====================================================================
// CLICKS DEL MOUSE
//=====================================================================
void mousePressed() {
  // Click en botón volver al menú cuando hay ganador
  if (pantalla == 2 && ganador != 0) {
    int btnVolverX = width/2 - 100;
    int btnVolverY = height/2 + 140;
    int btnVolverW = 200;
    int btnVolverH = 50;

    if (mouseX > btnVolverX && mouseX < btnVolverX + btnVolverW &&
      mouseY > btnVolverY && mouseY < btnVolverY + btnVolverH) {
      pantalla = 1;
      ganador = 0;
      juegoVirus = false;
      out.playNote(0, 0.2, 600);
      return;
    }
  }

  // Clicks en pantalla de Menú Operaciones (pantalla 6)
  if (pantalla == 6) {
    // Botón Multiplicación Rusa
    if (mouseX > width/2 - 350 && mouseX < width/2 - 50 &&
      mouseY > height/2 - 100 && mouseY < height/2 - 10) {
      pantalla = 7;
      rusaEscribiendoM = false;
      rusaEscribiendoN = false;
      rusaTieneM = false;
      rusaTieneN = false;
      rusaM = 0;
      rusaN = 0;
      rusaProceso = "";
      out.playNote(0, 0.18, 600);
    }
    // Botón Clave de un Número
    if (mouseX > width/2 - 150 && mouseX < width/2 + 150 &&
      mouseY > height/2 + 20 && mouseY < height/2 + 110) {
      pantalla = 8;
      claveEscribiendo = false;
      claveSignoNeg = false;
      claveTieneValor = false;
      claveValorAbs = 0;
      claveProceso = "";
      out.playNote(0, 0.18, 650);
    }
    // Botón Funciones Trigonométricas
    if (mouseX > width/2 + 50 && mouseX < width/2 + 350 &&
      mouseY > height/2 - 100 && mouseY < height/2 - 10) {
      pantalla = 9;
      taylorFuncion = 1;
      tAngEscribiendo = false;
      tNEscribiendo = false;
      tAngSignoNeg = false;
      tAngTieneValor = false;
      tAnguloAbs = 0;
      tNTieneValor = false;
      tN = 0;
      tResultado = "";
      out.playNote(0, 0.18, 700);
    }
  }

  // Clicks en Multiplicación Rusa (pantalla 7)
  if (pantalla == 7) {
    // Campo multiplicador
    if (mouseX > 150 && mouseX < 470 && mouseY > 170 && mouseY < 220) {
      rusaEscribiendoM = true;
      rusaEscribiendoN = false;
    }
    // Campo multiplicando
    if (mouseX > 550 && mouseX < 870 && mouseY > 170 && mouseY < 220) {
      rusaEscribiendoM = false;
      rusaEscribiendoN = true;
    }
    // Botón Calcular
    if (mouseX > width/2 - 180 && mouseX < width/2 &&
      mouseY > 240 && mouseY < 290) {
      if (!rusaTieneM || !rusaTieneN) {
        rusaProceso = "Ingrese ambos números.";
      } else {
        long mAux = rusaM;
        long nAux = rusaN;
        long resultado = 0;
        rusaProceso = "Multiplicación Rusa:\n\n";
        while (mAux > 0) {
          if (mAux % 2 != 0) {
            rusaProceso = rusaProceso + mAux + " × " + nAux + " (impar, sumar)\n";
            resultado = resultado + nAux;
          } else {
            rusaProceso = rusaProceso + mAux + " × " + nAux + "\n";
          }
          mAux = mAux / 2;
          nAux = nAux * 2;
        }
        rusaProceso = rusaProceso + "\nResultado = " + resultado;
      }
      out.playNote(0, 0.18, 600);
    }
    // Botón Limpiar
    if (mouseX > width/2 + 10 && mouseX < width/2 + 190 &&
      mouseY > 240 && mouseY < 290) {
      rusaEscribiendoM = false;
      rusaEscribiendoN = false;
      rusaTieneM = false;
      rusaTieneN = false;
      rusaM = 0;
      rusaN = 0;
      rusaProceso = "";
      out.playNote(0, 0.18, 500);
    }
  }

  // Clicks en Clave de un Número (pantalla 8)
  if (pantalla == 8) {
    // Campo número
    if (mouseX > 250 && mouseX < 750 && mouseY > 170 && mouseY < 220) {
      claveEscribiendo = true;
    }
    // Botón Calcular
    if (mouseX > width/2 - 180 && mouseX < width/2 &&
      mouseY > 240 && mouseY < 290) {
      if (!claveTieneValor && !claveSignoNeg) {
        claveProceso = "Ingrese un número.";
      } else {
        long valor;
        if (claveSignoNeg) valor = -claveValorAbs;
        else valor = claveValorAbs;
        claveProceso = "Clave de un Número:\n\n";
        claveProceso = claveProceso + "Número: " + valor + "\n\n";
        if (valor < 0) {
          claveProceso = claveProceso + "Es negativo, clave = -1";
        } else {
          long n = valor;
          long factor = 2;
          long suma = 0;
          while (n > 0) {
            long dig = n % 10;
            claveProceso = claveProceso + dig + " × " + factor + " = " + (dig * factor) + "\n";
            suma = suma + dig * factor;
            factor = factor + 1;
            n = n / 10;
          }
          claveProceso = claveProceso + "\nSuma = " + suma + "\n";
          claveProceso = claveProceso + "Clave = " + (suma % 10);
        }
      }
      out.playNote(0, 0.18, 600);
    }
    // Botón Limpiar
    if (mouseX > width/2 + 10 && mouseX < width/2 + 190 &&
      mouseY > 240 && mouseY < 290) {
      claveEscribiendo = false;
      claveSignoNeg = false;
      claveTieneValor = false;
      claveValorAbs = 0;
      claveProceso = "";
      out.playNote(0, 0.18, 500);
    }
  }

  // Clicks en Funciones Trigonométricas (pantalla 9)
  if (pantalla == 9) {
    // Selector de funciones (6 botones)
    int fX = 100;
    int fY = 180;
    int fW = 120;
    int fH = 50;
    int f = 0;
    while (f < 6) {
      int fx = fX + (f % 3) * 140;
      int fy = fY + (f / 3) * 70;
      if (mouseX > fx && mouseX < fx + fW &&
        mouseY > fy && mouseY < fy + fH) {
        taylorFuncion = f + 1;
        out.playNote(0, 0.1, 500);
      }
      f = f + 1;
    }
    // Campo ángulo
    if (mouseX > 100 && mouseX < 550 && mouseY > 350 && mouseY < 410) {
      tAngEscribiendo = true;
      tNEscribiendo = false;
    }
    // Campo N
    if (mouseX > 100 && mouseX < 550 && mouseY > 440 && mouseY < 500) {
      tAngEscribiendo = false;
      tNEscribiendo = true;
    }
    // Botón Calcular
    if (mouseX > 100 && mouseX < 300 &&
      mouseY > 620 && mouseY < 680) {
      if (!tAngTieneValor && !tAngSignoNeg) {
        tResultado = "Ingrese el ángulo.";
      } else if (!tNTieneValor || tN <= 0) {
        tResultado = "Ingrese N > 0.";
      } else {
        double grados;
        if (tAngSignoNeg) grados = -1.0 * tAnguloAbs;
        else grados = tAnguloAbs * 1.0;
        double x = grados * tPi / 180.0;

        // Calcular sin y cos con Taylor
        double seno = 0.0;
        double coseno = 0.0;
        int nS = 0;
        while (nS < tN) {
          int expS = 2 * nS + 1;
          double potS = 1.0;
          int k = 1;
          while (k <= expS) {
            potS = potS * x;
            k = k + 1;
          }
          double factS = 1.0;
          k = 1;
          while (k <= expS) {
            factS = factS * k;
            k = k + 1;
          }
          if (nS % 2 == 0) seno = seno + potS / factS;
          else seno = seno - potS / factS;
          nS = nS + 1;
        }

        int nC = 0;
        while (nC < tN) {
          int expC = 2 * nC;
          double potC = 1.0;
          int k = 1;
          while (k <= expC) {
            potC = potC * x;
            k = k + 1;
          }
          double factC = 1.0;
          k = 1;
          while (k <= expC) {
            factC = factC * k;
            k = k + 1;
          }
          if (nC % 2 == 0) coseno = coseno + potC / factC;
          else coseno = coseno - potC / factC;
          nC = nC + 1;
        }

        tResultado = "";
        if (taylorFuncion == 1) {
          tResultado = "sin(" + grados + "°) ≈ " + seno;
        } else if (taylorFuncion == 2) {
          tResultado = "cos(" + grados + "°) ≈ " + coseno;
        } else if (taylorFuncion == 3) {
          double cosAbs = coseno;
          if (cosAbs < 0) cosAbs = -cosAbs;
          if (cosAbs < tEPS) {
            tResultado = "tan indefinida (cos ≈ 0)";
          } else {
            tResultado = "tan(" + grados + "°) ≈ " + (seno / coseno);
          }
        } else if (taylorFuncion == 4) {
          double cosAbs = coseno;
          if (cosAbs < 0) cosAbs = -cosAbs;
          if (cosAbs < tEPS) {
            tResultado = "sec indefinida (cos ≈ 0)";
          } else {
            tResultado = "sec(" + grados + "°) ≈ " + (1.0 / coseno);
          }
        } else if (taylorFuncion == 5) {
          double sinAbs = seno;
          if (sinAbs < 0) sinAbs = -sinAbs;
          if (sinAbs < tEPS) {
            tResultado = "csc indefinida (sin ≈ 0)";
          } else {
            tResultado = "csc(" + grados + "°) ≈ " + (1.0 / seno);
          }
        } else if (taylorFuncion == 6) {
          double sinAbs = seno;
          if (sinAbs < 0) sinAbs = -sinAbs;
          if (sinAbs < tEPS) {
            tResultado = "cot indefinida (sin ≈ 0)";
          } else {
            tResultado = "cot(" + grados + "°) ≈ " + (coseno / seno);
          }
        }
      }
      out.playNote(0, 0.18, 600);
    }
    // Botón Limpiar
    if (mouseX > 320 && mouseX < 520 &&
      mouseY > 620 && mouseY < 680) {
      tAngEscribiendo = false;
      tNEscribiendo = false;
      tAngSignoNeg = false;
      tAngTieneValor = false;
      tAnguloAbs = 0;
      tNTieneValor = false;
      tN = 0;
      tResultado = "";
      out.playNote(0, 0.18, 500);
    }
  }

  // Clicks en Menú Procesos Matemáticos (pantalla 10)
  if (pantalla == 10) {
    int procBtnW = 320;
    int procBtnH = 80;
    int espaciadoH = 220;

    // Botón Multiplicación Rusa (izquierda arriba)
    int procBtn1X = width/2 - espaciadoH;
    int procBtn1Y = height/2 - 30;
    if (mouseX > procBtn1X - procBtnW/2 && mouseX < procBtn1X + procBtnW/2 &&
      mouseY > procBtn1Y - procBtnH/2 && mouseY < procBtn1Y + procBtnH/2) {
      pantalla = 7;
      coloresAzules = true;
      rusaEscribiendoM = false;
      rusaEscribiendoN = false;
      rusaTieneM = false;
      rusaTieneN = false;
      rusaM = 0;
      rusaN = 0;
      rusaProceso = "";
      out.playNote(0, 0.18, 600);
    }

    // Botón Funciones Trigonométricas (derecha arriba)
    int procBtn2X = width/2 + espaciadoH;
    int procBtn2Y = height/2 - 30;
    if (mouseX > procBtn2X - procBtnW/2 && mouseX < procBtn2X + procBtnW/2 &&
      mouseY > procBtn2Y - procBtnH/2 && mouseY < procBtn2Y + procBtnH/2) {
      pantalla = 9;
      coloresAzules = true;
      taylorFuncion = 1;
      tAngEscribiendo = false;
      tNEscribiendo = false;
      tAngSignoNeg = false;
      tAngTieneValor = false;
      tAnguloAbs = 0;
      tNTieneValor = false;
      tN = 0;
      tResultado = "";
      out.playNote(0, 0.18, 700);
    }

    // Botón Clave de un Número (centro abajo)
    int procBtn3X = width/2;
    int procBtn3Y = height/2 + 90;
    if (mouseX > procBtn3X - procBtnW/2 && mouseX < procBtn3X + procBtnW/2 &&
      mouseY > procBtn3Y - procBtnH/2 && mouseY < procBtn3Y + procBtnH/2) {
      pantalla = 8;
      coloresAzules = true;
      claveEscribiendo = false;
      claveSignoNeg = false;
      claveTieneValor = false;
      claveValorAbs = 0;
      claveProceso = "";
      out.playNote(0, 0.18, 650);
    }
  }

  // Detectar clic en un pétalo (La Margarita - pantalla 11)
  if (pantalla == 11) {
    if (juegoTerminado) {
      return;
    }

    int posElegida = 0;
    int pos = 1;
    while (pos <= 9) {

      // mismo orden del anillo para calcular posición
      int indice = 0;
      if (pos == 1) {
        indice = 0;
      } else {
        if (pos == 2) {
          indice = 1;
        } else {
          if (pos == 3) {
            indice = 2;
          } else {
            if (pos == 5) {
              indice = 3;
            } else {
              if (pos == 7) {
                indice = 4;
              } else {
                if (pos == 9) {
                  indice = 5;
                } else {
                  if (pos == 8) {
                    indice = 6;
                  } else {
                    if (pos == 6) {
                      indice = 7;
                    } else {
                      if (pos == 4) {
                        indice = 8;
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }

      float ang = -HALF_PI + indice * (TWO_PI / 9.0);
      float petalClickX = cx + cos(ang) * radio;
      float petalClickY = cy + sin(ang) * radio;
      float d = dist(mouseX, mouseY, petalClickX, petalClickY);
      if (d <= radioPetalo / 2.0) {
        posElegida = pos;
      }
      pos = pos + 1;
    }

    if (posElegida == 0) {
      return; // no se tocó ningún pétalo
    }

    // Verificar que haya ficha en esa posición
    int valor = 0;
    if (posElegida == 1) {
      valor = p1;
    } else {
      if (posElegida == 2) {
        valor = p2;
      } else {
        if (posElegida == 3) {
          valor = p3;
        } else {
          if (posElegida == 4) {
            valor = p4;
          } else {
            if (posElegida == 5) {
              valor = p5;
            } else {
              if (posElegida == 6) {
                valor = p6;
              } else {
                if (posElegida == 7) {
                  valor = p7;
                } else {
                  if (posElegida == 8) {
                    valor = p8;
                  } else {
                    if (posElegida == 9) {
                      valor = p9;
                    }
                  }
                }
              }
            }
          }
        }
      }
    }

    if (valor == 0) {
      mensajeError = true;   // no se puede seleccionar un pétalo vacío
      return;
    }

    mensajeError = false;

    // Gestión de selecciones
    if (sel1 == 0) {
      sel1 = posElegida;
      sel2 = 0;
    } else {
      if (sel1 == posElegida) {
        // si hace clic de nuevo en la misma, deselecciona
        sel1 = 0;
        sel2 = 0;
      } else {
        if (sel2 == 0) {
          // Comprobar si es vecino de sel1 según el anillo 1-2-3-5-7-9-8-6-4-1
          boolean vecinos = false;

          if (sel1 == 1) {
            if (posElegida == 2 || posElegida == 4) {
              vecinos = true;
            }
          } else {
            if (sel1 == 2) {
              if (posElegida == 1 || posElegida == 3) {
                vecinos = true;
              }
            } else {
              if (sel1 == 3) {
                if (posElegida == 2 || posElegida == 5) {
                  vecinos = true;
                }
              } else {
                if (sel1 == 4) {
                  if (posElegida == 1 || posElegida == 6) {
                    vecinos = true;
                  }
                } else {
                  if (sel1 == 5) {
                    if (posElegida == 3 || posElegida == 7) {
                      vecinos = true;
                    }
                  } else {
                    if (sel1 == 6) {
                      if (posElegida == 4 || posElegida == 8) {
                        vecinos = true;
                      }
                    } else {
                      if (sel1 == 7) {
                        if (posElegida == 5 || posElegida == 9) {
                          vecinos = true;
                        }
                      } else {
                        if (sel1 == 8) {
                          if (posElegida == 6 || posElegida == 9) {
                            vecinos = true;
                          }
                        } else {
                          if (sel1 == 9) {
                            if (posElegida == 7 || posElegida == 8) {
                              vecinos = true;
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }

          if (vecinos) {
            sel2 = posElegida;
          } else {
            mensajeError = true;  // No son contiguos
          }
        } else {
          // Ya hay dos seleccionadas, empezar de nuevo con la nueva posición
          sel1 = posElegida;
          sel2 = 0;
        }
      }
    }
  }
}

//=====================================================================
// TECLADO
//=====================================================================
void keyPressed() {
  // Punto y Fama - entrada simple
  if (pantalla == 3 && !ganoFama) {
    if (key >= '0' && key <= '9') {
      int digito = key - '0';

      // Agregar digito en la primera posicion vacia (permitir repetidos)
      if (intento1 == -1) {
        intento1 = digito;
      } else if (intento2 == -1) {
        intento2 = digito;
      } else if (intento3 == -1) {
        intento3 = digito;
      } else if (intento4 == -1) {
        intento4 = digito;
      }
    }

    // Enter - procesar el intento
    if (keyCode == ENTER || keyCode == RETURN) {
      // Verificar que hay 4 digitos
      int contadorDigitos = 0;
      if (intento1 != -1) contadorDigitos = contadorDigitos + 1;
      if (intento2 != -1) contadorDigitos = contadorDigitos + 1;
      if (intento3 != -1) contadorDigitos = contadorDigitos + 1;
      if (intento4 != -1) contadorDigitos = contadorDigitos + 1;

      if (contadorDigitos == 4) {
        // Calcular famas y puntos correctamente con dígitos repetidos
        famas = 0;
        puntos = 0;

        // Marcar qué posiciones del código ya fueron usadas
        boolean usado1 = false;
        boolean usado2 = false;
        boolean usado3 = false;
        boolean usado4 = false;

        // Primero contar famas (posición exacta)
        if (intento1 == codigo1) {
          famas = famas + 1;
          usado1 = true;
        }
        if (intento2 == codigo2) {
          famas = famas + 1;
          usado2 = true;
        }
        if (intento3 == codigo3) {
          famas = famas + 1;
          usado3 = true;
        }
        if (intento4 == codigo4) {
          famas = famas + 1;
          usado4 = true;
        }

        // Luego contar puntos (dígito correcto pero posición incorrecta)
        // Solo si no fue fama y la posición del código no fue usada
        if (intento1 != codigo1) {
          if (intento1 == codigo2 && !usado2) {
            puntos = puntos + 1;
            usado2 = true;
          } else if (intento1 == codigo3 && !usado3) {
            puntos = puntos + 1;
            usado3 = true;
          } else if (intento1 == codigo4 && !usado4) {
            puntos = puntos + 1;
            usado4 = true;
          }
        }

        if (intento2 != codigo2) {
          if (intento2 == codigo1 && !usado1) {
            puntos = puntos + 1;
            usado1 = true;
          } else if (intento2 == codigo3 && !usado3) {
            puntos = puntos + 1;
            usado3 = true;
          } else if (intento2 == codigo4 && !usado4) {
            puntos = puntos + 1;
            usado4 = true;
          }
        }

        if (intento3 != codigo3) {
          if (intento3 == codigo1 && !usado1) {
            puntos = puntos + 1;
            usado1 = true;
          } else if (intento3 == codigo2 && !usado2) {
            puntos = puntos + 1;
            usado2 = true;
          } else if (intento3 == codigo4 && !usado4) {
            puntos = puntos + 1;
            usado4 = true;
          }
        }

        if (intento4 != codigo4) {
          if (intento4 == codigo1 && !usado1) {
            puntos = puntos + 1;
            usado1 = true;
          } else if (intento4 == codigo2 && !usado2) {
            puntos = puntos + 1;
            usado2 = true;
          } else if (intento4 == codigo3 && !usado3) {
            puntos = puntos + 1;
            usado3 = true;
          }
        }

        intentos = intentos + 1;

        if (famas == 4) {
          ganoFama = true;
          out.playNote(0, 0.2, 700);
        } else {
          out.playNote(0, 0.1, 400);
        }
      }
    }

    // Backspace simple - borra el ultimo digito no vacio
    if (keyCode == BACKSPACE) {
      if (intento4 != -1) {
        intento4 = -1;
      } else if (intento3 != -1) {
        intento3 = -1;
      } else if (intento2 != -1) {
        intento2 = -1;
      } else if (intento1 != -1) {
        intento1 = -1;
      }
    }
  }
  // Conversor Hex - entrada simple
  if (pantalla == 5) {
    int valorHex = -1;
    if (key >= '0' && key <= '9') {
      valorHex = key - '0';
    } else if (key >= 'A' && key <= 'F') {
      valorHex = 10 + (key - 'A');
    } else if (key >= 'a' && key <= 'f') {
      valorHex = 10 + (key - 'a');
    }

    // Agregar digito en la primera posicion vacia
    if (valorHex != -1 && hexContador < 4) {
      if (hexDigito1 == -1) {
        hexDigito1 = valorHex;
        hexContador = 1;
      } else if (hexDigito2 == -1) {
        hexDigito2 = valorHex;
        hexContador = 2;
      } else if (hexDigito3 == -1) {
        hexDigito3 = valorHex;
        hexContador = 3;
      } else if (hexDigito4 == -1) {
        hexDigito4 = valorHex;
        hexContador = 4;
      }

      // Calcular decimal con ciclo for
      hexDecimal = 0;
      if (hexDigito1 != -1) {
        int pot1 = 1;
        for (int i = 0; i < hexContador - 1; i++) {
          pot1 = pot1 * 16;
        }
        hexDecimal = hexDecimal + hexDigito1 * pot1;
      }
      if (hexDigito2 != -1) {
        int pot2 = 1;
        for (int i = 0; i < hexContador - 2; i++) {
          pot2 = pot2 * 16;
        }
        hexDecimal = hexDecimal + hexDigito2 * pot2;
      }
      if (hexDigito3 != -1) {
        int pot3 = 1;
        for (int i = 0; i < hexContador - 3; i++) {
          pot3 = pot3 * 16;
        }
        hexDecimal = hexDecimal + hexDigito3 * pot3;
      }
      if (hexDigito4 != -1) {
        hexDecimal = hexDecimal + hexDigito4;
      }
    }

    // Backspace simple - borra el ultimo digito no vacio
    if (keyCode == BACKSPACE && hexContador > 0) {
      if (hexDigito4 != -1) {
        hexDigito4 = -1;
        hexContador = 3;
      } else if (hexDigito3 != -1) {
        hexDigito3 = -1;
        hexContador = 2;
      } else if (hexDigito2 != -1) {
        hexDigito2 = -1;
        hexContador = 1;
      } else if (hexDigito1 != -1) {
        hexDigito1 = -1;
        hexContador = 0;
      }

      // Recalcular decimal
      hexDecimal = 0;
      if (hexDigito1 != -1) {
        int pot1 = 1;
        for (int i = 0; i < hexContador - 1; i++) {
          pot1 = pot1 * 16;
        }
        hexDecimal = hexDecimal + hexDigito1 * pot1;
      }
      if (hexDigito2 != -1) {
        int pot2 = 1;
        for (int i = 0; i < hexContador - 2; i++) {
          pot2 = pot2 * 16;
        }
        hexDecimal = hexDecimal + hexDigito2 * pot2;
      }
      if (hexDigito3 != -1) {
        int pot3 = 1;
        for (int i = 0; i < hexContador - 3; i++) {
          pot3 = pot3 * 16;
        }
        hexDecimal = hexDecimal + hexDigito3 * pot3;
      }
    }
  }

  // Multiplicación Rusa (pantalla 7)
  if (pantalla == 7) {
    if (key == BACKSPACE) {
      if (rusaEscribiendoM && rusaTieneM) {
        if (rusaM >= 10) rusaM = rusaM / 10;
        else {
          rusaM = 0;
          rusaTieneM = false;
        }
      }
      if (rusaEscribiendoN && rusaTieneN) {
        if (rusaN >= 10) rusaN = rusaN / 10;
        else {
          rusaN = 0;
          rusaTieneN = false;
        }
      }
    } else if (key >= '0' && key <= '9') {
      int dig = key - '0';
      if (rusaEscribiendoM) {
        if (!rusaTieneM) {
          rusaM = dig;
          rusaTieneM = true;
        } else {
          rusaM = rusaM * 10 + dig;
        }
      }
      if (rusaEscribiendoN) {
        if (!rusaTieneN) {
          rusaN = dig;
          rusaTieneN = true;
        } else {
          rusaN = rusaN * 10 + dig;
        }
      }
    }
  }

  // Clave de un Número (pantalla 8)
  if (pantalla == 8 && claveEscribiendo) {
    if (key == BACKSPACE) {
      if (claveTieneValor) {
        if (claveValorAbs >= 10) {
          claveValorAbs = claveValorAbs / 10;
        } else {
          claveValorAbs = 0;
          claveTieneValor = false;
        }
      } else if (claveSignoNeg) {
        claveSignoNeg = false;
      }
    } else if (key == '-') {
      if (!claveTieneValor && !claveSignoNeg) {
        claveSignoNeg = true;
      }
    } else if (key >= '0' && key <= '9') {
      int dig = key - '0';
      claveValorAbs = claveValorAbs * 10 + dig;
      claveTieneValor = true;
    }
  }

  // Funciones Trigonométricas (pantalla 9)
  if (pantalla == 9) {
    if (key == BACKSPACE) {
      if (tAngEscribiendo) {
        if (tAngTieneValor) {
          if (tAnguloAbs >= 10) {
            tAnguloAbs = tAnguloAbs / 10;
          } else {
            tAnguloAbs = 0;
            tAngTieneValor = false;
          }
        } else if (tAngSignoNeg) {
          tAngSignoNeg = false;
        }
      }
      if (tNEscribiendo && tNTieneValor) {
        if (tN >= 10) {
          tN = tN / 10;
        } else {
          tN = 0;
          tNTieneValor = false;
        }
      }
    } else if (key == '-') {
      if (tAngEscribiendo && !tAngTieneValor && !tAngSignoNeg) {
        tAngSignoNeg = true;
      }
    } else if (key >= '0' && key <= '9') {
      int dig = key - '0';
      if (tAngEscribiendo) {
        tAnguloAbs = tAnguloAbs * 10 + dig;
        tAngTieneValor = true;
      }
      if (tNEscribiendo) {
        tN = tN * 10 + dig;
        tNTieneValor = true;
      }
    }
  }

  // Confirmar jugada y pasar de turno (La Margarita - pantalla 11)
  if (pantalla == 11) {
    if (keyCode == ENTER) {
      if (juegoTerminado) {
        // reiniciar todo
        p1 = 1;
        p2 = 1;
        p3 = 1;
        p4 = 1;
        p5 = 1;
        p6 = 1;
        p7 = 1;
        p8 = 1;
        p9 = 1;
        fichasRestantes = 9;
        turno = 1;
        ganadorMargarita = 0;
        sel1 = 0;
        sel2 = 0;
        juegoTerminado = false;
        mensajeError = false;
        return;
      }

      // Si no hay selección, no se puede jugar
      if (sel1 == 0) {
        mensajeError = true;
        return;
      }

      // Quitar la primera ficha
      if (sel1 == 1) {
        if (p1 == 1) {
          p1 = 0;
          fichasRestantes = fichasRestantes - 1;
        }
      } else {
        if (sel1 == 2) {
          if (p2 == 1) {
            p2 = 0;
            fichasRestantes = fichasRestantes - 1;
          }
        } else {
          if (sel1 == 3) {
            if (p3 == 1) {
              p3 = 0;
              fichasRestantes = fichasRestantes - 1;
            }
          } else {
            if (sel1 == 4) {
              if (p4 == 1) {
                p4 = 0;
                fichasRestantes = fichasRestantes - 1;
              }
            } else {
              if (sel1 == 5) {
                if (p5 == 1) {
                  p5 = 0;
                  fichasRestantes = fichasRestantes - 1;
                }
              } else {
                if (sel1 == 6) {
                  if (p6 == 1) {
                    p6 = 0;
                    fichasRestantes = fichasRestantes - 1;
                  }
                } else {
                  if (sel1 == 7) {
                    if (p7 == 1) {
                      p7 = 0;
                      fichasRestantes = fichasRestantes - 1;
                    }
                  } else {
                    if (sel1 == 8) {
                      if (p8 == 1) {
                        p8 = 0;
                        fichasRestantes = fichasRestantes - 1;
                      }
                    } else {
                      if (sel1 == 9) {
                        if (p9 == 1) {
                          p9 = 0;
                          fichasRestantes = fichasRestantes - 1;
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }

      // Quitar la segunda ficha (si existe)
      if (sel2 != 0) {
        if (sel2 == 1) {
          if (p1 == 1) {
            p1 = 0;
            fichasRestantes = fichasRestantes - 1;
          }
        } else {
          if (sel2 == 2) {
            if (p2 == 1) {
              p2 = 0;
              fichasRestantes = fichasRestantes - 1;
            }
          } else {
            if (sel2 == 3) {
              if (p3 == 1) {
                p3 = 0;
                fichasRestantes = fichasRestantes - 1;
              }
            } else {
              if (sel2 == 4) {
                if (p4 == 1) {
                  p4 = 0;
                  fichasRestantes = fichasRestantes - 1;
                }
              } else {
                if (sel2 == 5) {
                  if (p5 == 1) {
                    p5 = 0;
                    fichasRestantes = fichasRestantes - 1;
                  }
                } else {
                  if (sel2 == 6) {
                    if (p6 == 1) {
                      p6 = 0;
                      fichasRestantes = fichasRestantes - 1;
                    }
                  } else {
                    if (sel2 == 7) {
                      if (p7 == 1) {
                        p7 = 0;
                        fichasRestantes = fichasRestantes - 1;
                      }
                    } else {
                      if (sel2 == 8) {
                        if (p8 == 1) {
                          p8 = 0;
                          fichasRestantes = fichasRestantes - 1;
                        }
                      } else {
                        if (sel2 == 9) {
                          if (p9 == 1) {
                            p9 = 0;
                            fichasRestantes = fichasRestantes - 1;
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }

      // limpiar selección
      sel1 = 0;
      sel2 = 0;

      // Verificar si ya no quedan fichas
      if (fichasRestantes == 0) {
        juegoTerminado = true;
        ganadorMargarita = turno;
      } else {
        // Cambiar de turno
        if (turno == 1) {
          turno = 2;
        } else {
          turno = 1;
        }
      }
    }
  }
}
