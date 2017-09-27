public class GeneralTransition extends Transition {
    private static final int MIN_TIME = 2000;
    private static final int FADE_TIME = 1000;
    private static final int TIP_FADE_TIME = 500;
    private static final int STATE_NAME_TIME = 2000;
    private String state_name;
    private PImage logo, tip;

    public GeneralTransition(String state_name) {
        this.state_name = state_name;
        logo = loadImage("image/parts/title_logo.png");
        tip = loadImage("image/jacket.png");
    }

    public void firstDraw() {
        float alpha = ((float)step_elapsed_time / (float)FADE_TIME) * 255.0f;
        backgroundAnimation(alpha);
        if(alpha > 255.0f) {
            stepUp();
        }
    }

    public void secondDraw() {
        backgroundAnimation(255.0f);
        if(tipInformation()) {
            stepUp();
        }
    }

    public void thirdDraw() {
        backgroundAnimation(255.0f);
        stateName(-1.0f);
        if(step_elapsed_time > STATE_NAME_TIME) {
            stepUp();
        }
    }

    public void lastDraw() {
        float alpha = 1.0f - (step_elapsed_time / (float)FADE_TIME) * 255.0f;
        backgroundAnimation(alpha);
        stateName(alpha);
        if(alpha < 0.0f) {
            stepUp();
        }
    }

    public void backgroundAnimation(float alpha) {
        fill(#D8C4FF, alpha);
        rectMode(CORNER);
        rect(0, 0, width, height);
    }

    public boolean tipInformation() {
        float alpha = 255.0f;
        if(step_elapsed_time < TIP_FADE_TIME) {
            alpha = ((float)step_elapsed_time / (float)TIP_FADE_TIME) * 255.0f;
        } else if(step_elapsed_time > MIN_TIME) {
            alpha = 1.0f - (((float)step_elapsed_time - (float)MIN_TIME) / (float)TIP_FADE_TIME) * 255.0f;
            if(alpha < 0.0f) {
                return true;
            }
        }
        tint(255, alpha);
        imageMode(CENTER);
        image(tip, width / 2, height / 2);

        imageMode(CORNER);
        image(logo, 862, 626, 378, 134);
        noTint();

        return false;
    }

    public void stateName(float alpha) {
        if(step_elapsed_time < TIP_FADE_TIME && alpha == -1.0f) {
            alpha = ((float)step_elapsed_time / (float)TIP_FADE_TIME) * 255.0f;
        }
        fill(0, alpha);
        rectMode(CENTER);
        rect(width / 2, 500, (int)(step_elapsed_time / 10), 5);

        fill(0, alpha);
        textAlign(CENTER);
        textSize(70);
        text(state_name, width / 2, height / 2);
    }
}
