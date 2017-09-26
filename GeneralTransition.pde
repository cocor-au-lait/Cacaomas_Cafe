public class GeneralTransition extends Transition {
    private static final int MIN_TIME = 2000;
    private static final float FADE_TIME = 1000.0f;
    private static final float THIRD_FADE_TIME = 1000.0f;
    private String state_name;

    public GeneralTransition(String state_name) {
        this.state_name = state_name;
    }

    public void firstDraw() {
        float ratio = step_elapsed_time / FADE_TIME;
        commonDraw1(ratio);
        if(ratio > 1.0f) {
            stepUp();
        }
    }

    public void secondDraw() {
        commonDraw1(1.0f);
        if(step_elapsed_time > MIN_TIME) {
            stepUp((int)THIRD_FADE_TIME);
        }
    }

    public void thirdDraw() {
        float ratio = step_elapsed_time / THIRD_FADE_TIME;
        int rect_width = (int)map(ratio, 0.0f, 1.5f, 0.0f, width);
        commonDraw2(ratio, rect_width);
        if(ratio > 2.0f) {
            stepUp();
        }
    }

    public void lastDraw() {
        float ratio = 1.0f - (step_elapsed_time / FADE_TIME);
        commonDraw2(ratio, width);
        if(ratio < 0.0f) {
            stepUp();
        }
    }

    public void commonDraw1(float ratio) {
        int alpha = (int)map(ratio, 0.0f, 1.0f, 0.0f, 255.0f);
        fill(255, alpha);
        rectMode(CORNER);
        rect(0, 0, width, height);
        fill(0, alpha);
        textAlign(CENTER);
        textSize(30);
        text("Coffee Music", 1050, 700);
    }

    public void commonDraw2(float ratio, int rect_width) {
        int alpha = (int)map(ratio, 0.0f, 1.0f, 0.0f, 255.0f);
        fill(255, alpha);
        rectMode(CORNER);
        rect(0, 0, width, height);
        fill(0, alpha);
        rectMode(CENTER);
        rect(width / 2, 500, rect_width, 10);
        fill(0, alpha);
        textAlign(CENTER);
        textSize(70);
        text(state_name, width / 2, height / 2);
    }
}
