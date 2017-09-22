public abstract class State implements Runnable {
    protected boolean controllable;
    protected int start_time;
    protected int elapsed_time;
    protected boolean initialize;
    protected boolean controllable;

    protected State() {
        initialize = true;
        Thread thread = new Thread(this);
        thread.start();
        start_time = millis();
    }

    // 他クラスで初期化子を実行しているかの判断に使用
    public boolean isInitializing() {
        return isInitializing;
    }

    // ループ
    public State doState() {
        if(controllable) {
            listener.keyControll();
        }
        // 各画面での経過時間（ms）
        elapsed_time = millis() - start_time;
        // ステートの描画が完全に見えないタイミングでは描画をしない
        if(transition.getStatus() != 3) {
            drawState();
        }
        // transInが完了したら次のステートのイニシャライズを開始する
        if(canMoveToNextState() && !initializing) {
            transition.trans_phase = 3;
            return nextState();
        }
        // 画面の描画を続ける
        return this;
    }

    public abstract void drawState();           // メインの描画を行う
    public abstract State nextState();          // 次の画面を呼び出す
}
