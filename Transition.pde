public abstract class Transition {
    protected int start_time;
    protected int step_start_time;
    protected int elapsed_time;
    protected int step_elapsed_time;
    private int overlay_time;
    protected int step;     //0:turn up, 1:keep, 2:turn down, -1:dead

    public Transition() {
        step_start_time = millis();
        start_time = millis();
    }
    // 次のTransition描画に（overlay_time(ms)かけて）移行する
    public void stepUp(int overlay_time) {
        this.overlay_time = overlay_time;
        // stateの初期化が終わっていなければ次のステップに移行しない
        if(step == 1 && !state.finishInit()) {
            return;
        }
        // step++（3の場合は-1に）
        step = step == 3 ? -1 : step + 1;
        switch(step) {
        case 1:
            // 次のstateに以降
            state = state.disposeState();
            break;
        case 3:
            // drawStateを開始する直前動作を呼び出し
            state.beforeState();
        }
        // それぞれのdrawの開始時間を計測開始
        step_start_time = millis();
    }

    public void stepUp() {
        stepUp(0);
    }

    // ###メソッド名をわかりやすく変更
    public boolean isAlive() {
        return step >= 0 ? true : false;
    }

    public boolean isCovered() {
        if(step == 1 || step ==2) {
            return true;
        }
        return false;
    }

    public void doTransition() {
        if(step == -1) {
            return;
        }
        // 起動してからの経過時間（ms）
        elapsed_time = millis() - start_time;
        // 各ステータスに切り替わってからの経過時間（ms）
        step_elapsed_time = millis() - step_start_time;
        switch(step) {
        case 0:
            firstDraw();
            break;
        case 1:
            if(step_elapsed_time < overlay_time) {
                firstDraw();
            }
            secondDraw();
            break;
        case 2:
            if(step_elapsed_time < overlay_time) {
                secondDraw();
            }
            thirdDraw();
            break;
        case 3:
            if(step_elapsed_time < overlay_time) {
                thirdDraw();
            }
            lastDraw();
        }
    }

    public abstract void firstDraw();
    public abstract void secondDraw();
    public abstract void thirdDraw();
    public abstract void lastDraw();
}
