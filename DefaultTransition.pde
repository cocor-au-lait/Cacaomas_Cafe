public class DefaultTransition extends State {
    private static final int KEEP_TIME = 1000;
    private DripBG dripBG;
    private LogoFG logoFG;

    public DefaultTransition() {
        dripBG = new DripBG(#553D2A);
    }

    public void run() {
        logoFG = new LogoFG("image/parts/white_logo.png");
    }

    public void drawState() {
        dripBG.drawObject();
        logoFG.drawObject();
    }

    public void popManage() {
        switch(step) {
        case 0:     // 幕が上がる
            dripBG.start(1200);
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
        case 3:     // ロード中
            stepUp(stepElapsedTime > KEEP_TIME && state.isDeadThread());
            break;
        case 4:     // ロゴが消える
            logoFG.forceDrawOut();
            stepUp(logoFG.isDead());
            break;
        case 5:     // 幕が上がる
            dripBG.forceDrawOut();
            stepUp(dripBG.isDead());
            break;
        case 6:     // 解放
            transition = new Empty();
        }
    }

    public class DripBG extends Object {
        private int fadeInTime;
        private color bgColor;

        public DripBG(color bgColor) {
            this.bgColor = bgColor;
        }

        public boolean drawIn() {
            float ratio;
            ratio = (float)stepElapsedTime / (float)fadeInTime;
            ratio = constrain(ratio, 0.0f, 1.0f);
            ratio = easeInCubic(ratio);
            commonDraw(ratio);
            return ratio == 1.0f ? true : false;
        }

        public void start(int fadeInTime) {
            this.fadeInTime = fadeInTime;
            start();
        }

        public boolean drawing() {
            commonDraw(1.0f);
            return false;
        }

        public boolean drawOut() {
            float ratio;
            ratio = (float)stepElapsedTime / (float)fadeInTime;
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
        private static final int FADE_TIME = 500;
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
            float ratio = (float)stepElapsedTime / (float)FADE_TIME;
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
            float ratio = (float)stepElapsedTime / (float)FADE_TIME;
            ratio = constrain(ratio, 0.0f, 1.0f);
            imageMode(CORNER);
            tint(255, 255.0f * (1.0f - ratio));
            image(titleLogo, x_pos, y_pos, x_size, y_size);
            noTint();
            return ratio == 1.0f ? true : false;
        }
    }
}
