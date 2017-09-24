public class TitleState extends State {
    private String main_str;
    private AudioPlayer bgm;
    private AudioSample se;
    private PImage wallpaper, logo;
    private PImage[] aaa;

    public void beforeState() {
        start_time = millis();
        bgm.loop();
    }

    public void drawState() {
        // 背景
        imageMode(CORNER);
        image(wallpaper, 0 , 0, width, height);

        // タイトルロゴ
        imageMode(CENTER);
        image(logo, width / 2 , 180);

        //各項目の描画
        textSize(40);
        fill(255);
        text(main_str, width / 2, height * 0.8);

        if(listener.press[6] && transition.isAlive()) {
            se.trigger();
            bgm.shiftGain(1, -80, 3000);
        }
    }

    public State disposeState() {
        bgm.close();
        se.close();
        return new SelectState();
    }

    // バックグラウンド処理はこちら側に書く
    public void run() {
        main_str = new String("pless ENTER/START key to start");
        bgm = minim.loadFile("sound/bgm/title.mp3");
        se = minim.loadSample("sound/se/enter.mp3");
        wallpaper = loadImage("image/background/title.png");
        logo = loadImage("image/parts/title_logo.png");
    }
}
