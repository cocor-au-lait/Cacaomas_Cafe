public abstract class Transition {
    private int start_time;
    private int elapsed_time;
    private String mode;
    private int status;

    public int getStatus() {
        return status;
    }

    // #####
    public void setStatus(int status) {
        this.status = status;
    }

    // #####
    public void resetAndStartTransition(String mode) {
        start_time = millis();
        this.mode = mode;
        trans_phase = 1;
    }

    public abstract void drawTransition();
}
