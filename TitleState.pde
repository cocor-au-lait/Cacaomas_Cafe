public class TitleState extends State {
    private final String main_str;
    private AudioPlayer bgm;
    private AudioSample se;
    private PImage wallpaper, logo;

    public TitleState() {
        main_str = new String("pless ENTER/START key to start");
        bgm = minim.loadFile("sound/bgm/title.mp3");
        se = minim.loadSample("sound/se/enter.mp3");
        wallpaper = loadImage("image/background/title.png");
        logo = loadImage("image/parts/title_logo.png");
        bgm.loop();
        stateMove = new StateMove();
    }
    
    public void loadingState() {
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
        text(main_str, width / 2, height * 0.8);

        if(press[6]) {
            se.trigger();
            bgm.shiftGain(1, -80, 3000);
            stateMove = new StateMove();
            phase = 2;
        }
    }

    public State nextState() {
        bgm.close();
        se.close();
        minim.stop();
        return new SelectState();
    }
}