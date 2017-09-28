public abstract class State implements Runnable {
    protected int startTime;
    protected int elapsedTime;
    protected int stepStartTime;
    protected int stepElapsedTime;
    protected boolean controllable;
    protected Thread thread;
    protected int step;
    protected boolean canNextState;

    protected State() {
        thread = new Thread(this);
        thread.start();
        startTime = millis();
        stepStartTime = millis();
    }

    public boolean isDeadThread() {
        return !thread.isAlive();
    }

    public boolean finishInit() {
        // スレッドが生きていればまだ初期化中ということ
        return !thread.isAlive();
    }

    public void stepUp() {
        stepStartTime = millis();
        step++;
    }

    public void stepUp(boolean flag) {
        if(flag) {
            stepStartTime = millis();
            step++;
        }
    }

    public void stepUp(boolean flag, int num) {
        if(flag) {
            stepStartTime = millis();
            step++;
        }
    }

    public void goNextState() {
        canNextState = true;
    }

    public boolean isControllable() {
        return controllable;
    }
    // ループ
    public void doState() {
        if(thread.isAlive()) {
            return;
        }
        // 各画面での経過時間の算出（ms）
        elapsedTime = millis() - startTime;
        stepElapsedTime = millis() - stepStartTime;
        popManage();
        // ステートの描画
        drawState();
    }

    public abstract void drawState();
    public abstract void popManage();
}

public class Empty extends State {
    public void run() {

    }

    public void drawState() {

    }

    public void popManage() {

    }
}
