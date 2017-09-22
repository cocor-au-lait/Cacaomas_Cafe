public abstract class State implements Runnable {
    protected int start_time;
    protected int elapsed_time;
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

    // ループ
    public void doState() {
        if(transition.isCovered()) {
            return;
        }
        // 此処より下はState画面が少しでも映る場合処理する
        if(controllable) {
            listener.keyControll();
        }
        // 各画面での経過時間の算出（ms）
        elapsed_time = millis() - start_time;
        // ステートの描画
        drawState();
    }

    public abstract void beforeState();            // 描画が始まる直前に開始する処理
    public abstract void drawState();           // メインの描画を行う
    public abstract State disposeState();       // Stateの後処理を行い次のStateで返す
}
