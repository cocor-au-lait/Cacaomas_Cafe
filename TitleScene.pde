private class TitleScene extends Scene {
    public void run() {
        final AudioPlayer bgm = minim.loadFile("sound/bgm/title.wav");
        final SoundFile se = new SoundFile(applet, "sound/se/enter.wav");
        // オブジェクト
        final ImageObject logo = new ImageObject();
        logo.setImage("image/parts/black_logo.png");
        logo.setMode(CENTER);
        logo.setPosition(BASE_WIDTH / 2, 200);
        logo.setAlpha(0.0f);
        logo.addState("fade", new TweenState(logo, ParameterType.ALPHA)
            .setTween(1.0f, 500));

        final ImageObject wallpaper = new ImageObject();
        wallpaper.setImage("image/background/title.png");
        wallpaper.setMode(CENTER);
        wallpaper.setPosition(BASE_WIDTH / 2, BASE_HEIGHT / 2);
        wallpaper.setSize(BASE_WIDTH, BASE_HEIGHT);
        //wallpaper.setScale(0.5f);
        wallpaper.setAlpha(0.0f);
        wallpaper.addState("fade", new TweenState(wallpaper, ParameterType.ALPHA)
            .setTween(1.0f, 500));
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
        mainText.setAlpha(0.0f);
        mainText.setAlign(CENTER, TOP);
        mainText.setText("Pless START key to start");
        mainText.setPosition(width / 2, 670);
        mainText.setTextSize(35);
        mainText.addState("flashLoop", new TweenState(mainText, ParameterType.ALPHA)
            .setTween(1.0f, 500)
            .setLoop(-1, LoopType.YOYO, 200));

        // レイヤー
        objects.add(wallpaper);
        objects.add(logo);
        objects.add(mainText);

        // シーケンス（再生順が遅い順）
        final Sequence idleSequence = new Sequence() {
            @Override
            protected void executeSchedule() {
                if(inputListener.onPressed(6)) {
                    se.play();
                    bgm.shiftGain(1, -80, 3000);
                    //subScene = this;
                    exitSequence();
                }
            }
        };
        sequences.add(idleSequence);

        final Sequence openingSequence = new Sequence() {
            @Override
            protected void executeSchedule() {
                switch(keyTime) {
                case 0:
                    wallpaper.startState("fade");
                    break;
                case 1000:
                    logo.startState("fade");
                    mainText.startState("flashLoop");
                    controllable = true;
                    bgm.loop();
                    exitSequence(idleSequence);
                }
            }
        };
        sequences.add(openingSequence);
        openingSequence.startSequence();
    }

    @Override
    protected Scene dispose() {
        return this;
    }
}
