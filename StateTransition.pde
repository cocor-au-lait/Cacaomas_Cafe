public class StateTransitionThread extends Thread {
    PApplet applet;
    private int start_time;
    private int elapsed_time;
    private String mode;
    private int trans_phase;

    public StateTransitionThread(PApplet applet) {
        this.applet = applet;
    }

    public int getPhase() {
        return trans_phase;
    }

    public void setPhase(int trans_phase) {
        this.trans_phase = trans_phase;
    }

    public void resetAndStartTransition(String mode) {
        start_time = millis();
        this.mode = mode;
        trans_phase = 1;
    }

    public void transitionDraw() {
        println(trans_phase);
        if(trans_phase <= 0) {
            return;
        }
        elapsed_time = millis() - start_time;
        switch(mode) {
        case "SIMPLE":
        default:
            simpleTransition();
            break;
        }
    }

    public void simpleTransition() {
        float ratio = 0.0f;
        switch(trans_phase) {
        case 1:
            ratio = elapsed_time / 2000.0f;
            if(ratio > 1.0f) {
                start_time = millis();
                trans_phase = 2;
            }
            break;
        case 2:
            ratio = 1.0f;
            if(!isInitializing()) {
                start_time = millis();
                trans_phase = 3;
            }
            break;
        case 3:
            ratio = 1.0f - (elapsed_time / 2000.0f);
            if(ratio > 1.0f) {
                start_time = millis();
                trans_phase = 0;
            }
            break;
        }
        rectMode(CORNER);
        fill(0, 255 * ratio);
        rect(0, 0, width, height);
    }
}
