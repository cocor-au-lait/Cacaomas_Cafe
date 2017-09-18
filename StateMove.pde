public class StateMove {
    private int start_time;
    private float ratio;

    public StateMove() {
        start_time = millis();
        controlable = false;
        noStroke();
    }

    public void riseScene() {
        rectMode(CORNER);
        ratio = (millis() - start_time) / 1000f;
        ratio = constrain(ratio, 0, 1f);
        ratio = easeInCubic(ratio);

        fill(234, 135, 35);

        rect(0, height / 6 * 0, width * (1f - ratio), height / 6);
        rect(0, height / 6 * 2, width * (1f - ratio), height / 6);
        rect(0, height / 6 * 4, width * (1f - ratio), height / 6);

        fill(231, 184, 144);

        rect(width * ratio, height / 6 * 1, width, height / 6);
        rect(width * ratio, height / 6 * 3, width, height / 6);
        rect(width * ratio, height / 6 * 5, width, height / 6);

        if(millis() - start_time > 1000) {
            controlable = true;
            phase = 1;
        }
    }

    public void fallScene() {
        rectMode(CORNER);
        ratio = (millis() - start_time) / 1000f;
        ratio = constrain(ratio, 0, 1f);
        ratio = easeOutCubic(ratio);

        fill(234, 135, 35);

        rect(0, height / 6 * 0, width * ratio, height / 6);
        rect(0, height / 6 * 2, width * ratio, height / 6);
        rect(0, height / 6 * 4, width * ratio, height / 6);

        fill(231, 184, 144);

        rect(width * (1f - ratio), height / 6 * 1, width, height / 6);
        rect(width * (1f - ratio), height / 6 * 3, width, height / 6);
        rect(width * (1f - ratio), height / 6 * 5, width, height / 6);

        if(millis() - start_time > 3000) {
            phase = 3;
        }
    }

    public void fadeOut(float time) {
        rectMode(CORNER);
        ratio = (millis() - start_time) / time;
        ratio = constrain(ratio, 0, 1f);

        fill(0, 255 * (1f - ratio));
        rect(0, 0, width, height);

        if(millis() - start_time > time) {
            phase = 1;
            controlable = true;
        }
    }

    public void fadeIn(float time) {
        rectMode(CORNER);
        ratio = (millis() - start_time) / time;
        ratio = constrain(ratio, 0, 1f);

        fill(0, 255 * ratio);
        rect(0, 0, width, height);

        if(millis() - start_time > time) {
            phase = 3;
        }
    }
}
