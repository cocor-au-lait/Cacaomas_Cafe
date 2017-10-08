private class SetupScene extends Scene {
    //private TextObject[] credit;
    //private int step;

    private SetupScene() {
        // 「creditTitle」という名前の空のゲームオブジェクトの作成（何も描画されない）
        objects.put("creditTitle", new GameObject());
        // テキスト描画用のコンポーネントを作成して初期値を設定し、実装
        objects.get("creditTitle").addComponent("Text", new TextComponent()
            .setText("Project\nCacaomas_Cafe")
            .setFont(font0)
            .setColor(color(255), 0.0f)
            .setTextSize(70)));
        // デフォルトで実装されているコンポーネントの値を編集
        objects.get("creditTitle").getComponent("Transform")
            .setPosition(WIDTH / 2, (HEIGHT / 5) * 2));

        objects.put("creditDetail", new GameObject()
            .setPosition(WIDTH / 2, (HEIGHT / 5) * 3.4f, CENTER));
        objects.get("creditDetail").addComponent("text", new TextComponent()
            .setText("UNDER DEVELOPMENT")
            .setFont(font0)
            .setTextSize(70));

        objects.put("creditTitle", new TextObject());
        objects.get("creditTitle").setGroupId(0);
        objects.get("creditTitle").setString("Project\nCacaomas_Cafe");
        objects.get("creditTitle").setPosition(WIDTH / 2, (HEIGHT / 5) * 2);
        objects.get("creditTitle").setSize(70);

        objects.put("creditDetail", new TextObject());
        objects.get("creditDetail").setGroupId(0);
        objects.get("creditDetail").setString("UNDER DEVELOPMENT");
        objects.get("creditDetail").setPosition(WIDTH / 2, (HEIGHT / 5) * 3.4f, CENTER);
        objects.get("creditDetail").setSize(40);

        objects.put("creditCopyright", new TextObject());
        objects.get("creditCopyright").setGroupId(0);
        objects.get("creditCopyright").setString("©️2017 Jun Koyama");
        objects.get("creditCopyright").setPosition(WIDTH / 2, (HEIGHT / 5) * 4, CENTER);
        objects.get("creditCopyright").setSize(20);

        for (Map.Entry<String, GameObject> entry : objects.entrySet()) {
            if(entry.getValue().getGroupId == 0) {
                entry.getValue().setColor(255);
            }
        }
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
    }

    @Override
    protected void manageObjects() {
        float ratio;

        switch(step) {
        case 0:
            /********************1.STANBY********************/
            /*-------------------TRIGGER--------------------*/
            // 0.5秒未満なら待機
            if(sceneElapsedTime < 500) {
                break;
            }
            /********************2.ACTION********************/
            // クレジットキャッシュ　&& 表記開始
            for(int i = 0; i < credit.length; i++) {
                credit[i].run();
                credit[i].start();
            }
            /********************3.STEPUP********************/
            stepUp();
        case 1:
            /********************1.STANBY********************/
            /*---------------------LOOP---------------------*/
            // クレジット表記がフェードイン
            ratio = calcRatio(stepElapsedTime, 400);    //0.0f~1.0fまで算出
            for(int i = 0; i < credit.length; i++) {
                credit[i].setColor(color(255), ratio);
            }
            /*-------------------TRIGGER--------------------*/
            // フェードインが終わるまで待機
            if(ratio < 1.0f) {
                break;
            }
            /********************2.ACTION********************/
            /********************3.STEPUP********************/
            stepUp();
        case 2:
            /********************1.STANBY********************/
            /*-------------------TRIGGER--------------------*/
            // 特定時間かリソース読み込み完了でないなら待機
            if(stepElapsedTime < 700 || !hasLoaded()) {
                break;
            }
            /********************2.ACTION********************/
            /********************3.STEPUP********************/
            stepUp();
        case 3:
            /********************1.STANBY********************/
            /*---------------------LOOP---------------------*/
            // クレジット表記フェードアウト
            ratio = calcRatio(stepElapsedTime, 400);    //0.0f~1.0fまで算出
            for(int i = 0; i < credit.length; i++) {
                credit[i].setColor(color(255), 1.0f - ratio);       // 比率を反転
            }
            /*-------------------TRIGGER--------------------*/
            // クレジット表記が消えていなければ待機
            if(ratio < 1.0f) {
                break;
            }
            /********************2.ACTION********************/
            // 次の画面に切り替え
            mainScene = nextScene();
            /********************3.STEPUP********************/
            stepUp();
            /**********************END***********************/
        }
    }

    private void stepUp() {
        stepStartTime = millis();
        stepElapsedTime = 0;
        step++;
    }

    /*
    @Override
    protected void drawObjects() {
        background(0);
        for(int i = 0; i < credit.length; i++) {
            credit[i].draw();
        }
    }*

    @Override
    protected Scene nextScene() {
        return new TitleScene();
    }*/
}
