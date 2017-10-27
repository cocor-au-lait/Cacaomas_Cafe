private class TitleScene extends Scene {
    public void run() {
        //final AudioPlayer bgm = minim.loadFile("sound/bgm/title.wav");
        //final SoundFile se = new SoundFile(applet, "sound/se/enter.mp3");
        //se.amp(0.5f);
        // オブジェクト
        final ImageObject logo = new ImageObject("image/parts/black_logo.png");
        logo.setMode(CENTER);
        logo.setPosition(BASE_WIDTH / 2, 200);
        logo.addState("fade", new TweenState(ParameterType.ALPHA)
            .setTween(0.0f, 1.0f, 500));

        final ImageObject wallpaper = new ImageObject("image/background/title.png");
        wallpaper.setMode(CENTER);
        wallpaper.setPosition(BASE_WIDTH / 2, BASE_HEIGHT / 2);
        wallpaper.addState("fade", new TweenState(ParameterType.ALPHA)
            .setTween(0.0f, 1.0f, 500));

        final TextObject mainText = new TextObject("Pless START key to start");
        mainText.setFont(font0);
        mainText.setColor(color(0.0f));
        mainText.setAlign(CENTER, TOP);
        mainText.setPosition(BASE_WIDTH / 2, 670);
        mainText.setTextSize(35);
        mainText.addState("flashLoop", new TweenState(ParameterType.ALPHA)
            .setTween(0.0f, 1.0f, 500)
            .setLoop(-1, LoopType.YOYO, 200));

        final FigureObject circle = new FigureObject();
        circle.setCornerNum(0);
        circle.setBlend(ADD);
        circle.setColor(color(12.0f));
        circle.setSize(100, 100);
        circle.setMode(CENTER);
        circle.addState("loop", new TweenState(ParameterType.POSITION)
            .setTween(100, 100, 1000, 500, 3000)
            .setLoop(-1, LoopType.YOYO, 0)
            .setEasing(new EasingInOutCirc()));

        // レイヤー
        objects = Arrays.asList(wallpaper, circle, logo, mainText);

        // シーケンス
        sequences.put("enterSQ", new Sequence() {
            @Override
            protected void onProcess() {
                switch(keyTime) {
                case 0:
                    subScene = new DefaultTransition("Entry");
                    wallpaper.startState("fade");
                    break;
                case 1000:
                    circle.startState("loop");
                    logo.startState("fade");
                    mainText.startState("flashLoop");
                    //controllable = true;
                    //bgm.loop();
                    break;
                case 1300:
                    changeSequence(sequences.get("idleSQ"));
                    break;
                }
            }
        });

        sequences.put("idleSQ", new Sequence() {
            @Override
            protected void onProcess() {
                if(keyListener.isPressed(6)) {
                    //se.play();
                    //bgm.shiftGain(1, -80, 3000);
                    subScene.startScene();
                    stopSequence();
                }
            }
        });
    }

    @Override
    protected Scene disposeScene() {
        bgScene.startScene("idleSQ");
        return new MusicSelectScene();
    }
}
