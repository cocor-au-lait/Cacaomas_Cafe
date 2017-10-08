// 擬似的なユーティリティークラス、実際はProcessing特有の処理があるため、別クラスにはできない

private void setTextSetting(int size, PFont font, color textColor, int align) {
    textSize(size);
    textFont(font);
    fill(textColor);
    textAlign(align);
}

private float calcRatio(int elapsedTime, int duration) {
    float ratio = (float)elapsedTime / (float)duration;
    ratio = constrain(ratio, 0.0f, 1.0f);
    return ratio;
}

// フレーム単位でアニメーションをするプログラムで処理落ち対策用のタイマークラス
private class FrameTimer {
    private static final int BASE_FRAME_RATE = 60;
    private int lastElapsedFrame;                            // 割り込みカウント数
    private long timerStartTime = System.nanoTime();    // 開始時間

    private int getDiffFrame() {
        int nowElapsedFrame = (int)((double)(System.nanoTime() - timerStartTime) / 1000000000.0d * (double)BASE_FRAME_RATE);
        int diffFrame = nowElapsedFrame - lastElapsedFrame;
        lastElapsedFrame = nowElapsedFrame;
        return diffFrame;
    }
}

private class FrameRate{
    private int frameRate_;
    private float fps, sumFPS;
    private int cntFPS;
    FrameRate(int frameRate_){
        this.frameRate_ = frameRate_;
        fps = frameRate_;
    }
    private void Update(){
        if(cntFPS < frameRate_){
            sumFPS += frameRate;
            cntFPS++;
        }else{
            fps = round(sumFPS / frameRate_ * 10) / 10.0;
            sumFPS = cntFPS = 0;
        }
    }
}
