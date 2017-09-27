public class TitleState extends State {
    private AudioPlayer bgm;
    private SoundFile se;
    private TitleBG titleBG;
    private WhiteoutOG whiteoutOG;
    private TextFG textFG;
    private PartsMG[] partsMG;
    private LogoFG logoFG;

    public void run() {
        bgm = minim.loadFile("sound/bgm/title.wav");
        se = new SoundFile(applet, "sound/se/enter.wav");
        titleBG = new TitleBG("image/background/title.png");
        logoFG = new LogoFG("image/parts/black_logo.png");
        whiteoutOG = new WhiteoutOG();
        textFG = new TextFG();
        partsMG = new PartsMG[5];
        partsMG[0] = new PartsMG(162, 96, 322, 0.22f, false);
        partsMG[1] = new PartsMG(52, 372, 256, 0.2f, true);
        partsMG[2] = new PartsMG(578, -87, 390, 0.15f, true);
        partsMG[3] = new PartsMG(934, 270, 183, 0.25f, true);
        partsMG[4] = new PartsMG(980, 490, 236, 0.19f, true);
    }

    public void drawState() {
        // BackGround
        titleBG.drawObject();
        // MiddleGround
        for(int i = 0; i < partsMG.length; i++) {
            partsMG[i].drawObject();
        }
        // ForeGround
        logoFG.drawObject();
        textFG.drawObject();
        // OverGround
        whiteoutOG.drawObject();

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

    public void popManage() {
        titleBG.start(true);
        whiteoutOG.start(titleBG.canNextPop());
        for(int i = 0; i < partsMG.length; i++) {
            partsMG[i].start(whiteoutOG.canNextPop());
        }
        textFG.start(whiteoutOG.canNextPop());
        logoFG.start(whiteoutOG.canNextPop());
    }

    /*public State disposeState() {
        bgm.close();
        return new EntryState();
    }*/

    public class TitleBG extends Object {
        private PImage wallpaper;
        private static final int FADE_IN_TIME = 1000;
        private boolean canNextPop;

        public TitleBG(String filename) {
            wallpaper = loadImage(filename);
        }

        public boolean drawIn() {
            float ratio = (float)elapsedTime / (float)FADE_IN_TIME;
            ratio = constrain(ratio, 0.0f, 1.0f);
            float easedRatio = easeOutBack(ratio);
            if(easedRatio > 1.0f) {
                canNextPop = true;
            }
            float alpha = 255.0f * ratio;
            colorMode(ADD);
            tint(255, alpha);
            imageMode(CENTER);
            image(wallpaper, width / 2, height / 2, width * easedRatio, height * easedRatio);
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

        public boolean canNextPop() {
            return canNextPop;
        }
    }

    public class WhiteoutOG extends Object{
        private static final int FADE_TIME = 500;

        public boolean drawIn() {
            float ratio = (float)elapsedTime / (float)FADE_TIME;
            ratio = constrain(ratio, 0.0f, 1.0f);
            float alpha = ratio * 255.0f;
            fill(255, alpha);
            rectMode(CORNER);
            rect(0, 0, width, height);
            return ratio == 1.0f ? true : false;
        }

        public boolean drawing() {
            fill(255);
            rectMode(CORNER);
            rect(0, 0, width, height);
            bgm.loop();
            return true;
        }

        public boolean drawOut() {
            float ratio = (float)elapsedTime / (float)FADE_TIME;
            ratio = constrain(ratio, 0.0f, 1.0f);
            float alpha = (1.0f - ratio) * 255.0f;
            fill(255, alpha);
            rectMode(CORNER);
            rect(0, 0, width, height);
            return ratio == 1.0f ? true : false;
        }

        public boolean canNextPop() {
            return step > 1 ? true : false;
        }
    }

    public class TextFG extends Object {
        private static final int TEXT_SIZE = 35;
        private static final int INTERVAL_TIME = 1000;
        private boolean flag;

        public boolean drawIn() {
            return true;
        }

        public boolean drawing() {
            float ratio;
            ratio = (float)elapsedTime / (float)INTERVAL_TIME;
            ratio = constrain(ratio, 0.0f, 1.0f);
            ratio = easeInOutCubic(ratio);
            float alpha;
            if(flag) {
                alpha = ratio * 255.0f;
            } else {
                alpha = (1.0f - ratio) * 255.0f;
            }
            fill(0, alpha);
            textFont(font);
            textSize(TEXT_SIZE);
            textMode(CENTER);
            text("pless ENTER/START key to start", width / 2, height * 0.8);
            if(ratio == 1.0f) {
                flag = !flag;
                startTime = millis();
            }
            return false;
        }

        public boolean drawOut() {
            return false;
        }
    }

    public class PartsMG extends Object {
        private int x_pos, y_pos, size;
        private float deg;
        private float degPlus;
        private float degSpeed;
        private boolean isLeft;

        public PartsMG(int x_pos, int y_pos, int size,float degSpeed, boolean isLeft) {
            this.x_pos = x_pos;
            this.y_pos = y_pos;
            this.size = size;
            this.degSpeed = degSpeed;
            this.isLeft = isLeft;
            degPlus = 20.0f;
        }

        public boolean drawIn() {
            degPlus --;
            commonDraw(degPlus);
            return degPlus < degSpeed ? true : false;
        }

        public boolean drawing() {
            commonDraw(degSpeed);
            return false;
        }

        public boolean drawOut() {
            return false;
        }

        public void commonDraw(float degsabun) {
            deg = deg < 360.0f ? deg + degsabun : 0.0f;
            blendMode(ADD);
            pushMatrix();
            translate(x_pos + size / 2, y_pos + size / 2);
            if(isLeft) {
                rotate(radians(deg));
            } else {
                rotate(radians(-deg));
            }
            rectMode(CENTER);
            fill(20);
            rect(0, 0, size, size);
            popMatrix();
            blendMode(BLEND);
        }
    }

    public class LogoFG extends Object {
        private PImage titleLogo;

        public LogoFG(String filename) {
            titleLogo = loadImage(filename);
        }

        public boolean drawIn() {
            return true;
        }

        public boolean drawing() {
            imageMode(CORNER);
            image(titleLogo, 246, 80, 789, 279);
            return false;
        }

        public boolean drawOut() {
            return false;
        }
    }
}
