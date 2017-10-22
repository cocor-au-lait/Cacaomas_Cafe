private class ModeSelectScene extends Scene {
    private int selectedNum = 1;

    public void run() {
        final GroupObject frame = getFrameGroup("Mode Select");

        final ImageObject circle1 = new ImageObject("image/parts/circle.png");
        circle1.setSize(291, 291);
        circle1.setPosition(495, 166);
        final ImageObject coffee1 = new ImageObject("image/parts/coffee.png");
        coffee1.setSize(208, 208);
        coffee1.setPosition(536, 207);
        final GroupObject modeImage1 = new GroupObject(circle1, coffee1);
        modeImage1.addState("zoomIn", new TweenState(ParameterType.SCALE)
            .setTween(0.0f, 1.0f, 500)
            .setEasing(new EasingOutQuint()));
        modeImage1.addState("rotateIn", new TweenState(ParameterType.ROTATION)
            .setTween(-180.0f, 0.0f, 500)
            .setEasing(new EasingOutQuint()));

        final ImageObject circle2 = circle1.clone();
        circle2.setSize(219, 219);
        circle2.setPosition(172, 202);
        final ImageObject coffee2 = coffee1.clone();
        coffee2.setSize(144, 144);
        coffee2.setPosition(209, 239);
        final GroupObject modeImage2 = new GroupObject(circle2, coffee2);
        modeImage2.setColor(200);

        final GroupObject modeImage3 = modeImage2.clone();
        modeImage3.addPosition(717, 0);

        final ImageObject spinner = new ImageObject("image/parts/spinner.png");
        spinner.setSize(340, 340);
        spinner.setPosition(470, 141);
        spinner.addState("fadeIn",  new TweenState(ParameterType.ALPHA)
            .setTween(0.0f, 1.0f, 200));
        spinner.addState("rotate", new TweenState(ParameterType.ROTATION)
            .setFreakyTween(360.0f, 6000)
            .setLoop(-1, LoopType.RESTART, 0));

        final String[] modeTitleString = {"NormalMode", "Free Mode", "Cource Mode"};
        final String[] modeDetailString = {
            "最大3曲までプレーができるモードです。\n楽曲の解禁も行えます。",
            "制限なしで楽曲がプレーできるモードです。\n解禁済の楽曲がプレー可能です。",
            "決められた3曲をプレーするモードです。\n全曲をクリアすると称号が与えられます。"
        };
        final TextObject modeTitleText = new TextObject(modeTitleString[selectedNum]);
        modeTitleText.setFont(appleChancery);
        modeTitleText.setTextSize(95);
        modeTitleText.setAlign(CENTER, TOP);
        modeTitleText.setPosition(BASE_WIDTH / 2, 477);
        modeTitleText.addState("enter", new TweenState(ParameterType.ALPHA)
            .setTween(0.0f, 1.0f, 400));
        final FigureObject modeTitleLine = new FigureObject();
        modeTitleLine.setSize(498, 3);
        modeTitleLine.setPosition(391, 611);
        modeTitleLine.addState("enter", new TweenState(ParameterType.SIZE)
            .setTween(0, 3, 498, 3, 400)
            .setEasing(new EasingOutQuint()));
        final TextObject modeTitleDetail = new TextObject(modeDetailString[selectedNum]);
        modeTitleDetail.setFont(yuMincho);
        modeTitleDetail.setTextSize(22);
        modeTitleDetail.setAlign(CENTER, TOP);
        modeTitleDetail.setPosition(BASE_WIDTH / 2, 649);
        modeTitleDetail.addState("enter", new TweenState(ParameterType.ALPHA)
            .setTween(0.0f, 1.0f, 400));
        final GroupObject modeTitle = new GroupObject(modeTitleText, modeTitleLine, modeTitleDetail);


        addObjects(frame, modeImage1, modeImage2, modeImage3, new GroupObject(spinner), modeTitle);


        sequences.put("enterSQ", new Sequence() {
            @Override
            protected void onProcess() {
                switch(keyTime) {
                case 0:
                    frame.enableGroup();
                    break;
                case 600:
                    modeImage1.startState("zoomIn", "rotateIn");
                    break;
                case 700:
                    modeImage2.startState("zoomIn", "rotateIn");
                    break;
                case 800:
                    modeImage3.startState("zoomIn", "rotateIn");
                    break;
                case 900:
                    spinner.startState("fadeIn", "rotate");
                    modeTitle.startState("enter");
                }
                if(inputListener.onPressed(6)){}
            }
        });
    }

    @Override
    protected Scene disposeScene() {
        return this;
    }
}
