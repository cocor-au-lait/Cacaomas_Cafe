private class EntryScene extends Scene {
    public void run() {
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

        /*final TextObject title = new TextObject();
        title.setText("Enrty");
        title.setFont(bickham);
        title.setTextSize(141);
        title.setAlign(CENTER, TOP);
        title.setPosition(BASE_WIDTH / 2, 0);
        final FigureObject titleLine = new FigureObject();
        titleLine.setPosition(80, 120);
        titleLine.setSize(1120, 3);

        final TextObject information = new TextObject();
        information.setAlpha(0.0f);
        information.setText("#Player Information");
        information.setFont(appleChancery);
        information.setTextSize(48);
        information.setPosition(127, 185);
        information.addState("fade", new TweenState(information, ParameterType.ALPHA)
            .setTween(1.0f, 200));

        final TextObject[] itemTexts = new TextObject[3];
        itemTexts[0] = new TextObject();
        itemTexts[0].setAlpha(0.0f);
        itemTexts[0].setText("Name");
        itemTexts[0].setFont(ayuthaya);
        itemTexts[0].setTextSize(30);
        itemTexts[0].setPosition(544, 307);
        itemTexts[0].addState("fade", new TweenState(itemTexts[0], ParameterType.ALPHA)
            .setTween(1.0f, 200));
        itemTexts[1] = itemTexts[0].clone();
        itemTexts[1].setText("Rank");
        itemTexts[1].setPosition(544, 468);
        itemTexts[1].addState("fade", new TweenState(itemTexts[1], ParameterType.ALPHA)
            .setTween(1.0f, 200));
        itemTexts[2] = itemTexts[0].clone();
        itemTexts[2].setText("Point");
        itemTexts[2].setPosition(829, 468);
        itemTexts[2].addState("fade", new TweenState(itemTexts[2], ParameterType.ALPHA)
            .setTween(1.0f, 200));
        final FigureObject[] itemTextsLine = new FigureObject[3];
        itemTextsLine[0] = new FigureObject();
        itemTextsLine[0].setAlpha(0.0f);
        itemTextsLine[0].setPosition(544.5, 349.5);
        itemTextsLine[0].setSize(72, 2);
        itemTextsLine[0].addState("fade", new TweenState(itemTextsLine[0], ParameterType.ALPHA)
            .setTween(1.0f, 200));
        itemTextsLine[1] = new FigureObject();
        itemTextsLine[1].setAlpha(0.0f);
        itemTextsLine[1].setPosition(544.5, 510.5);
        itemTextsLine[1].setSize(72, 2);
        itemTextsLine[1].addState("fade", new TweenState(itemTextsLine[1], ParameterType.ALPHA)
            .setTween(1.0f, 200));
        itemTextsLine[2] = new FigureObject();
        itemTextsLine[2].setAlpha(0.0f);
        itemTextsLine[2].setPosition(829.5, 510.5);
        itemTextsLine[2].setSize(90, 2);
        itemTextsLine[2].addState("fade", new TweenState(itemTextsLine[2], ParameterType.ALPHA)
            .setTween(1.0f, 200));

        final TextObject playerName = new TextObject();
        playerName.setAlpha(0.0f);
        playerName.setText(pd.getName());
        playerName.setFont(appleChancery);
        playerName.setTextSize(93);
        playerName.setPosition(548, 323);
        playerName.addState("fade", new TweenState(playerName, ParameterType.ALPHA)
            .setTween(1.0f, 200));

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

        final TextObject playerPoint = new TextObject();
        playerPoint.setText(Integer.toString(pd.getPoint()));
        playerPoint.setText(nf(558,6));
        playerPoint.setFont(baoli);
        playerPoint.setTextSize(65);
        playerPoint.setPosition(829, 498);

        final ImageObject card = new ImageObject();
        card.setAlpha(0.0f);
        card.setImage("image/parts/card1.png");
        card.setMode(CENTER);
        card.setPosition(BASE_WIDTH / 2, 415);
        card.addState("fade", new TweenState(card, ParameterType.ALPHA)
            .setTween(1.0f, 200));

        final ImageObject icon = new ImageObject();
        icon.setImage("image/parts/icon1.png");
        icon.setMode(CENTER);
        icon.setPosition(301, 445);

        // オープニング用
        final TextObject opTitle = title.clone();
        opTitle.setAlign(CENTER, CENTER);
        opTitle.setTextSize(200);
        opTitle.setAlpha(0.0f);
        opTitle.setScale(0.2f);
        opTitle.setPosition(BASE_WIDTH / 2, 350);
        opTitle.addState("fadeIn", new TweenState(opTitle, ParameterType.ALPHA)
            .setTween(1.0f, 300));
        opTitle.addState("zoomIn", new TweenState(opTitle, ParameterType.SCALE)
            .setTween(1.0f, 500));
        opTitle.addState("fadeOut", new TweenState(opTitle, ParameterType.ALPHA)
            .setTween(0.0f, 300));
        opTitle.addState("zoomOut", new TweenState(opTitle, ParameterType.SCALE)
            .setTween(3.0f, 300));

        final FigureObject opBG = new FigureObject();
        opBG.setColor(color(#FFF7DE));
        opBG.setSize(BASE_WIDTH, BASE_HEIGHT);
        opBG.addState("fadeOut", new TweenState(opBG, ParameterType.ALPHA)
            .setTween(0.0f, 300));

        objects = Arrays.asList(title, titleLine, card,
            information, itemTexts[0], itemTexts[1], itemTexts[2],
            itemTextsLine[0], itemTextsLine[1], itemTextsLine[2],
            playerName, playerRank, playerPoint, icon, opBG, opTitle);


        sequences.put("opening", new Sequence() {
            @Override
            protected void executeSchedule() {
                switch(keyTime) {
                case 0:
                    opBG.enable();
                    break;
                case 500:
                    opTitle.startState("fadeIn", "zoomIn");
                    break;
                case 2000:
                    opTitle.startState("fadeOut", "zoomOut");
                    break;
                case 2500:
                    enableObjects(title, titleLine, card,
                        information, itemTexts[0], itemTexts[1], itemTexts[2],
                        itemTextsLine[0], itemTextsLine[1], itemTextsLine[2],
                        playerName, playerRank, playerPoint, icon);
                    opBG.startState("fadeOut");
                }
            }
        });
        sequences.get("opening").startSequence();*/
    }

    @Override
    protected Scene dispose() {
        return this;
    }
}
