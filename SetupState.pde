public class SetupState extends State {
    private static final int MIN_TIME = 2000;

    public SetupState() {
        textFont(createFont("PrestigeEliteStd-Bd",70,true));
        start_time = millis();
    }

    public void beforeState() {
    }

    public void drawState() {
        int alpha = (int)constrain(elapsed_time / 5.0 - 100, 0, 255);
        background(0);
        fill(255, alpha);
        textSize(70);
        textAlign(CENTER);
        text("Project\nCacaomas_Cafe", width / 2, (height / 5) * 2);
        textSize(40);
        text("UNDER DEVELOPMENT", width / 2, (height / 5) * 3.4);
        textSize(20);
        text("©️2017 Jun Koyama", width / 2, (height / 5) * 4);
        if(elapsed_time > MIN_TIME && finishInit() && !transition.isAlive()) {
            transition = new DefaultTransition();
        }
    }

    public State disposeState() {
        return new TitleState();
    }

    // バックグラウンド処理はこちら側に書く
    public void run() {
        listener = new InputListner();
        transition = new DefaultTransition(-1);
        bms = new BmsController();
        minim = new Minim(applet);
        font = createFont("Georgia", 100);
        ////////////////////////////////////////////////////////////////////////////////////
        // データベースの設定
        db = new SQLite(applet, "database.db");
    }
}
