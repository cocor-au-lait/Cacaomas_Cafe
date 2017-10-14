private class SetupScene extends Scene {
    private SetupScene() {
        // オブジェクトの生成（順不同）
        final FigureObject background = new FigureObject();
        background.setSize(BASE_WIDTH, BASE_HEIGHT);

        final TextObject creditTitle = new TextObject();
        creditTitle.setPosition(BASE_WIDTH / 2, (BASE_HEIGHT / 5) * 2);
        creditTitle.setText("Project\nCacaomas_Cafe");
        creditTitle.setTextSize(70);
        creditTitle.setFont(font0);
        creditTitle.setScale(1.0f);
        creditTitle.setColor(color(255));
        creditTitle.setAlpha(0.0f);
        creditTitle.setAlign(CENTER, BASELINE);

        final TextObject creditDetail = creditTitle.clone();
        creditDetail.setPosition(BASE_WIDTH / 2, (BASE_HEIGHT / 5) * 3.4f);
        creditDetail.setText("UNDER DEVELOPMENT");
        creditDetail.setTextSize(40);

        final TextObject creditCopyright = creditTitle.clone();
        creditCopyright.setPosition(BASE_WIDTH / 2, (BASE_HEIGHT / 5) * 4);
        creditCopyright.setText("©️2017 Jun Koyama");
        creditCopyright.setTextSize(20);

        // レイヤー（描画する順に追加）
        objects.add(background);
        objects.add(creditTitle);
        objects.add(creditDetail);
        objects.add(creditCopyright);

        for(GameObject object : objects) {
            object.addState("fade", new TweenState(object, ParameterType.ALPHA)
                .setTween(1.0f, 500)
                .setLoop(0, LoopType.YOYO, 1000));
        }

        // まとめて扱えるようグループ化
        //GroupObject creditTexts = new GroupObject(creditTitle, creditDetail. creditCopyright);

        // シーケンスの生成
        Sequence creditSequence = new Sequence() {
            @Override
            void executeSchedule() {
                // ！！！注意：50ms以上で判定を行うこと
                switch(keyTime) {
                case 0:
                    background.enable();
                    break;
                case 1000/*ms*/:
                    creditTitle.startState("fade");
                    creditDetail.startState("fade");
                    creditCopyright.startState("fade");
                    break;
                case 3500/*ms*/:
                    if(hasLoaded() && mainScene.hasLoaded()) {
                        creditTitle.disable();
                        creditDetail.disable();
                        creditCopyright.disable();
                    }
                    exitSequence();
                }
            }
            @Override
            void onExit() {
                subScene.dispose();
            }
        };
        sequences.add(creditSequence);
        creditSequence.startSequence();
        startScene();
    }
    // バックグラウンド処理はこちら側に書く
    public void run() {
        inputListener = new InputListner();
        inputListener.start();
        //bms = new BmsController();
        minim = new Minim(applet);
        //////////////////////////////////////////////////////
        // データベースの設定
        db = new SQLite(applet, "database.db");
        font1 = createFont("Apple Chancery", 50, true);
        font2 = createFont("Ayuthaya", 50, true);
        mainScene = new TitleScene();
    }
    // シーンを抜ける時の処理
    @Override
    protected Scene dispose() {
        mainScene.startScene();
        subScene = null;
        return this;
    }
}
