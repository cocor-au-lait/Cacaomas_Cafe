public class TitleState extends State {
    private String main_str;
    private AudioPlayer bgm;
    private AudioSample se;
    private PImage wallpaper, logo;
    private PImage[] aaa;

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

        if(press[6] && !doTransition()) {
            se.trigger();
            bgm.shiftGain(1, -80, 3000);
        }
    }

    public State nextState() {
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
        /*aaa = new PImage[500];
        for(int i = 0; i < aaa.length; i++) {
            aaa[i] = loadImage("image/parts/title_logo.png");
        }*/
        bgm.loop();
        state.initializing = false;
    }
}
