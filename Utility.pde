public boolean doTransition() {
    boolean answer = transition.trans_phase != 0? true: false;
    return answer;
}

public boolean canMoveToNextState() {
    boolean answer = transition.trans_phase == 2? true: false;
    return answer;
}

public void runTransition(String mode) {
    transition.resetAndStartTransition(mode);
}

public boolean isInitialize() {
    return state.initializing;
}

public void setText(int size, int col, int align) {
    textFont(font);  //設定したフォントを使用
    textSize(size);
    //textFont(createFont("Arial", 50));
    textAlign(align);
    fill(col);
}

// フレーム単位でアニメーションをするプログラムで処理落ち対策用のタイマークラス
public class FrameTimer {
    int fps = 60;
    int iCount = 0;         // 割り込みカウント数
    long mStart = System.nanoTime();           // 開始時間

    int runTimer() {
        int count = (int)( ( System.nanoTime() - mStart ) / 1000000000.0 * fps );
        if( count != iCount ) {
            int ret = count - iCount;
            iCount = count;
            return ret;
        }
        return 0;
    }
}