private class DefaultTransition extends Scene {
    public void run() {
        final SoundFile se = new SoundFile(applet, "sound/se/drip.wav");

        final FigureObject background = new FigureObject();
        background.setColor(color(#553D2A));
        background.setMode(CORNERS);
        background.setPosition(0, BASE_HEIGHT);
        background.setSize(BASE_WIDTH, BASE_HEIGHT);
        background.addState("enter", new TweenState(background, ParameterType.POSITION)
            .setTween(0, 0, 1300)
            .setEasing(new EasingInCirc()));
        background.addState("exit", new TweenState(background, ParameterType.POSITION)
            .setTween(0, BASE_HEIGHT, 400)
            .setEasing(new EasingOutExpo()));

        final ImageObject logo = new ImageObject();
        logo.setImage("image/parts/white_logo.png");
        logo.setMode(CORNER);
        logo.setPosition(880, 660);
        logo.setSize(362, 110);
        logo.setAlpha(0.0f);
        logo.setScale(3.0f);
        logo.addState("fadeInA", new TweenState(logo, ParameterType.ALPHA)
            .setTween(1.0f, 400)
            .setEasing(new EasingOutExpo()));
        logo.addState("fadeInS", new TweenState(logo, ParameterType.SCALE)
            .setTween(1.0f, 400)
            .setEasing(new EasingOutExpo()));
        logo.addState("fadeOutA", new TweenState(logo, ParameterType.ALPHA)
            .setTween(0.0f, 200));

        objects.add(background);
        objects.add(logo);

        sequences.put("enterSQ", new Sequence() {
            @Override
            protected void executeSchedule() {
                switch(keyTime) {
                case 0:
                    background.startState("enter");
                    se.play();
                    break;
                case 1300:
                    mainScene = mainScene.dispose();
                    break;
                case 1500:
                    logo.startState("fadeInA");
                    logo.startState("fadeInS");
                    exitSequence(sequences.get("idleSQ"));
                    break;
                }
            }
        });

        sequences.put("idleSQ", new Sequence() {
            @Override
            protected void executeSchedule() {
                if(keyTime > 3000 && mainScene.hasLoaded()) {
                    exitSequence(sequences.get("exitSQ"));
                }
            }
        });

        sequences.put("exitSQ", new Sequence() {
            @Override
            protected void executeSchedule() {
                switch(keyTime) {
                case 0:
                    logo.startState("fadeOutA");
                    break;
                case 300:
                    mainScene.startScene();
                    background.startState("exit");
                    break;
                case 500:
                    dispose();
                }
            }
        });
        sequences.get("enterSQ").startSequence();
    }

    @Override
    protected Scene dispose() {
        subScene = null;
        return this;
    }
}
