public class DefaultTransition extends State {
    private static final int KEEP_TIME = 1500;
    private DripBG dripBG;
    private LogoFG logoFG;
    private TipFG tipFG;
    private SoundFile se;

    public DefaultTransition() {
        se = new SoundFile(applet, "sound/se/select.wav");
        se.play();
        dripBG = new DripBG(#553D2A);
    }

    public void run() {
        logoFG = new LogoFG("image/parts/white_logo.png");
        tipFG = new TipFG("image/parts/tip_demo.png");
    }

    public void drawState() {
        dripBG.drawObject();
        logoFG.drawObject();
        tipFG.drawObject();
    }

    public void popManage() {
        switch(step) {
        case 0:     // 幕が上がる
            dripBG.start();
            stepUp(dripBG.isDrawing());
            break;
        case 1:     // ロゴが現れる
            //x_pos, y_pos, x_size, y_size
            logoFG.start(880, 660, 362, 110);
            stepUp(logoFG.isDrawing());
            break;
        case 2:     // バックのStateを更新
            state.goNextState();
            stepUp();
            break;
        case 3:     // 表示インターバル
            stepUp(stepElapsedTime > 400);
            break;
        case 4:     // チップが出現
            tipFG.start();
            stepUp(tipFG.isDrawing());
            break;
        case 5:     // ロード中
            stepUp(stepElapsedTime > KEEP_TIME && state.isDeadThread());
            break;
        case 6:     // チップとロゴが消える
            tipFG.forceDrawOut();
            logoFG.forceDrawOut();
            stepUp(logoFG.isDead() && tipFG.isDead());
            break;
        case 7:     // 幕が上がる
            dripBG.forceDrawOut();
            stepUp(dripBG.isDead());
            break;
        case 8:     // 解放
            transition = new Empty();
        }
    }

    public class DripBG extends Object {
        private static final int FADE_IN_TIME = 900;
        private static final int FADE_OUT_TIME = 600;
        private color bgColor;

        public DripBG(color bgColor) {
            this.bgColor = bgColor;
        }

        public boolean drawIn() {
            float ratio;
            ratio = (float)stepElapsedTime / (float)FADE_IN_TIME;
            ratio = constrain(ratio, 0.0f, 1.0f);
            ratio = easeInCubic(ratio);
            commonDraw(ratio);
            return ratio == 1.0f ? true : false;
        }

        public boolean drawing() {
            commonDraw(1.0f);
            return false;
        }

        public boolean drawOut() {
            float ratio;
            ratio = (float)stepElapsedTime / (float)FADE_OUT_TIME;
            ratio = constrain(ratio, 0.0f, 1.0f);
            ratio = easeOutExpo(ratio);
            commonDraw(1.0f - ratio);
            return ratio == 1.0f ? true : false;
        }

        public void commonDraw(float ratio) {
            fill(bgColor);
            rectMode(CORNER);
            rect(0, height - height * ratio, width, height);
        }
    }

    public class LogoFG extends Object {
        private static final int FADE_IN_TIME = 600;
        private static final int FADE_OUT_TIME = 200;
        private PImage titleLogo;
        private int x_pos, y_pos, x_size, y_size;

        public LogoFG(String filename) {
            titleLogo = loadImage(filename);
        }

        public void start(int x_pos, int y_pos, int x_size, int y_size) {
            this.x_pos = x_pos;
            this.y_pos = y_pos;
            this.x_size = x_size;
            this.y_size = y_size;
            start();
        }

        public boolean drawIn() {
            float ratio = (float)stepElapsedTime / (float)FADE_IN_TIME;
            ratio = constrain(ratio, 0.0f, 1.0f);
            imageMode(CORNER);
            tint(255, 255.0f * ratio);
            image(titleLogo, x_pos, y_pos, x_size, y_size);
            noTint();
            return ratio == 1.0f ? true : false;
        }

        public boolean drawing() {
            imageMode(CORNER);
            image(titleLogo, x_pos, y_pos, x_size, y_size);
            return false;
        }

        public boolean drawOut() {
            float ratio = (float)stepElapsedTime / (float)FADE_OUT_TIME;
            ratio = constrain(ratio, 0.0f, 1.0f);
            imageMode(CORNER);
            tint(255, 255.0f * (1.0f - ratio));
            image(titleLogo, x_pos, y_pos, x_size, y_size);
            noTint();
            return ratio == 1.0f ? true : false;
        }
    }

    public class TipFG extends Object {
        private PImage tipImage;
        private static final int FADE_IN_TIME = 1000;
        private static final int FADE_OUT_TIME = 300;

        public TipFG(String filename) {
            tipImage = loadImage(filename);
        }

        public boolean drawIn() {
            float ratio = (float)stepElapsedTime / (float)FADE_IN_TIME;
            ratio = constrain(ratio, 0.0f, 1.0f);
            ratio = easeOutExpo(ratio);
            float x_pos = -800 + (1054 * ratio);
            imageMode(CORNER);
            image(tipImage, x_pos, 80, 772, 568);
            return ratio == 1.0f ? true : false;
        }

        public boolean drawing() {
            imageMode(CORNER);
            image(tipImage, 254, 80, 772, 568);
            return false;
        }

        public boolean drawOut() {
            float ratio = (float)stepElapsedTime / (float)FADE_OUT_TIME;
            ratio = constrain(ratio, 0.0f, 1.0f);
            ratio = easeOutCirc(ratio);
            float x_pos = 254 + (1100 * ratio);
            imageMode(CORNER);
            image(tipImage, x_pos, 80, 772, 568);
            return ratio == 1.0f ? true : false;
        }
    }
}
