// 擬似的なユーティリティークラス、実際はProcessing特有の処理があるため、別クラスにはできない

private float getRatio(float elapsion, int duration) {
    float ratio = elapsion / (float)duration;
    ratio = constrain(ratio, 0.0f, 1.0f);
    return ratio;
}

private float getRatio(float elapsion, int duration, Easing easing) {
    float ratio = getRatio(elapsion, duration);
    ratio = easing.get(ratio);
    return ratio;
}

private float getAntiRatio(float elapsion, int duration) {
    float ratio = getRatio(elapsion, duration);
    ratio = 1.0f - ratio;
    return ratio;
}

private float getAntiRatio(float elapsion, int duration, Easing easing) {
    float ratio = getAntiRatio(elapsion, duration);
    ratio = easing.get(ratio);
    return ratio;
}

private GroupObject getFrameGroup(String titleText) {
    TextObject title = new TextObject();
    title.setText(titleText);
    title.setFont(bickham);
    title.setTextSize(141);
    title.setAlign(CENTER, TOP);
    title.setPosition(BASE_WIDTH / 2, 0);
    FigureObject line = new FigureObject();
    line.setPosition(80, 120);
    line.setSize(1120, 3);
    GroupObject group = new GroupObject(title, line);
    return group;
}

private GroupObject getMusicGroup(MusicData data, int diff) {
    boolean isJapanese = false;
    TextObject title = new TextObject();
    title.setText(data.getTitle());
    title.setFont(isJapanese(data.getTitle()) ? yuMincho : appleChancery);
    title.setTextSize(30);
    title.setPosition(172, isJapanese(data.getTitle()) ? 251 : 243);
    TextObject artist =  new TextObject();
    artist.setText(data.getArtist());
    artist.setFont(isJapanese(data.getArtist()) ? yuMincho : appleChancery);
    artist.setColor(color(#81401E));
    artist.setTextSize(21);
    artist.setPosition(172, isJapanese(data.getArtist()) ? 299 : 291);
    TextObject bpm = new TextObject();
    bpm.setText(Integer.toString((int)data.getBpm()));
    bpm.setFont(baoli);
    bpm.setColor(color(#5F5F5F));
    bpm.setTextSize(30);
    bpm.setAlign(RIGHT, TOP);
    bpm.setPosition(667, 248);
    TextObject levelB = bpm.clone();
    levelB.setColor(color(#3787B1));
    levelB.setText(Integer.toString(data.getLevel().get(0)));
    levelB.setAlign(CENTER, TOP);
    levelB.setPosition(597, 287);
    TextObject levelA = levelB.clone();
    levelA.setColor(color(#CBA400));
    levelA.setText(Integer.toString(data.getLevel().get(1)));
    levelA.setPosition(628, 287);
    TextObject levelM = levelB.clone();
    levelM.setColor(color(#BE2D2D));
    levelM.setText(Integer.toString(data.getLevel().get(2)));
    levelM.setPosition(659, 287);
    FigureObject line = new FigureObject();
    line.setSize(540, 1);
    line.setPosition(136, 291);
    FigureObject circle = new FigureObject();
    circle.setCornerNum(0);
    circle.setSize(26, 26);
    circle.setPosition(140, 254);
    GroupObject group = new GroupObject(title, artist, bpm, levelB, levelA, levelM, line, circle);
    group.addPosition(0, 97 * diff);
    group.addState("fadeIn", new TweenState(ParameterType.ALPHA)
        .setTween(0.0f, 1.0f, 200));
    return group;
}

private boolean isJapanese(String str) {
    for(char c : str.toCharArray()) {
        if ((c <= '\u007e') || (c == '\u00a5') || (c == '\u203e') || (c >= '\uff61' && c <= '\uff9f')) {
            continue;
        }
        return true;
    }
    return false;
}

/*
private class FrameCounter {
    private int elapsedFrame;

    private float calcElapsedTime() {
        elapsedFrame++;
        // 注意！！！ 1sec = 1.0fのfloat値として算出している
        float elapsedTime = (float)elapsedFrame * 1.0f / (float)BASE_FRAME_RATE;
        return elapsedTime;
    }
}
*/

// 時間（1000ms = 1.0f）をフレーム数（60fps換算）に変換する
private int toFrame(int time) {
    int frame = (int)((float)time * (float)BASE_FRAME_RATE / 1000.0f);
    return frame;
}
// フレーム（1frame = 1000/60ms）を時間（ms）に変換する
// ！！！注意：3frame = 50ms以下の精度で綺麗な数字は出せない
private int toTime(int frame) {
    int time = (int)((float)frame / (float)BASE_FRAME_RATE * 1000.0f);
    return time;
}

// フレーム単位でアニメーションをするプログラムで処理落ち対策用のタイマークラス
private class FrameTimer {
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
