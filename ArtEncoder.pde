import java.util.Arrays;

/**
 * Encodes a message into a cityscape by converting the characters into binary then building
 * skyscrapers with each word, made out of the encoded blocks.
 * https://github.com/jsaur92/city-encoder
 * @author jsaur92
 */

final String MESSAGE = "sample message";
final String THIS_FILEPATH = "ArtEncoder.pde";
final int BIT_COUNT = 16;
final int BITS_PER_ROW = 4;
final float STACK_SKEW_X = 1;  // base number of pixels the 3d effect for the stacks skews x by.
final float STACK_SKEW_Y = 1;  // base number of pixels the 3d effect for the stacks skews y by.
final color night1 = color(0);
final color night2 = color(0, 0, 102);
final String[] VARTYPES = {"int", "float", "char", "String", "String[]", "color"};
final String[] VARTYPES2 = {"final", "void"};
final String[] CONDITIONAL = {"if", "else", "while", "for"};

// Draw the image.
void setup() {
  size(1440, 2170);
  
  setGradient(0, 0, width*3, height*3, night1, night2);
  drawMoon();
  drawStars();
  
  translate(width, 0); scale(-1, 1);
  drawBinaryGroup(MESSAGE + " " + reverse(MESSAGE), 5, 0, 15, 13, 63, 24, 4);
  
  scale(-1, 1); translate(-width, 0);
  fill(255);
  drawCode();
  
  translate(width, 0); scale(-1,1); rotate(PI); translate(-width, -height);
  
  fill(6);
  rect(0, 0, width, 95);
  
  drawBinaryGroup(MESSAGE, 50, 60, 30, 30, 255, 24, 8);
  
  fill(255, 0, 0);
  
  int carCount = (int) random(8, 12);
  for (int i = 0; i < carCount; i++) {
    fill(random(30, 240), random(30, 240), random(30, 240));
    drawCar(width * (i+0.5)/(carCount) + random(-20, 20), random(20, 50), 30);
  }
  
  save("output.png");
}

// Draw a viual representation of 1 phrase in binary, made of BinaryStacks.
void drawBinaryGroup(String phrase, float x, float y, float size, float padding, int opacity, int stroke, int strokeWeight) {
  String[] parsed_phrase = phrase.split(" ");
  for (int i = 0; i < parsed_phrase.length; i++) {
    if (i < parsed_phrase.length - 1) parsed_phrase[i] += " ";
    drawBinaryStack(parsed_phrase[i], x + (size+padding)*i*BITS_PER_ROW, y, size, opacity, stroke, strokeWeight);
  }
}
 
// Draw a visual representation of 1 word in binary, made of BinaryBlocks.
void drawBinaryStack(String word, float x, float y, float size, int opacity, int stroke, int strokeWeight) {
  stroke(stroke);
  strokeWeight(strokeWeight);
  float skew_x = STACK_SKEW_X * size;
  float skew_y = STACK_SKEW_Y * size;
  
  float tip = y + size * (int)(word.length()*BIT_COUNT/BITS_PER_ROW);
  fill(60, opacity);
  quad(x, tip, x+skew_x, tip+skew_y, x+size*BITS_PER_ROW + skew_x, tip + skew_y, x+size*BITS_PER_ROW, tip);
  
  for (int i = 0; i < word.length(); i++) {
    drawBinaryBlock(word.charAt(i), x, y + size * (int)(i*BIT_COUNT/BITS_PER_ROW), size, opacity, skew_x, skew_y);
  }
  strokeWeight(4);
  stroke(0);
}

// Draw a visual representation of 1 character in binary, made of rectangles.
void drawBinaryBlock(char c, float x, float y, float size, int opacity, float skew_x, float skew_y) {
  boolean gray;
  for (int i = 0; i < BIT_COUNT; i++) {
    // Bitwise AND between the character's ASCII value and the bit we're on.
    if ((c & (int) pow(2, BIT_COUNT-i-1)) > 0) {
      fill(240, 250, 70, opacity);  // Fill yellow
      gray = false;
    }
    else {
      fill(60, opacity);  // Fill gray
      gray = true;
    }
    rect(x + size * (i%BITS_PER_ROW), y + size * (int)(i/BITS_PER_ROW), size, size);
    if (i % BITS_PER_ROW == BITS_PER_ROW-1) {
      if (gray) fill(40, opacity);
      quad(x + size * BITS_PER_ROW, y + size * (int)(i / BITS_PER_ROW), x + size * BITS_PER_ROW + skew_x, y + size * (int)(i / BITS_PER_ROW) + skew_y,
           x + size * BITS_PER_ROW + skew_x, y + size * (int)((i / BITS_PER_ROW)+1) + skew_y, x + size * BITS_PER_ROW, y + size * (int)((i / BITS_PER_ROW)+1));
    }
  }
}

