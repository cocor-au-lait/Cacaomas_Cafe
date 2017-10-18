private class TitleScene extends Scene {
    public void run() {
        final AudioPlayer bgm = minim.loadFile("sound/bgm/title.wav");
        final SoundFile se = new SoundFile(applet, "sound/se/enter.mp3");
        se.amp(0.5f);
        // オブジェクト
        final ImageObject logo = new ImageObject();
        logo.setImage("image/parts/black_logo.png");
        logo.setMode(CENTER);
        logo.setPosition(BASE_WIDTH / 2, 200);
        logo.addState("fade", new TweenState(logo, ParameterType.ALPHA)
            .setTween(0.0f, 1.0f, 500));

        final ImageObject wallpaper = new ImageObject();
        wallpaper.setImage("image/background/title.png");
        wallpaper.setMode(CENTER);
        wallpaper.setPosition(BASE_WIDTH / 2, BASE_HEIGHT / 2);
        //wallpaper.setScale(0.5f);
        wallpaper.addState("fade", new TweenState(wallpaper, ParameterType.ALPHA)
            .setTween(0.0f, 1.0f, 500));
        /*
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
        */
        final TextObject mainText = new TextObject();
        mainText.setFont(font0);
        mainText.setColor(color(0));
        mainText.setAlign(CENTER, TOP);
        mainText.setText("Pless START key to start");
        mainText.setPosition(BASE_WIDTH / 2, 670);
        mainText.setTextSize(35);
        mainText.addState("flashLoop", new TweenState(mainText, ParameterType.ALPHA)
            .setTween(0.0f, 1.0f, 500)
            .setLoop(-1, LoopType.YOYO, 200));

        final FigureObject circle = new FigureObject();
        circle.setCornerNum(0);
        circle.setBlend(ADD);
        circle.setColor(color(40));
        circle.setSize(100, 100);
        circle.setMode(CENTER);
        circle.addState("loop", new TweenState(circle, ParameterType.POSITION)
            .setTween(100, 100, 1000, 500, 3000)
            .setLoop(-1, LoopType.YOYO, 0)
            .setEasing(new EasingInOutCirc()));

        // レイヤー
        objects = Arrays.asList(wallpaper, circle, logo, mainText);

        // シーケンス
        final Sequence enterSequence = new Sequence() {
            @Override
            protected void executeSchedule() {
                switch(keyTime) {
                case 0:
                    wallpaper.startState("fade");
                    break;
                case 1000:
                    circle.startState("loop");
                    logo.startState("fade");
                    mainText.startState("flashLoop");
                    //controllable = true;
                    bgm.loop();
                    exitSequence(sequences.get("idleSQ"));
                    break;
                }
            }
        };
        sequences.put("enterSQ", enterSequence);

        final Sequence idleSequence = new Sequence() {
            @Override
            protected void onStart() {
                subScene = new DefaultTransition();
            }
            @Override
            protected void executeSchedule() {
                if(inputListener.onPressed(6)) {
                    se.play();
                    bgm.shiftGain(1, -80, 3000);
                    subScene.startScene();
                    exitSequence();
                }
            }
        };
        sequences.put("idleSQ", idleSequence);

        enterSequence.startSequence();
    }

    @Override
    protected Scene dispose() {
        bgScene.startScene();
        return new EntryScene();
    }
}
