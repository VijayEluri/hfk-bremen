package de.hfkbremen.generativegestaltung.physicallybasedmodeling;


import teilchen.Particle;
import teilchen.Physics;
import teilchen.force.Spring;
import processing.core.PApplet;
import teilchen.util.AntiOverlap;


/**
 * this sketch is exactly like Lesson06_Springs, except that it also shows how to remove overlaps.
 */
public class LessonX01_Overlap
        extends PApplet {

    private Physics mPhysics;

    private Particle mRoot;

    private static final float PARTICLE_RADIUS = 6;

    public void setup() {
        size(640, 480, OPENGL);
        smooth();
        frameRate(30);

        mPhysics = new Physics();
        mRoot = mPhysics.makeParticle(width / 2, height / 2, 0.0f);
        mRoot.mass(30);
    }

    public void draw() {
        if (mousePressed) {
            Particle mParticle = mPhysics.makeParticle(mouseX, mouseY, 0);
            Spring mSpring = mPhysics.makeSpring(mRoot, mParticle);
            float mRestlength = mSpring.restlength();
            mSpring.restlength(mRestlength * 1.5f);

            /* we define a radius for the particle so the particle has dimensions */
            mParticle.radius(PARTICLE_RADIUS);
        }

        /* move overlapping particles away from each other */
        AntiOverlap.remove(mPhysics.particles());

        /* update the particle system */
        final float mDeltaTime = 1.0f / frameRate;
        mPhysics.step(mDeltaTime);

        /* draw particles and connecting line */
        background(255);

        /* draw springs */
        noFill();
        stroke(255, 0, 127, 64);
        for (int i = 0; i < mPhysics.forces().size(); i++) {
            if (mPhysics.forces().get(i) instanceof Spring) {
                Spring mSSpring = (Spring)mPhysics.forces().get(i);
                line(mSSpring.a().position().x, mSSpring.a().position().y,
                     mSSpring.b().position().x, mSSpring.b().position().y);
            }
        }
        /* draw particles */
        fill(245);
        stroke(164);
        for (int i = 0; i < mPhysics.particles().size(); i++) {
            ellipse(mPhysics.particles().get(i).position().x,
                    mPhysics.particles().get(i).position().y,
                    PARTICLE_RADIUS * 2, PARTICLE_RADIUS * 2);
        }
    }

    public static void main(String[] args) {
        PApplet.main(new String[] {LessonX01_Overlap.class.getName()});
    }
}




