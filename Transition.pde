public abstract class Transition {
    private int start_time;
    private int step_start_time;
    private int elapsed_time;
    private int step_elapsed_time;
    private String mode;
    private int step;     //0:turn up, 1:keep, 2:turn down, -1:dead

    public Transition() {
        start_time = millis();
    }

    public void stepUp() {
        step_start_time = millis();
        step = step == 2 ? -1 : step++;
    }

    public boolean isAlive() {
        return step >= 0 ? true : false;
    }

    public boolean isCovered() {
        return step == 1 ? true : false;
    }

    public void doTransition() {
        // 起動してからの経過時間（ms）
        elapsed_time = millis() - start_time;
        // 各ステータスに切り替わってからの経過時間（ms）
        step_elapsed_time = millis() - step_start_time;
        switch(step) {
        case 0:
            firstDraw();
            break;
        case 1:
            secondDraw();
            break;
        case 2:
            thirdDraw();
            break;
        default:
            break;
        }
    }

    public abstract void firstDraw();
    public abstract void secondDraw();
    public abstract void thirdDraw();
}
