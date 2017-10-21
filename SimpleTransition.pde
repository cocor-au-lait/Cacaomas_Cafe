private class SimpleTransition extends Scene {
    private String textString;

    private SimpleTransition(String textString) {
        this.textString = textString;
    }

    public void run() {
        final TextObject mainText = new TextObject(textString);
        mainText.setFont(bickham);
        mainText.setAlign(CENTER, CENTER);
        mainText.setTextSize(200);
        mainText.setPosition(BASE_WIDTH / 2, 350);
        mainText.addState("fadeIn", new TweenState(ParameterType.ALPHA)
            .setTween(0.0f, 1.0f, 300)
            .setEasing(new EasingOutQuint()));
        mainText.addState("zoomIn", new TweenState(ParameterType.SCALE)
            .setTween(0.3f, 1.0f, 500)
            .setEasing(new EasingOutBack()));
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
        background.addState("fadeIn", new TweenState(ParameterType.ALPHA)
            .setFreakyTween(1.0f, 300));
        background.addState("zoomIn", new TweenState(ParameterType.SCALE)
            .setTween(0.0f, 1.0f, 600)
            .setEasing(new EasingInQuint()));

        final FigureObject background2 = background.clone();
        background2.setColor(color(#553D2A));

        final FigureObject background3 = background.clone();

        objects = Arrays.asList(background, background2, background3, mainText);

        sequences.put("enterSQ", new Sequence() {
            @Override
            protected void onProcess() {
                switch(keyTime) {
                case 0:
                    background.startState("fadeIn", "zoomIn");
                    break;
                case 300:
                    background2.startState("fadeIn", "zoomIn");
                    break;
                case 500:
                    background3.startState("fadeIn", "zoomIn");
                    break;
                case 1100:
                    disableObjects(background, background2);
                    mainText.startState("fadeIn", "zoomIn");
                    break;
                case 1600:
                    mainScene = mainScene.disposeScene();
                    changeSequence(sequences.get("idleSQ"));
                    break;
                }
            }
        });

        sequences.put("idleSQ", new Sequence() {
            @Override
            protected void onProcess() {
                if(keyTime > 1000 && mainScene.hasLoaded()) {
                    changeSequence(sequences.get("exitSQ"));
                }
            }
        });

        sequences.put("exitSQ", new Sequence() {
            @Override
            protected void onProcess() {
                switch(keyTime) {
                case 0:
                    mainScene.startScene();
                    mainText.startState("fadeOut", "zoomOut");
                    break;
                case 500:
                    background3.startState("fadeOut");
                    break;
                case 800:
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
