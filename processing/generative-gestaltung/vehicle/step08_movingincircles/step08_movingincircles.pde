/*
* the Vehicle
 * step 08 - moving in circles.
 *
 */

Vehicle mVehicle;
float mDirection = 1;

void setup() {
  size(640, 480);
  smooth();
  noFill();
  ellipseMode(CENTER);

  mVehicle = new Vehicle();
  mVehicle.position.set(width/2, height/2, 0);
  mVehicle.velocity.set(1, 3, 0);
  mVehicle.acceleration.set(1.0f, 0.0f, 0.0f);
  mVehicle.radius = 15;
  mVehicle.maxspeed = 1.5f;
  mVehicle.maxacceleration = 0.1f;
}

void draw() {
  background(255);

  /* set the acc by calc a vector perpendicular to current velocity */
  PVector mNewAcc = mVehicle.velocity.cross(new PVector(0, 0, mDirection));
  mVehicle.acceleration.set(mNewAcc);

  mVehicle.loop();
  mVehicle.draw();
  teleport(mVehicle);
}

void mousePressed() {
  mVehicle.maxspeed = random(1.0f, 3.0f);
  mVehicle.maxacceleration = random(0.05f, 0.3f);
  mDirection *= -1;
}

void teleport(Vehicle pVehicle) {
  if (pVehicle.position.x > width) {
    pVehicle.position.x = 0;
  }
  if (pVehicle.position.x < 0) {
    pVehicle.position.x = width;
  }
  if (pVehicle.position.y > height) {
    pVehicle.position.y = 0;
  }
  if (pVehicle.position.y < 0) {
    pVehicle.position.y = height;
  }
}

class Vehicle {

  PVector position = new PVector();
  PVector velocity = new PVector();
  PVector acceleration = new PVector();
  float maxspeed = 0;
  float maxacceleration = 0;
  float radius = 0;

  void loop() {
    float myAccelerationSpeed = acceleration.mag();
    if (myAccelerationSpeed > maxacceleration) {
      acceleration.normalize();
      acceleration.mult(maxacceleration);
    }
    velocity.add(acceleration);

    float mySpeed = velocity.mag();
    if (mySpeed > maxspeed) {
      velocity.normalize();
      velocity.mult(maxspeed);
    }
    position.add(velocity);
  }

  void draw() {
    stroke(0, 0, 0);
    ellipse(position.x, position.y, radius, radius);
    stroke(255, 0, 0);
    line(position.x,
    position.y,
    position.x + velocity.x,
    position.y + velocity.y);
    stroke(0, 255, 0);
    line(position.x + velocity.x,
    position.y + velocity.y,
    position.x + velocity.x + acceleration.x,
    position.y + velocity.y + acceleration.y);
  }
}

