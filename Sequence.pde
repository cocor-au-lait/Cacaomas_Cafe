private abstract class Sequence {
    private int keyFrame;
    protected int keyTime;
    private boolean isActive;

    protected final void startSequence() {
        isActive = true;
        keyFrame = 0;
        onStart();
    }

    protected final void process() {
        if(!isActive) {
            return;
        }
        executeSchedule();
        keyTime = toTime(++keyFrame);
    }

    protected final void replay() {
        keyFrame = 0;
    }

    protected final void exitSequence() {
        isActive = false;
        onExit();
    }

    protected final void exitSequence(Sequence sequence) {
        sequence.startSequence();
        exitSequence();
    }

    protected abstract void executeSchedule();
    protected void onStart() {}
    protected void onExit() {}
}
