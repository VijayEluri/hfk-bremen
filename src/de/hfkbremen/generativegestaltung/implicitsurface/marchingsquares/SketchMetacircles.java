

package de.hfkbremen.generativegestaltung.implicitsurface.marchingsquares;


import java.util.Vector;

import processing.core.PApplet;
import processing.core.PVector;


public class SketchMetacircles
        extends PApplet {

    private float mTheshold = 32.0f; // sometimes iso-value

    private int mResolutionScaleX;

    private int mResolutionScaleY;

    private int mGridX;

    private int mGridY;

    private float[][] mGrid;

    private Metacircle[] mBalls;

    private Vector<PVector> mLines;

    public void setup() {
        size(640, 480, OPENGL);
        smooth();

        mResolutionScaleX = 640;
        mResolutionScaleY = 480;
        mGridX = 64;
        mGridY = 48;
        mGrid = new float[mGridX][mGridY];

        mLines = new Vector<PVector>();

        /* spawn metaballs */
        mBalls = new Metacircle[10];
        for (int i = 0; i < mBalls.length; i++) {
            mBalls[i] = new Metacircle();
            mBalls[i].position.set(random(0, width), random(0, height), 0);
            mBalls[i].strength = random(5000, 50000);
        }
    }

    public void draw() {
        /* stick first ball to mouse */
        mBalls[0].position.x = mouseX;
        mBalls[0].position.y = mouseY;

        /* perform marching squares */
        updateGridValues();
        mLines.clear();
        MarchingSquares.lines(mLines, mGrid, mTheshold);

        /* draw */
        background(255);
        drawGrid();
        drawLines(mLines);
    }

    private void updateGridValues() {
        final float mScaleX = mResolutionScaleX / mGridX;
        final float mScaleY = mResolutionScaleX / mGridX;
        for (int x = 0; x < mGrid.length; x++) {
            for (int y = 0; y < mGrid[x].length; y++) {
                mGrid[x][y] = 0;
                for (int n = 0; n < mBalls.length; n++) {
                    /* scale grid postions to screen positions */
                    float mX = mScaleX * x;
                    float mY = mScaleY * y;
                    mGrid[x][y] += mBalls[n].strength(mX, mY);
                }
            }
        }
    }

    private void drawLines(Vector<PVector> myLines) {
        stroke(0, 175);
        pushMatrix();
        scale(mResolutionScaleX, mResolutionScaleY);
        beginShape(LINES);
        for (int i = 0; i < myLines.size(); i++) {
            vertex(myLines.get(i).x, myLines.get(i).y);
        }
        endShape();
        popMatrix();
    }

    private void drawGrid() {
        final float mScaleX = mResolutionScaleX / mGridX;
        final float mScaleY = mResolutionScaleX / mGridX;
        stroke(0, 32);
        for (int y = 0; y < mGridX + 1; y++) {
            int Xs = (int)(y * mScaleX);
            line(Xs, 0, Xs, mResolutionScaleY);
        }

        for (int x = 0; x < mGridY + 1; x++) {
            int Ys = (int)(x * mScaleY);
            line(0, Ys, mResolutionScaleX, Ys);
        }
    }

    private class Metacircle {

        public PVector position = new PVector();

        public float strength = 30000;

        float strength(float x, float y) {
            float dx = position.x - x;
            float dy = position.y - y;
            float mDistanceSquared = dx * dx + dy * dy;
            if (mDistanceSquared == 0.0f) {
                return 0.0f;
            }
            return strength / mDistanceSquared;
        }
    }

    public static void main(String[] args) {
        PApplet.main(new String[] {SketchMetacircles.class.getName()});
    }
}
