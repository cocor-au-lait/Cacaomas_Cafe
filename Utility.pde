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

public class FrameRate{
    int frameRate_;
    float fps, sumFPS;
    int cntFPS;
    FrameRate(int frameRate_){
        this.frameRate_ = frameRate_;
        fps = frameRate_;
    }
    void Update(){
        if(cntFPS < frameRate_){
            sumFPS += frameRate;
            cntFPS++;
        }else{
            fps = round(sumFPS / frameRate_ * 10) / 10.0;
            sumFPS = cntFPS = 0;
        }
    }
}

public abstract class Object {
    int startTime;
    int elapsedTime;
    int stepStartTime;
    int stepElapsedTime;
    int step;
    boolean ready;      // 描画を開始してもいいかどうかの判定

    public void drawObject() {
        if(!ready) {
            return;
        }
        elapsedTime = millis() - startTime;
        stepElapsedTime = millis() - stepStartTime;
        switch(step) {
        case 0:
            stepUp(true);
            break;
        case 1:
            stepUp(drawIn());
            break;
        case 2:
            stepUp(drawing());
            break;
        case 3:
            stepUp(drawOut());
        }
    }

    public void stepUp(boolean flag) {
        if(flag) {
            stepStartTime = millis();
            step++;
        }
    }

    public boolean isDrawIn() {
        return step == 1 ? true : false;
    }

    public boolean isDrawing() {
        return step == 2 ? true : false;
    }

    public boolean isDrawOut() {
        return step == 3 ? true : false;
    }

    public boolean isDead() {
        return step == 4 ? true : false;
    }

    public void forceDrawOut() {
        if(step == 2) {
            stepUp(true);
        }
    }

    public void start() {
        ready = true;
    }

    abstract boolean drawIn();
    abstract boolean drawing();
    abstract boolean drawOut();
}
