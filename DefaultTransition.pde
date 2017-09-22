public class DefaultTransition extends Transition {
    private int deg;
    private float ratio;
    private static final int min_time = 3000; //3秒
    private statif final float fade_time = 1200.0f;

    public void firstDraw() {
        ratio = step_elapsed_time / fade_time;
        if(ratio > 1.0f) {
            stepUp();
        }
        commonDraw();
    }

    public void secondDraw() {
        ratio = 1.0f;
        if(thread.isAlive() && step_elapsed_time > min_time) {
            stepup();
        }
        commonDraw();
    }

    public void thirdDraw() {
        ratio = 1.0f - (step_elapsed_time / fade_time);
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
        deg = deg < 360 ? deg++ : 0;
        switch((int)(elapsed_time / 500) % 3) {
        case 0:
            String dot = new String(".");
            break;
        case 1:
            String dot = new String("..");
            break;
        case 2:
            String dot = new String("...");
            break;
        }
        textSize(30);
        text("now loading" + dot, width / 2, (height / 5 ) * 4);
    }
}
