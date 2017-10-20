private class DefaultTransition extends Scene {
    public void run() {
        final SoundFile se = new SoundFile(applet, "sound/se/drip.wav");

        final FigureObject background = new FigureObject();
        background.setColor(color(#553D2A));
        background.setMode(CORNERS);
        background.setPosition2(BASE_WIDTH, BASE_HEIGHT);
        background.addState("enter", new TweenState(ParameterType.POSITION)
            .setTween(0, BASE_HEIGHT, 0, 0, 1300)
            .setEasing(new EasingInCirc()));
        background.addState("exit", new TweenState(ParameterType.POSITION)
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

        objects = Arrays.asList(background, logo);

        sequences.put("enterSQ", new Sequence() {
            @Override
            protected void onProcess() {
                switch(keyTime) {
                case 0:
                    background.startState("enter");
                    se.play();
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
                    mainScene.startScene("enterSQ");
                    background.startState("exit");
                    break;
                case 1500:
                    disposeScene();
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
