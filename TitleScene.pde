private class TitleScene extends Scene {
    private int openStep;
    private AudioPlayer bgm;
    private SoundFile se;
    private RotateFigureObject[] rotater;
    private ImageObject logo, wallpaper;
    private LoopFadeTextObject mainText;

    public void run() {
        bgm = minim.loadFile("sound/bgm/title.wav");
        se = new SoundFile(applet, "sound/se/enter.wav");
        logo = new ImageObject("image/parts/black_logo.png");
        logo.setPosition(width / 2, 200, CENTER);
        rotater = new RotateFigureObject[5];
        rotater[0] = new RotateFigureObject(0.22f, LEFT);
        rotater[0].setPosition(162, 96);
        rotater[0].setSize(322, 322);
        rotater[1] = new RotateFigureObject(0.2f, RIGHT);
        rotater[1].setPosition(52, 372);
        rotater[1].setSize(256, 256);
        rotater[2] = new RotateFigureObject(0.15f, RIGHT);
        rotater[2].setPosition(578, -87);
        rotater[2].setSize(390, 390);
        rotater[3] = new RotateFigureObject(0.25f, RIGHT);
        rotater[3].setPosition(934, 270);
        rotater[3].setSize(183, 183);
        rotater[4] = new RotateFigureObject(0.19f, RIGHT);
        rotater[4].setPosition(980, 490);
        rotater[4].setSize(236, 236);
        mainText = new LoopFadeTextObject("pless ENTER/START key to start");
        mainText.setFadeTime(1000);
        mainText.setColor(color(0), 0);
        mainText.setFont(font0);
        mainText.setPosition(width / 2, 670, CENTER);
        mainText.setSize(35);
        wallpaper = new ImageObject("image/background/title.png");
        startDrawing();
    }

    @Override
    protected void manageObjects() {
        float ratio;

        switch(openStep) {
        case A:
            /********************2.ACTION********************/
            // 読み込みが終わったら起動する
            wallpaper.start();
            /********************3.STEPUP********************/
            stepUp();
        case 1:
            /********************1.STANBY********************/
            /*---------------------LOOP---------------------*/
            // 背景がフェードイン
            ratio = calcRatio(stepElapsedTime, 700);
            wallpaper.setColor(color(255), ratio);

            /*-------------------TRIGGER--------------------*/
            if(ratio < 1.0f) {
                break;
            }
            /********************2.ACTION********************/
            /********************3.STEPUP********************/
            stepUp();
        case 2:
            /********************1.STANBY********************/
            /*-------------------TRIGGER--------------------*/
            if(stepElapsedTime < 300) {
                break;
            }
            /********************2.ACTION********************/
            // ロゴと回る図形の描画開始
            logo.start();
            for(int i = 0; i < rotater.length; i++) {
                rotater[i].start();
            }
            bgm.loop();
            /********************3.STEPUP********************/
            stepUp();
        case 3:
            /********************1.STANBY********************/
            /*---------------------LOOP---------------------*/
            // ロゴと図形がフェードイン
            ratio = calcRatio(stepElapsedTime, 300);
            logo.setColor(color(255), ratio);
            for(int i = 0; i < rotater.length; i++) {
                rotater[i].setColor(color(20), ratio);
            }
            /*-------------------TRIGGER--------------------*/
            if(ratio < 1.0f) {
                break;
            }
            /********************2.ACTION********************/
            // テキスト描画開始 & 操作受け付け開始
            controllable = true;
            mainText.start();
            /********************3.STEPUP********************/
            stepUp();
            /**********************END***********************/
        }

        if(controllable && inputListener.getPress(6)) {
            controllable = false;
            // 画面遷移を起動して後処理をする
            bgm.shiftGain(1, -80, 3000);
            transitionScene = new DefaultTransition();
        }
    }

    private void stepUp() {
        stepStartTime = millis();
        stepElapsedTime = 0;
        openStep++;
    }

    @Override
    protected void drawObjects() {
        // 下の層から順番に描画（オブジェクトが起動していない場合は何も起こらない）
        wallpaper.draw();
        for(int i = 0; i < rotater.length; i++) {
            rotater[i].draw();
        }
        // テキストの座標を変えるコード

        logo.draw();
        mainText.draw();

    }

    @Override
    protected Scene nextScene() {
        //return new EnrtyScene();
        return this;
    }

    /*private class Wallpaper extends LifeCycleObject {
        private PImage wallpaper = loadImage("image/background/title.png");
        private int fadeTime = 1000;
        private boolean canDrawNextObject;

        protected void drawObject() {
            float ratio = calcRatio(phaseElapsedTime, fadeTime);
            if(ratio > 1.0f) {
                canDrawNextObject = true;
            }
            ratio = easeOutBack(ratio);
            float alpha = ratio * 255;
            colorMode(ADD);
            tint(255, alpha);
            imageMode(CENTER);
            image(wallpaper, width / 2, height / 2, width * ratio, height * ratio);
            noTint();
            colorMode(BLEND);
        }

        private boolean canDrawNextObject() {
            return canDrawNextObject;
        }
    }*/
}
