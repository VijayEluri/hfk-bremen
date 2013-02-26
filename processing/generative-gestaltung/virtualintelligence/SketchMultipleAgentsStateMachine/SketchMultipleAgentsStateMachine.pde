import processing.opengl.*;

import teilchen.Physics;
import teilchen.constraint.Teleporter;
import teilchen.force.ViscousDrag;
import teilchen.BehaviorParticle;
import teilchen.behavior.Arrival;
import teilchen.behavior.VelocityMotor;
import teilchen.behavior.Wander;
import mathematik.Vector3f;


Physics mPhysics;

Vector<Agent> mAgents;

void setup() {
  size(640, 480, OPENGL);
  noFill();
  smooth();

  /* physics */
  mPhysics = new Physics();

  /* create a viscous force that slows down all motion */
  ViscousDrag myDrag = new ViscousDrag();
  myDrag.coefficient = 0.05f;
  mPhysics.add(myDrag);

  /* teleport particles from one edge of the screen to the other */
  Teleporter mTeleporter = new Teleporter();
  mTeleporter.min().set(0, 0);
  mTeleporter.max().set(width, height);
  mPhysics.add(mTeleporter);

  /* agents */
  mAgents = new Vector<Agent>();

  Agent mNeighbor = new WanderAndSeekAgent(this, mPhysics);
  mAgents.add(mNeighbor);
  for (int i = 0; i < 5; i++) {
    Agent mAgent = new FollowOtherAgent(this, mPhysics, mNeighbor);
    mAgents.add(mAgent);
    mNeighbor = mAgent;
  }
}

void draw() {
  /* calculate */
  mPhysics.step(1.0f / frameRate);
  for (int i = 0; i < mAgents.size(); i++) {
    mAgents.get(i).loop();
  }

  /* view */
  background(255);
  for (int i = 0; i < mAgents.size(); i++) {
    mAgents.get(i).draw();
  }
}

