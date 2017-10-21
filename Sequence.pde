private abstract class Sequence {
    private int keyFrame;
    protected int keyTime;
    private boolean isActive;

    protected final void startSequence() {
        isActive = true;
        keyFrame = 0;
        onStart();
    }   

    protected final void processSequence() {
        if(!isActive) {
            return;
        }
        onProcess();
        keyTime = toTime(++keyFrame);
    }

    protected final void replaySequence() {
        keyFrame = 0;
    }

    protected final void stopSequence() {
        isActive = false;
        onStop();
    }

    protected final void changeSequence(Sequence sequence) {
        sequence.startSequence();
        stopSequence();
    }

    protected abstract void onProcess();
    protected void onStart() {}
    protected void onStop() {}
}
