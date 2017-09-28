public class SetupState extends State {
    private static final int MIN_TIME = 1000;
    public TextFG textFG;

    public SetupState() {
        textFont(font);
        textFG = new TextFG();
        startTime = millis();
        stepStartTime = millis();
    }

    // バックグラウンド処理はこちら側に書く
    public void run() {
        transition = new Empty();
        listener = new InputListner();
        listener.start();
        bms = new BmsController();
        minim = new Minim(applet);
        ////////////////////////////////////////////////////////////////////////////////////
        // データベースの設定
        db = new SQLite(applet, "database.db");
    }

    public void drawState() {
        textFG.drawObject();
    }

    public void popManage() {
        switch(step) {
        case 0:     //真っ暗
            stepUp(elapsedTime > 500);
            break;
        case 1:
            textFG.start();
            stepUp(textFG.isDead() && isDeadThread());
            break;
        case 2:
            state =  new TitleState();
        }
    }

    public class TextFG extends Object{
        private static final int FADE_TIME = 600;
        private static final int KEEP_TIME = 600;

        public TextFG() {
            commonDraw(0.0f);   //キャッシュ
        }

        public boolean drawIn() {
            float ratio = (float)stepElapsedTime / (float)FADE_TIME;
            ratio = constrain(ratio, 0.0f, 1.0f);
            commonDraw(ratio);
            return ratio == 1.0f ? true : false;
        }

        public boolean drawing() {
            commonDraw(1.0f);
            if(state.finishInit() && stepElapsedTime > KEEP_TIME) {
                return true;
            }
            return false;
        }

        public boolean drawOut() {
            float ratio = (float)stepElapsedTime / (float)FADE_TIME;
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
