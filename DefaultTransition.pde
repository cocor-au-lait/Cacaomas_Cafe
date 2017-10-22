private class DefaultTransition extends Scene {
    private String textString;

    private DefaultTransition(String textString) {
        this.textString = textString;
    }


    public void run() {
        //final SoundFile se = new SoundFile(applet, "sound/se/drip.wav");

        final FigureObject dripLiquid = new FigureObject();
        dripLiquid.setColor(color(#553D2A));
        dripLiquid.setMode(CORNERS);
        dripLiquid.setPosition2(BASE_WIDTH, BASE_HEIGHT);
        dripLiquid.addState("enter", new TweenState(ParameterType.POSITION)
            .setTween(0, BASE_HEIGHT, 0, 0, 1300)
            .setEasing(new EasingInCirc()));
        dripLiquid.addState("exit", new TweenState(ParameterType.POSITION)
            .setFreakyTween(0, BASE_HEIGHT, 800)
            .setEasing(new EasingOutExpo()));

        final ImageObject logo = new ImageObject("image/parts/white_logo.png");
        logo.setMode(CORNER);
        logo.setPosition(880, 660);
        logo.setSize(362, 110);
        logo.addState("fadeInA", new TweenState(ParameterType.ALPHA)
            .setTween(0.0f, 1.0f, 400));
        logo.addState("fadeInS", new TweenState(ParameterType.SCALE)
            .setTween(2.0f, 1.0f, 400)
            .setEasing(new EasingOutExpo()));
        logo.addState("fadeOutA", new TweenState(ParameterType.ALPHA)
            .setFreakyTween(0.0f, 200));

        final TextObject mainText = new TextObject(textString);
        mainText.setFont(bickham);
        mainText.setAlign(CENTER, CENTER);
        mainText.setTextSize(200);
        mainText.setPosition(BASE_WIDTH / 2, 350);
        mainText.addState("fadeIn", new TweenState(ParameterType.ALPHA)
            .setTween(0.0f, 1.0f, 300)
            .setEasing(new EasingOutQuint()));
        mainText.addState("zoomIn", new TweenState(ParameterType.SCALE)
            .setTween(0.3f, 1.0f, 600)
            .setEasing(new EasingOutQuint()));
        mainText.addState("fadeOut", new TweenState(ParameterType.ALPHA)
            .setFreakyTween(0.0f, 300)
            .setEasing(new EasingInQuint()));
        mainText.addState("zoomOut", new TweenState(ParameterType.SCALE)
            .setFreakyTween(2.0f, 300)
            .setEasing(new EasingInQuint()));

        final FigureObject background = new FigureObject();
        background.setCornerNum(0);
        background.setMode(CENTER);
        background.setColor(color(#FBF0CF));
        background.setPosition(BASE_WIDTH / 2, BASE_HEIGHT / 2);
        background.setSize(BASE_WIDTH * 2, BASE_WIDTH * 2);
        background.addState("fadeOut", new TweenState(ParameterType.ALPHA)
            .setFreakyTween(0.0f, 300));
        background.addState("zoomIn", new TweenState(ParameterType.SCALE)
            .setTween(0.0f, 1.0f, 500)
            .setEasing(new EasingInQuint()));

        final FigureObject background2 = background.clone();
        background2.setColor(color(#553D2A));

        final FigureObject background3 = background.clone();


        objects = Arrays.asList(background, background2, background3, mainText, dripLiquid, logo);

        sequences.put("enterSQ", new Sequence() {
            @Override
            protected void onProcess() {
                switch(keyTime) {
                case 0:
                    dripLiquid.startState("enter");
                    //se.play();
                    break;
                case 1300:
                    mainScene = mainScene.disposeScene();
                    break;
                case 1500:
                    logo.startState("fadeInA");
                    logo.startState("fadeInS");
                    changeSequence(sequences.get("idleSQ"));
                    break;
                }
            }
        });

        sequences.put("idleSQ", new Sequence() {
            @Override
            protected void onProcess() {
                if(keyTime > 3000 && mainScene.hasLoaded()) {
                    changeSequence(sequences.get("exitSQ"));
                }
            }
        });

        sequences.put("exitSQ", new Sequence() {
            @Override
            protected void onProcess() {
                switch(keyTime) {
                case 0:
                    logo.startState("fadeOutA");
                    break;
                case 300:
                    background.enableObject();
                    dripLiquid.startState("exit");
                    break;
                case 700:
                    mainText.startState("fadeIn", "zoomIn");
                    break;
                case 2200:
                    mainText.startState("fadeOut", "zoomOut");
                    break;
                case 2300:
                    background2.startState("zoomIn");
                    break;
                case 3000:
                    mainScene.startScene();
                    background.disableObject();
                    background2.startState("fadeOut");
                    break;
                case 3500:
                    disposeScene();
                    break;
                }
            }
        });
    }

    @Override
    protected Scene disposeScene() {
        stopScene();
        return this;
    }
}
