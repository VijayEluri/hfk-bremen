import processing.opengl.*;

float mRotation;

float[][][] mField;

void setup() {
  size(640, 480, OPENGL);
  hint(ENABLE_DEPTH_SORT);

  mField = new float[20][20][20];
}

void draw() {

  /* populate field with perlin noise */
  for (int x = 0; x < mField.length; x++) {
    for (int y = 0; y < mField[x].length; y++) {
      for (int z = 0; z < mField[x][y].length; z++) {
        PVector p = new PVector(x, y, z);
        p.div(new PVector(mField.length, mField[x].length, mField[x][y].length));
        mField[x][y][z] = evaluateFunction(p);
      }
    }
  }

  /* calculate triangles */
  Vector<PVector> mTriangles = new Vector<PVector>();
  MarchingCubes.triangles(mTriangles, mField, 0.0f);

  /* draw */
  background(164);
  pushMatrix();

  /* wiggle */
  translate(width / 2, height / 2);
  mRotation += 1.0f / frameRate;
  rotateX(abs(sin(mRotation * 0.25f)) * PI * 0.2f);
  rotateZ(cos(mRotation * 0.17f) * PI * 0.2f);

  /* draw triangles */
  noFill();
  fill(255, 32);
  stroke(255, 48);
  beginShape(TRIANGLES);
  PVector mScale = new PVector(150, 150, 150);
  for (int i = 0; i < mTriangles.size(); i++) {
    PVector p = mTriangles.get(i);
    /* scale triangles to make them visible. triangle values are returned normalized ( 0 - 1 ) */
    p.mult(mScale);
    p.mult(2);
    p.sub(mScale);
    vertex(p.x, p.y, p.z);
  }
  endShape();

  popMatrix();
}

float evaluateFunction(PVector p) {
  float r = 0.3f;
  PVector c = new PVector(mouseX / (float)width, mouseY / (float)height, 0.5f);
  float x = p.x - c.x;
  float y = p.y - c.y;
  float z = p.z - c.z;
  return sqrt(x * x + y * y + z * z) - r;
  /* you can also use weird functions like the following: */
  //         return pow(sin(x * 10.0f), 2) * cos(y * y * 20) * 0.5f + sin(z * z * z * 4) * 0.5f;
}

