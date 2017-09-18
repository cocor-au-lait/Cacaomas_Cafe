class FPS {
    int FrameRate;
    float FPS, sumFPS;
    int cntFPS;

    FPS(int _FrameRate) {
        FrameRate = _FrameRate;
        FPS = _FrameRate;
    }
    void update() {
        if(cntFPS < FrameRate) {
            sumFPS += frameRate;
            cntFPS++;
        }
        else {
            FPS = round(sumFPS / FrameRate * 10) / 10.0;
            sumFPS = cntFPS = 0;
        }
    }
    void drawing(float x, float y) {
        textAlign(CENTER);
        text("FPS:" + FPS, x, y);
    }
}