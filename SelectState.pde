class SelectState extends State {
    AudioPlayer bgm;
    PImage bg;

    SelectState() {
        bg = loadImage("image/background/select.png");
        bgm = minim.loadFile("sound/bgm/hanyo.mp3");
        bgm.loop();
    }
    
    public void loadingState() {
    }

    void drawState() {
        imageMode(CORNER);
        image(bg, 0 , 0, width, height);
        setText(50, 0, CORNER);
        textAlign(CORNER, TOP);
        text("select music", 50, 50);

        if(press[6]) {
            stateMove = new StateMove();
            phase = 2;
        }
    }

    State nextState() {
        bgm.close();
        minim.stop();
        return new DecideState();
    }
}