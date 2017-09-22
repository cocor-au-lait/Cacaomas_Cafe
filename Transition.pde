public abstract class Transition {
    protected int start_time;
    protected int step_start_time;
    protected int elapsed_time;
    protected int step_elapsed_time;
    protected int step;     //0:turn up, 1:keep, 2:turn down, -1:dead

    public Transition() {
        step_start_time = millis();
        start_time = millis();
    }

    public void stepUp() {
        if(step == 0) {
            state = state.disposeState();
        }
        else if(step == 1) {
            if(!state.finishInit()) {
                return;
            }
            state.beforeState();
        }
        step = step == 2 ? -1 : step + 1;
        step_start_time = millis();
    }

    // ###メソッド名をわかりやすく変更
    public boolean isAlive() {
        return step >= 0 ? true : false;
    }

    public boolean isCovered() {
        return step == 1 ? true : false;
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
            return;
        case 1:
            secondDraw();
            return;
        case 2:
            thirdDraw();
            return;
        }
    }

    public abstract void firstDraw();
    public abstract void secondDraw();
    public abstract void thirdDraw();
}
