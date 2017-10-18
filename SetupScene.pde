private class SetupScene extends Scene {
    private SetupScene() {
        // オブジェクトの生成（順不同）
        final FigureObject background = new FigureObject();
        background.setSize(BASE_WIDTH, BASE_HEIGHT);
        background.enable();

        final TextObject creditTitle = new TextObject();
        creditTitle.setPosition(BASE_WIDTH / 2, 250);
        creditTitle.setText("Project\nCacaomas_Cafe");
        creditTitle.setTextSize(70);
        creditTitle.setFont(font0);
        creditTitle.setColor(color(255));
        creditTitle.setAlign(CENTER, TOP);

        final TextObject creditDetail = creditTitle.clone();
        creditDetail.setPosition(BASE_WIDTH / 2, 450);
        creditDetail.setText("UNDER DEVELOPMENT");
        creditDetail.setTextSize(40);

        final TextObject creditCopyright = creditTitle.clone();
        creditCopyright.setPosition(BASE_WIDTH / 2, 550);
        creditCopyright.setText("©️2017 Jun Koyama");
        creditCopyright.setTextSize(20);

        // レイヤー（描画する順に追加）
        objects = Arrays.asList(background, creditTitle, creditDetail, creditCopyright);

        // グルーピング
        final GroupObject credit = new GroupObject(creditTitle, creditDetail, creditCopyright);
        //credit.setAlpha(0.0f);
        credit.addState("fade", new TweenState(ParameterType.ALPHA)
            .setTween(0.0f, 1.0f, 500)
            .setLoop(0, LoopType.YOYO, 1000));

        // まとめて扱えるようグループ化
        //GroupObject creditTexts = new GroupObject(creditTitle, creditDetail. creditCopyright);

        // シーケンスの生成
        final Sequence creditSequence = new Sequence() {
            @Override
            void executeSchedule() {
                // ！！！注意：50ms以上で判定を行うこと
                switch(keyTime) {
                case 0:
                    credit.enable();
                    break;
                case 1500/*ms*/:
                    credit.startState("fade");
                    break;
                }
                if(keyTime > 4000 && mainScene.hasLoaded() && hasLoaded()) {
                    dispose();
                }
            }
        };
        sequences.put("creditSQ", creditSequence);
        sequences.get("creditSQ").startSequence();
        startScene();
    }
    // バックグラウンド処理はこちら側に書く
    public void run() {
        inputListener = new InputListner();
        minim = new Minim(applet);
        mainScene = new TitleScene();
        hasLoadedMainScene = true;
        inputListener.start();
        //bms = new BmsController();

        //////////////////////////////////////////////////////
        // データベースの設定
        db = new SQLite(applet, "database.db");
        appleChancery = createFont("Apple Chancery", 100, true);
        bickham = createFont("Bickham Script Pro 3", 150, true);
        ayuthaya = createFont("Ayuthaya", 100, true);
        athelas = createFont("Athelas", 100, true);
        baoli = createFont("Baoli SC", 100, true);
    }
    // シーンを抜ける時の処理
    @Override
    protected Scene dispose() {
        mainScene.startScene();
        stopScene();
        return this;
    }
}
