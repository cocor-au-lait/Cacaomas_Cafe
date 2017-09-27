public class TitleState extends State {
    private AudioPlayer bgm;
    private SoundFile se;
    private TitleBG titleBG;

    public TitleState() {
        startTime = millis();
    }
/*
    public void beforeState() {
        startTime = millis();
        bgm.loop();
    }*/

    public void drawState() {
        if(!thread.isAlive()) {
            titleBG.drawObject();
        }
        // タイトルロゴ
        //imageMode(CORNER);
        //image(logo, 246, 80, 789, 279);

        //各項目の描画
        //textAlign(CENTER);
        //textSize(40);
        //fill(0);
        //text("pless ENTER/START key to start", width / 2, height * 0.8);

        /*if(listener.press[6] && !transition.isAlive()) {
            se.play();
            bgm.shiftGain(1, -80, 3000);
            transition = new GeneralTransition("Player Entry");
            controllable = false;
        }*/
    }

    /*public State disposeState() {
        bgm.close();
        return new EntryState();
    }*/

    // バックグラウンド処理はこちら側に書く
    public void run() {
        bgm = minim.loadFile("sound/bgm/title.wav");
        se = new SoundFile(applet, "sound/se/enter.wav");
        titleBG = new TitleBG("image/background/title.png");
        //logo = loadImage("image/parts/title_logo.png");
    }
}

public class TitleBG extends Object {
    private PImage wallpaper;
    private static final int FADE_IN_TIME = 1000;

    public TitleBG(String filename) {
        wallpaper = loadImage(filename);
    }

    public boolean drawIn() {
        float ratio = (float)elapsedTime / (float)FADE_IN_TIME;
        ratio = constrain(ratio, 0.0f, 1.0f);
        float ratio2 = easeOutBack(ratio);
        ratio = constrain(ratio, 0.0f, 10 .0f);
        float alpha = 255.0f * ratio;
        colorMode(ADD);
        tint(255, alpha);
        imageMode(CENTER);
        image(wallpaper, width / 2, height / 2, width * ratio2, height * ratio2);
        noTint();
        colorMode(BLEND);
        return ratio == 1.0 ? true : false;
    }

    public boolean drawing() {
        imageMode(CORNER);
        image(wallpaper, 0, 0, width, height);
        return false;
    }

    public boolean drawOut() {
        return false;
    }
}
