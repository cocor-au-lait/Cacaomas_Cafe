public class SetupState extends State {
    private static final int MIN_TIME = 1000;
    public SetupFG setupFG;

    public SetupState() {
        textFont(font);
        setupFG = new SetupFG();
        setupFG.commonDraw(0.0f);    // キャッシュ
        startTime = millis();
        setupFG.start(true);
    }

    // バックグラウンド処理はこちら側に書く
    public void run() {
        listener = new InputListner();
        listener.start();
        transition = new DefaultTransition(-1);
        bms = new BmsController();
        minim = new Minim(applet);
        ////////////////////////////////////////////////////////////////////////////////////
        // データベースの設定
        db = new SQLite(applet, "database.db");
    }

    public void drawState() {
        if(elapsedTime < 1000) {
            return;
        }
        if(setupFG.drawObject() == 4) {
            state =  new TitleState();
        }
    }

    public void popManage() {

    }

    public class SetupFG extends Object{
        private static final int FADE_TIME = 600;
        private static final int KEEP_TIME = 600;

        public boolean drawIn() {
            float ratio = (float)elapsedTime / (float)FADE_TIME;
            ratio = constrain(ratio, 0.0f, 1.0f);
            commonDraw(ratio);
            return ratio == 1.0f ? true : false;
        }

        public boolean drawing() {
            commonDraw(1.0f);
            if(state.finishInit() && elapsedTime > KEEP_TIME) {
                return true;
            }
            return false;
        }

        public boolean drawOut() {
            float ratio = (float)elapsedTime / (float)FADE_TIME;
            ratio = constrain(ratio, 0.0f, 1.0f);
            commonDraw(1.0f - ratio);
            return ratio == 1.0f ? true : false;
        }

        public void commonDraw(float ratio) {
            float alpha = ratio * 255.0f;
            background(0);
            // テキスト描画
            fill(255, alpha);
            textAlign(CENTER);
            textSize(70);
            text("Project\nCacaomas_Cafe", width / 2, (height / 5) * 2);
            textSize(40);
            text("UNDER DEVELOPMENT", width / 2, (height / 5) * 3.4f);
            textSize(20);
            text("©️2017 Jun Koyama", width / 2, (height / 5) * 4);
        }
    }
}