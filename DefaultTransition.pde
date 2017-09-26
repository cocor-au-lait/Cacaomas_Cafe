
public class DefaultTransition extends Transition {
    private int deg;
    private float ratio;
    private static final int MIN_TIME = 1500; //3秒
    private static final float FADE_TIME = 1000.0f;

    public DefaultTransition() {
    }

    public DefaultTransition(int step) {
        super.step = step;
    }

    public void firstDraw() {
        ratio = step_elapsed_time / FADE_TIME;
        if(ratio > 1.0f) {
            stepUp();
        }
        commonDraw();
    }

    public void secondDraw() {
        ratio = 1.0f;
        if(step_elapsed_time > MIN_TIME) {
            stepUp();
        }
        commonDraw();
    }

    public void thirdDraw() {
        stepUp();
        commonDraw();
    }

    public void lastDraw() {
        ratio = 1.0f - (step_elapsed_time / FADE_TIME);
        if(ratio < 0.0f) {
            stepUp();
        }
        commonDraw();
    }

    public void commonDraw() {
        noStroke();
        rectMode(CORNER);
        int alpha = (int)map(ratio, 0.0f, 1.0f, 0.0f, 255.0f);
        fill(255, alpha);
        rect(0, 0, width, height);
        pushMatrix();
        translate(width / 2, height / 2);
        rotate(radians(deg));
        rectMode(CENTER);
        fill(0, alpha);
        rect(0, 0, 200, 200);
        popMatrix();
        deg = deg < 360 ? deg + 1 : 0;
        String dot = new String();
        switch((int)(elapsed_time / 500) % 3) {
        case 0:
            dot = new String(".");
            break;
        case 1:
            dot = new String("..");
            break;
        case 2:
            dot = new String("...");
            break;
        }
        textSize(30);
        text("now loading" + dot, width / 2, (height / 5 ) * 4);
    }
}