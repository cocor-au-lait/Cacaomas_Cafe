private class ModeSelectScene extends Scene {
    private int selectedNum = 1;
    private GroupObject spinner;
    private GroupObject[] modeIcon = new GroupObject[3];

    public void run() {
        final GroupObject frame = getFrameGroup("Mode Select");
        // 説明用オブジェクト
        final TextObject hint = new TextObject();
        hint.setText("STARTキーで決定     MILLスクラッチでモード選択");
        hint.setFont(yuGothic);
        hint.setTextSize(15);
        hint.setPosition(80, 756);
        hint.addState("fade", new TweenState(ParameterType.ALPHA)
            .setTween(0.0f, 1.0f, 200));

        final ImageObject circleImage2 = new ImageObject("image/parts/circle.png");
        circleImage2.setSize(309, 309);
        circleImage2.setPosition(486, 158);
        final ImageObject coffeeImage2 = new ImageObject("image/parts/mode1.png");
        coffeeImage2.setSize(200, 200);
        coffeeImage2.setPosition(540, 212);
        final State zoomInIcon = new TweenState(ParameterType.SCALE)
            .setTween(0.0f, 1.0f, 500)
            .setEasing(new EasingOutQuint());
        final State rotateInIcon = new TweenState(ParameterType.ROTATION)
            .setTween(-180.0f, 0.0f, 500)
            .setEasing(new EasingOutQuint());
        final State selectMotion = new TweenState(ParameterType.SCALE)
            .setTween(1.0f, 1.05f, 200)
            .setEasing(new EasingOutCirc())
            .setLoop(0, LoopType.YOYO, 0);
        modeIcon[1] = new GroupObject(circleImage2, coffeeImage2);
        modeIcon[1].addState("zoomIn", zoomInIcon);
        modeIcon[1].addState("rotateIn", rotateInIcon);
        modeIcon[1].addState("selected", selectMotion);

        final ImageObject circleImage1 = circleImage2.clone();
        final ImageObject coffeeImage1 = coffeeImage2.clone();
        coffeeImage1.changeImage("image/parts/mode2.png");
        modeIcon[0] = new GroupObject(circleImage1, coffeeImage1);
        modeIcon[0].addPosition(-359, 0);
        modeIcon[0].setColor(70.0f);
        final State zoomInIconMimi = new TweenState(ParameterType.SCALE)
            .setTween(0.0f, 0.7f, 500)
            .setEasing(new EasingOutQuint());
        modeIcon[0].addState("zoomIn", zoomInIconMimi);
        modeIcon[0].addState("rotateIn", rotateInIcon);
        modeIcon[0].addState("selected", selectMotion);

        final ImageObject circleImage3 = circleImage2.clone();
        final ImageObject coffeeImage3 = coffeeImage2.clone();
        coffeeImage3.changeImage("image/parts/mode3.png");
        modeIcon[2] = new GroupObject(circleImage3, coffeeImage3);
        modeIcon[2].addPosition(359, 0);
        modeIcon[2].setColor(70.0f);
        modeIcon[2].addState("zoomIn", zoomInIconMimi);
        modeIcon[2].addState("rotateIn", rotateInIcon);
        modeIcon[2].addState("selected", selectMotion);


        final ImageObject spinnerImage = new ImageObject("image/parts/spinner.png");
        spinnerImage.setSize(340, 340);
        spinnerImage.setPosition(470, 141);
        spinnerImage.addState("fadeIn",  new TweenState(ParameterType.ALPHA)
            .setTween(0.0f, 1.0f, 200));
        spinnerImage.addState("rotate", new TweenState(ParameterType.ROTATION)
            .setFreakyTween(360.0f, 6000)
            .setLoop(-1, LoopType.RESTART, 0));
        spinnerImage.addState("rotate2", new TweenState(ParameterType.ROTATION)
            .setAdditionalTween(360.0f, 500)
            .setEasing(new EasingOutQuint()));
        spinnerImage.addState("selected", new TweenState(ParameterType.SCALE)
            .setTween(1.0f, 1.1f, 200)
            .setEasing(new EasingOutCirc())
            .setLoop(0, LoopType.YOYO, 0));
        spinner = new GroupObject(spinnerImage);


        final String[] modeTitleString = {"Normal Mode", "Free Mode", "Cource Mode"};
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
        modeTitleLine.setPosition(332, 611);
        modeTitleLine.addState("enter", new TweenState(ParameterType.SIZE)
            .setTween(0, 3, 616, 3, 400)
            .setEasing(new EasingOutQuint()));
        final TextObject modeTitleDetail = new TextObject(modeDetailString[selectedNum]);
        modeTitleDetail.setFont(yuMincho);
        modeTitleDetail.setTextSize(22);
        modeTitleDetail.setAlign(CENTER, TOP);
        modeTitleDetail.setPosition(BASE_WIDTH / 2, 649);
        modeTitleDetail.addState("enter", new TweenState(ParameterType.ALPHA)
            .setTween(0.0f, 1.0f, 400));
        final GroupObject modeTitle = new GroupObject(modeTitleText, modeTitleLine, modeTitleDetail);


        addObjects(frame, modeIcon[0], modeIcon[1], modeIcon[2], spinner, modeTitle,
            new GroupObject(hint));


        sequences.put("enterSQ", new Sequence() {
            @Override
            protected void onProcess() {
                switch(keyTime) {
                case 0:
                    frame.enableGroup();
                    break;
                case 600:
                    modeIcon[0].startState("zoomIn", "rotateIn");
                    break;
                case 700:
                    modeIcon[1].startState("zoomIn", "rotateIn");
                    break;
                case 800:
                    modeIcon[2].startState("zoomIn", "rotateIn");
                    break;
                case 900:
                    spinner.startState("fadeIn", "rotate");
                    modeTitle.startState("enter");
                    hint.startState("fade");
                    for(int i = 0; i < 3; i++) {
                        modeTitleText.setText(modeTitleString[i]);
                        modeTitleDetail.setText(modeDetailString[i]);
                        modeTitleText.drawObject();
                        modeTitleDetail.drawObject();
                    }
                    modeTitleText.setText(modeTitleString[selectedNum]);
                    modeTitleDetail.setText(modeDetailString[selectedNum]);
                    changeSequence(sequences.get("idleSQ"));
                    break;
                }
            }
        });

        sequences.put("idleSQ", new Sequence() {
            @Override
            protected void onStart() {
                subScene = new DefaultTransition("Music Select");
            }
            @Override
            protected void onProcess() {
                if(keyListener.isPressed(5)) {
                    resetSequence();
                    actionOutModeItems();
                    if(keyListener.isScratchStatus(1)) {
                        selectedNum++;
                        selectedNum %= 3;
                    } else if (keyListener.isScratchStatus(-1)) {
                        selectedNum = selectedNum == 0 ? 2 : selectedNum - 1;
                        selectedNum %= 3;
                    }
                    modeTitleText.setText(modeTitleString[selectedNum]);
                    modeTitleDetail.setText(modeDetailString[selectedNum]);
                    modeTitle.startState("enter");
                    actionInModeItems();
                }
                if(keyTime > 600 && keyListener.isPressed(6)) {
                    changeSequence(sequences.get("selectSQ"));
                }
            }
        });

        sequences.put("selectSQ", new Sequence() {
            @Override
            protected void onProcess() {
                switch(keyTime) {
                case 0:
                    spinner.stopState("rotate");
                    spinner.startState("rotate2");
                    spinner.startState("selected");
                    modeIcon[selectedNum].startState("selected");
                    break;
                case 500:
                    subScene.startScene();
                    break;
                }
            }
        });
    }

    private void actionOutModeItems() {
        modeIcon[selectedNum].addState("popColor", new TweenState(ParameterType.COLOR)
            .setFreakyTween(70.0f, 300)
            .setEasing(new EasingOutQuint()));
        modeIcon[selectedNum].addState("popScale", new TweenState(ParameterType.SCALE)
            .setFreakyTween(0.7f, 300)
            .setEasing(new EasingOutQuint()));
        modeIcon[selectedNum].startState("popColor", "popScale");
    }

    private void actionInModeItems() {
        float pos = 0;
        switch(selectedNum) {
        case 0:
            pos = 111;
            break;
        case 1:
            pos = 470;
            break;
        case 2:
            pos = 828;
            break;
        }
        modeIcon[selectedNum].addState("popColor", new TweenState(ParameterType.COLOR)
            .setFreakyTween(100.0f, 300)
            .setEasing(new EasingOutQuint()));
        modeIcon[selectedNum].addState("popScale", new TweenState(ParameterType.SCALE)
            .setFreakyTween(1.0f, 300)
            .setEasing(new EasingOutQuint()));
        modeIcon[selectedNum].startState("popColor", "popScale");

        spinner.addState("move", new TweenState(ParameterType.POSITION)
            .setFreakyTween(pos, 141, 500)
            .setEasing(new EasingOutQuint()));
        spinner.startState("move");
    }

    @Override
    protected Scene disposeScene() {
        return new EntryScene();
    }
}
