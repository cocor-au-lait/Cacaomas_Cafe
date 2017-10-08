private class DefaultTransition extends Scene {
    private int step, openStep, closeStep;
    private RectObject background;
    private ImageObject logo;
    //rivate TipFG tipFG;
    private SoundFile se;

    private DefaultTransition() {
        // 効果音はすぐに再生される必要があるためこちらに記述
        se = new SoundFile(applet, "sound/se/select.wav");
        se.play();
        background = new RectObject();
        background.setFillColor(color(#553D2A), 1.0f);
        logo = new ImageObject("image/parts/white_logo.png");
        logo.setPosition(880, 660, CORNER);
        logo.setSize(362, 110);
        sceneStartTime = millis();
        startDrawing();
    }

    public void run() {
        //logo.setFadeTime(600, 200);
        //tipFG = new TipFG("image/parts/tip_demo.png");
    }

    @Override
    protected void manageObjects() {
        float ratio;

        switch(openStep) {
        case 0:
            /********************2.ACTION********************/
            // 背景開始
            background.start();
            /********************3.STEPUP********************/
            stepUp(0);
        case 1:
            /********************1.STANBY********************/
            /*---------------------LOOP---------------------*/
            // 背景が徐々に上昇して覆う
            ratio = calcRatio(stepElapsedTime, 1300);
            manageBackground(0, ratio);
            /*-------------------TRIGGER--------------------*/
            if(ratio < 1.0f) {
                break;
            }
            /********************2.ACTION********************/
            mainScene.nextScene();
            /********************3.STEPUP********************/
            stepUp(0);
        case 2:
            /********************1.STANBY********************/
            /*-------------------TRIGGER--------------------*/
            if(stepElapsedTime < 300) {
                break;
            }
            /********************2.ACTION********************/
            logo.start();
            /********************3.STEPUP********************/
            stepUp(0);
        case 3:
            /********************1.STANBY********************/
            /*---------------------LOOP---------------------*/
            // ロゴのフェードイン
            ratio = calcRatio(stepElapsedTime, 600);
            logo.setColor(color(255), ratio);
            /*-------------------TRIGGER--------------------*/
            if(ratio < 1.0f) {
                break;
            }
            /********************2.ACTION********************/
            /********************3.STEPUP********************/
            stepUp(0);
            /**********************END***********************/
        case 4:
            if(stepElapsedTime > 2000) {
                openStep++;
                stepUp(1);
            }
        }

        switch(closeStep) {
            case 0:
                break;
            case 1: {
                /********************1.STANBY********************/
                /*---------------------LOOP---------------------*/
                // ロゴのフェードアウト
                ratio = calcRatio(stepElapsedTime, 200);
                logo.setColor(color(255), 1.0f - ratio);
                /*-------------------TRIGGER--------------------*/
                if(ratio < 1.0f) {
                    break;
                }
                /********************2.ACTION********************/
                /********************3.STEPUP********************/
                stepUp(1);
            }
            case 2: {
                /********************1.STANBY********************/
                /*---------------------LOOP---------------------*/
                // 背景が徐々に上昇して覆う
                ratio = calcRatio(stepElapsedTime, 400);
                manageBackground(1, ratio);
                /*-------------------TRIGGER--------------------*/
                if(ratio < 1.0f) {
                    break;
                }
                /********************2.ACTION********************/
                nextScene();
                /********************3.STEPUP********************/
                /**********************END***********************/
            }
        }
    }

    private void stepUp(int mode) {
        stepStartTime = millis();
        stepElapsedTime = 0;
        if(mode == 0) {
            openStep++;
        } else {
            closeStep++;
        }
    }

    private void manageBackground(int mode, float ratio) {
        if(mode == 0/*フェードイン*/) {
            ratio = easeInCirc(ratio);
        } else/*フェードアウト*/ {
            ratio = easeOutExpo(ratio);
            ratio = 1.0f - ratio;
        }
        background.setPosition(0, height * (1.0f - ratio), CORNER);
        background.setSize(width, height * ratio);
    }

    @Override
    protected void drawObjects() {
        background.draw();
        logo.draw();
        //tipFG.behavior();
    }

    @Override
    protected Scene nextScene() {
        return new Empty();
    }



    /*
    public class TipFG extends LifeCycleObject {
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
     }*/
}
