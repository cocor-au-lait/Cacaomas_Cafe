private class EntryScene extends Scene {
    public void run() {
        final TextObject titleText = new TextObject("Enrty");
        titleText.setFont(bickham);
        titleText.setTextSize(141);
        titleText.setAlign(CENTER, TOP);
        titleText.setPosition(BASE_WIDTH / 2, 0);
        final FigureObject titleTextLine = new FigureObject();
        titleTextLine.setPosition(80, 120);
        titleTextLine.setSize(1120, 3);
        // 説明用オブジェクト
        final TextObject hint = new TextObject();
        hint.setText("STARTキーで決定     OPTIONキーでプレーヤー選択画面");
        hint.setFont(yuGothic);
        hint.setTextSize(15);
        hint.setPosition(80, 756);
        hint.addState("fade", new TweenState(ParameterType.ALPHA)
            .setTween(0.0f, 1.0f, 200));
        final GroupObject frame = new GroupObject(titleText, titleTextLine);

        // プレーヤーデータ
        final ArrayList<PlayerData> playerData = new ArrayList<PlayerData>();
        if(!db.connect()) {
            println("Error:Can't connect to database");
            exit();
        }
        // データベースからプレーヤーデータを収集
        // ###現在ハリボテ状態
        db.query("select * from PlayerTable where player_id = 1");
        PlayerData pd = new PlayerData();
        playerData.add(pd);
        pd.setPlayerId(db.getInt("player_id"));
        pd.setName(db.getString("name"));
        pd.setIcon(db.getInt("icon"));
        pd.setHighspeed(db.getString("highspeed"));
        pd.setPoint(db.getInt("point"));
        pd.setRank(db.getInt("rank"));
        db.close();

        final TextObject information = new TextObject("#Player Information");
        information.setFont(appleChancery);
        information.setTextSize(48);
        information.setPosition(127, 185);

        final TextObject[] itemTexts = new TextObject[3];
        itemTexts[0] = new TextObject("Name");
        itemTexts[0].setFont(ayuthaya);
        itemTexts[0].setTextSize(30);
        itemTexts[0].setPosition(544, 307);
        itemTexts[1] = itemTexts[0].clone();
        itemTexts[1].setText("Rank");
        itemTexts[1].setPosition(544, 468);
        itemTexts[2] = itemTexts[0].clone();
        itemTexts[2].setText("Point");
        itemTexts[2].setPosition(829, 468);
        final FigureObject[] itemTextsLine = new FigureObject[3];
        itemTextsLine[0] = new FigureObject();
        itemTextsLine[0].setPosition(544.5, 349.5);
        itemTextsLine[0].setSize(72, 2);
        itemTextsLine[1] = new FigureObject();
        itemTextsLine[1].setPosition(544.5, 510.5);
        itemTextsLine[1].setSize(72, 2);
        itemTextsLine[2] = new FigureObject();
        itemTextsLine[2].setPosition(829.5, 510.5);
        itemTextsLine[2].setSize(90, 2);

        final TextObject playerName = new TextObject(pd.getName());
        playerName.setFont(appleChancery);
        playerName.setTextSize(93);
        playerName.setPosition(548, 323);
        playerName.addState("fade", new TweenState(ParameterType.ALPHA)
            .setTween(0.0f, 1.0f, 200));

        final TextObject playerRank = new TextObject();
        String rankName;
        switch(pd.getRank()) {
        default:
            rankName = "Rookie";
        }
        playerRank.setText(rankName);
        playerRank.setFont(athelas);
        playerRank.setTextSize(65);
        playerRank.setPosition(548, 510);
        playerRank.addState("fade", new TweenState(ParameterType.ALPHA)
            .setTween(0.0f, 1.0f, 200));

        final TextObject playerPoint = new TextObject();
        playerPoint.setText(Integer.toString(pd.getPoint()));
        playerPoint.setText(nf(558,6));
        playerPoint.setFont(baoli);
        playerPoint.setTextSize(65);
        playerPoint.setPosition(829, 498);
        playerPoint.addState("fade", new TweenState(ParameterType.ALPHA)
            .setTween(0.0f, 1.0f, 200));

        final ImageObject cardImage = new ImageObject("image/parts/card1.png");
        cardImage.setMode(CENTER);
        cardImage.setPosition(BASE_WIDTH / 2, 415);

        final ImageObject playerIcon = new ImageObject("image/parts/icon1.png");
        playerIcon.setMode(CENTER);
        playerIcon.setPosition(301, 445);
        playerIcon.addState("fade", new TweenState(ParameterType.ALPHA)
            .setTween(0.0f, 1.0f, 200));
        // カードの画像、各文字をグルーピング
        final GroupObject card = new GroupObject(cardImage, information,
            itemTexts[0], itemTexts[1], itemTexts[2],
            itemTextsLine[0], itemTextsLine[1], itemTextsLine[2]);
        card.addPosition(-1200, 0);
        card.addState("slideIn", new TweenState(ParameterType.POSITION)
            .setAdditionalTween(1200, 0, 900)
            .setEasing(new EasingOutQuint()));
        // カードに記載された情報を全てグルーピング
        final GroupObject playerCard = new GroupObject(playerIcon, playerName,
            playerRank, playerPoint);
        playerCard.jointGroup(card);
        playerCard.addState("slideOut", new TweenState(ParameterType.POSITION)
            .setAdditionalTween(1200, 0, 900)
            .setEasing(new EasingOutQuint()));


        addObjects(frame, playerCard, new GroupObject(hint));


        sequences.put("enterSQ", new Sequence() {
            @Override
            protected void onProcess() {
                switch(keyTime) {
                case 0:
                    bgScene.startScene("idleSQ");
                    frame.enableGroup();
                    break;
                case 600:
                    card.startState("slideIn");
                    break;
                case 1500:
                    changeSequence(sequences.get("playerSQ"));
                    break;
                }
            }
        });

        sequences.put("playerSQ", new Sequence() {
            @Override
            protected void onProcess() {
                switch(keyTime) {
                case 0:
                    playerIcon.startState("fade");
                    break;
                case 100:
                    playerName.startState("fade");
                    break;
                case 200:
                    playerRank.startState("fade");
                    break;
                case 300:
                    playerPoint.startState("fade");
                    break;
                case 600:
                    changeSequence(sequences.get("idleSQ"));
                    break;
                }
            }
        });

        sequences.put("idleSQ", new Sequence() {
            @Override
            protected void onStart() {
                hint.startState("fade");
                subScene = new SimpleTransition("Mode Select");
            }
            @Override
            protected void onProcess() {
                if(keyListener.isPressed(6)) {
                    changeSequence(sequences.get("cardExitSQ"));
                }
            }
        });

        sequences.put("cardExitSQ", new Sequence() {
            @Override
            protected void onProcess() {
                switch(keyTime) {
                case 0:
                    playerCard.startState("slideOut");
                    break;
                case 600:
                    subScene.startScene();
                }
            }
        });
    }

    @Override
    protected Scene disposeScene() {
        return new ModeSelectScene();
    }
}