// Reverse a string.
String reverse(String in) {
  String out = "";
  for (int i = in.length()-1; i >= 0; i--) {
    out = out + in.charAt(i);
  }
  return out;
}

// Draw a car.
void drawCar(float x, float y, float size) {
  float stroke = g.strokeColor;
  color fill = g.fillColor;
  ellipse(x, y, size, size/2);
  rect(x-size, y-size/2, size*2, size/2);
  stroke(0, 0);
  ellipse(x, y, size, size/2);
  fill(255);
  circle(x-size/2, y - size/2, size/2);
  circle(x+size/2, y - size/2, size/2);
  // set values back the way they were
  stroke(stroke);
  fill(fill);
}

// Modified from https://processing.org/examples/lineargradient.html
void setGradient(int x, int y, float w, float h, color c1, color c2 ) {
  noFill();
  for (int i = y; i <= y+h; i++) {
    float inter = map(i, y, y+h, 0, 1);
    color c = lerpColor(c1, c2, inter);
    stroke(c);
    line(x, i, x+w, i);
  }
}

// Draw the moon.
void drawMoon() {
  fill(180, 180);
  stroke(255, 180);
  strokeWeight(8);
  circle(1200, 300, 300);
  
  fill(90, 90);
  stroke(180, 90);
  circle(1150, 250, 100);
  circle(1290, 330, 70);
  circle(1175, 380, 80);
}

// Draw the stars.
void drawStars() {
  stroke(255, 90);
  for (int i = 0; i < 80; i++) {
    strokeWeight(random(4, 8));
    point(random(0, width), random(0, height/2));
  }
}

// Draw the source code to the screen.
void drawCode() {
  String[] lines = loadStrings(THIS_FILEPATH);
  textAlign(LEFT);
  textSize(12);
  textFont(loadFont("UbuntuMono-Regular-12.vlw"));
  boolean globalComment = false;
  for (int i = 0; i < lines.length; i++) {    // each line
    String[] parsedText = lines[i].split(" ");
    for (int j = 0; j < parsedText.length; j++) parsedText[j] += " ";
    int this_line_x = 0;
    boolean localComment = false;
    for (int j = 0; j < parsedText.length; j++) {    // each word
      String word = parsedText[j].replaceAll(" ","");
      if (word.contains("//")) localComment = true;
      if (word.contains("/*")) globalComment = true;
      if (localComment || globalComment) fill(114);
      else if (parsedText[j].contains("(")) {
        String[] newParsedText = new String [parsedText.length+1];
        for(int k = 0; k < parsedText.length; k++) {
          newParsedText[k] = parsedText[k];
        }
        int splitIndex = 1;
        if (parsedText[j].charAt(0) != '(') {
          splitIndex = parsedText[j].indexOf("(");
          fill(15, 111, 158);
        }
        else {
          fill(255, 255, 255);
        }
        newParsedText[j] = parsedText[j].substring(0, splitIndex);
        newParsedText[j+1] = parsedText[j].substring(splitIndex);
        for (int k = j+2; k < newParsedText.length; k++) newParsedText[k] = parsedText[k-1];
        parsedText = newParsedText;
      }
      else if (Arrays.asList(VARTYPES).contains(word)) fill(231, 103, 28);
      else if (Arrays.asList(VARTYPES2).contains(word)) fill(73, 164, 142);
      else if (Arrays.asList(CONDITIONAL).contains(word)) fill(113, 154, 22);
      else fill(255);
      text(parsedText[j], 30 + this_line_x, 30 + 14*i);
      this_line_x += textWidth(parsedText[j]);
      if (word.contains("*/")) globalComment = false;
    }
  }
}
