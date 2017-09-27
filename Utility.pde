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

public abstract class Object {
    int startTime;
    int elapsedTime;
    int step;
    boolean startFlag;

    public int drawObject() {
        if(!startFlag) {
            startTime = millis();
            startFlag = true;
        }
        elapsedTime = millis() - startTime;
        switch(step) {
        case 0:
            if(drawIn()) {
                step++;
                startTime = millis();
            }
            break;
        case 1:
            if(drawing()) {
                step++;
                startTime = millis();
            }
            break;
        case 2:
            if(drawOut()) {
                step++;
            }
        }
        return step;
    }

    abstract boolean drawIn();
    abstract boolean drawing();
    abstract boolean drawOut();
}