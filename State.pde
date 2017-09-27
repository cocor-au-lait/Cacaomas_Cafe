public abstract class State implements Runnable {
    protected int startTime;
    protected int elapsedTime;
    protected boolean controllable;
    protected Thread thread;

    protected State() {
        thread = new Thread(this);
        thread.start();
    }

    public boolean finishInit() {
        // スレッドが生きていればまだ初期化中ということ
        return !thread.isAlive();
    }

    public boolean isControllable() {
        return controllable;
    }

    // ループ
    public void doState() {
        // 各画面での経過時間の算出（ms）
        elapsedTime = millis() - startTime;
        // ステートの描画
        drawState();
    }

    public abstract void drawState();
}
