float _s = 1;
float _x = 1;
float _y = 1;

void setup() {
  size(1200, 800);
}

void draw() {
  background(255);
  function(_x, _y, _s);
  noLoop();
}




void function(float offset_x, float offset_y, float offset_s) {
  int maxiterations = 50 * (1 + int((log(offset_s) / log(10))));

  float w = 3;
  float h = (w * height) / width;

  float xmin = -2 + offset_x;
  float ymin = -1 + offset_y;

  float xmax = xmin + w;
  float ymax = ymin + h;

  float dx = (xmax - xmin) / (width * offset_s);
  float dy = (ymax - ymin) / (height * offset_s);

  loadPixels();

  float y = ymin;
  for (int j = 0; j < height; j++) {
    float x = xmin;
    for (int i = 0; i < width; i++) {
      float a = x;
      float b = y;
      int n = 0;
      float max = 4.0;
      float absOld = 0.0;
      float convergeNumber = maxiterations;
      while (n < maxiterations) {
        float aa = a * a;
        float bb = b * b;
        float abs = sqrt(aa + bb);
        if (abs > max) { 
          float diffToLast = (float) (abs - absOld);
          float diffToMax  = (float) (max - absOld);
          convergeNumber = n + diffToMax/diffToLast;
          break;  // Bail
        }
        float twoab = 2.0 * a * b;
        a = aa - bb + x;
        b = twoab + y;
        n++;
        absOld = abs;
      }
      if (n == maxiterations) {
        pixels[i+j*width] = color(0);
      } else {
        float norm = map(convergeNumber, 0, maxiterations, 0, 1);
        pixels[i+j*width] = color(map(sqrt(norm), 0, 1, 0, 255));
      }
      x += dx;
    }
    y += dy;
  }
  updatePixels();
}

void keyPressed() {
  if (key == '-') {
    _s -= _s * 0.5;
    if (_s<1) {
      _s = 1;
    }
  } else if (key == '=') {
    _s += _s * 0.5;
  }
  else if (keyCode == RIGHT) {
    _x += 1/_s / 5;
  }
  else if (keyCode == LEFT) {
    _x -= 1/_s / 5;
  }
  else if (keyCode == UP) {
    _y -= 1/_s / 5;
  }
  else if (keyCode == DOWN) {
    _y += 1/_s / 5;
  }
  loop();
}
