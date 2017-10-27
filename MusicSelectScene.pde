private class MusicSelectScene extends Scene {
    private String[] sortString = {"Title Sort", "Artist Sort", "Level Sort"};
    private List<MusicData> musicData = new ArrayList<MusicData>();
    private List<GroupObject> musicGroup = new ArrayList<GroupObject>();
    private GroupObject musicBracket, levelBracket;
    private TextObject[] levelTexts = new TextObject[3];
    private TextObject scoreText;
    private int selectedNum;
    private int selectedLevel;

    public void run() {
        // ###ハリボテ
        musicData.add(new MusicData("European Dance", "never", "", 3, 6, 9, 120,
            0, 0, 0, 934050, 857394, 395868));
        musicData.add(new MusicData("印度華麗", "never", "", 2, 5, 7, 120,
            0, 0, 0, 1000000, 395960, 859493));
        musicData.add(new MusicData("Chinese Afternoon", "never", "", 2, 6, 9, 120,
            0, 0, 0, 839495, 847568, 938402));
        musicData.add(new MusicData("banana au lait", "chocolat au lait", "", 1, 4, 7,
            130, 0, 0, 0, 958373, 958474, 857483));
        musicData.add(new MusicData("Midnight Sky “Milkyway”", "cocoa", "", 1, 4, 8, 120,
            0, 0, 0, 399483, 938475, 857693));

        musicGroup.add(getMusicGroup(musicData.get(0), 0));
        musicGroup.add(getMusicGroup(musicData.get(1), 1));
        musicGroup.add(getMusicGroup(musicData.get(2), 2));
        musicGroup.add(getMusicGroup(musicData.get(3), 3));
        musicGroup.add(getMusicGroup(musicData.get(4), 4));


        final GroupObject frame = getFrameGroup("Music Select");
        final TextObject hint = new TextObject();
        hint.setText("STARTキーで決定     MILLスクラッチで楽曲を選択    OPTIONキーで難易度を選択");
        hint.setFont(yuGothic);
        hint.setTextSize(15);
        hint.setPosition(80, 756);
        hint.addState("fade", new TweenState(ParameterType.ALPHA)
            .setTween(0.0f, 1.0f, 200));

        final ImageObject board1 = new ImageObject("image/parts/board1.png");
        board1.setPosition(84, 133);
        final ImageObject board2 = new ImageObject("image/parts/board2.png");
        board2.setPosition(714, 133);
        final GroupObject board = new GroupObject(board1, board2);


        final TextObject sortText = new TextObject(sortString[0]);
        sortText.setFont(brushScript);
        sortText.setTextSize(70);
        sortText.setPosition(147, 161);
        sortText.addState("fadeIn", new TweenState(ParameterType.ALPHA)
            .setTween(0.0f, 1.0f, 200));
        final FigureObject sortLine = new FigureObject();
        sortLine.setSize(297, 28);
        sortLine.setPosition(136, 204);
        sortLine.setColor(color(#FF8F8F));
        sortLine.addState("enter", new TweenState(ParameterType.SIZE)
            .setTween(0, 28, 297, 28, 400)
            .setEasing(new EasingOutQuint()));
        final GroupObject sort = new GroupObject(sortLine, sortText);


        final TextObject levelTitleText = sortText.clone();
        levelTitleText.setText("Level");
        levelTitleText.setTextSize(48);
        levelTitleText.setPosition(777, 161);
        final FigureObject levelTitleLine = new FigureObject();
        levelTitleLine.setSize(282, 2);
        levelTitleLine.setPosition(769, 212);
        levelTitleLine.addState("enter", new TweenState(ParameterType.SIZE)
            .setTween(0, 2, 282, 2, 400)
            .setEasing(new EasingOutQuint()));

        levelTexts[0] = new TextObject();
        levelTexts[0].numberMode(NumType.INTEGER);
        levelTexts[0].setFont(baoli);
        levelTexts[0].setTextSize(88);
        levelTexts[0].setColor(color(#3787B1));
        levelTexts[0].setAlign(CENTER, TOP);
        levelTexts[0].setPosition(825, 177);
        final TextObject levelLabelText0 = levelTexts[0].clone();
        levelLabelText0.stringMode();
        levelLabelText0.setTextSize(20);
        levelLabelText0.setText("beginner");
        levelLabelText0.setPosition(825, 266);

        levelTexts[1] = levelTexts[0].clone();
        levelTexts[1].setPosition(914.5, 177);
        levelTexts[1].setColor(color(#CBA400));
        final TextObject levelLabelText1 = levelLabelText0.clone();
        levelLabelText1.setText("advance");
        levelLabelText1.setPosition(914.5, 266);
        levelLabelText1.setColor(color(#CBA400));

        levelTexts[2] = levelTexts[0].clone();
        levelTexts[2].setPosition(1003.5, 177);
        levelTexts[2].setColor(#BE2D2D);
        final TextObject levelLabelText2 = levelLabelText0.clone();
        levelLabelText2.setText("master");
        levelLabelText2.setPosition(1003.5, 266);
        levelLabelText2.setColor(color(#BE2D2D));

        final GroupObject level = new GroupObject(levelTitleText, levelTitleLine,
            levelTexts[0], levelTexts[1], levelTexts[2]);
        final GroupObject levelLabel = new GroupObject(levelLabelText0, levelLabelText1, levelLabelText2);
        levelLabel.addState("fadeIn", new TweenState(ParameterType.ALPHA)
            .setTween(0.0f, 1.0f, 200));


        final TextObject bestScoreTitleText = levelTitleText.clone();
        bestScoreTitleText.setText("Best Score");
        bestScoreTitleText.setPosition(777, 306);
        final FigureObject bestScoreTitleLine = levelTitleLine.clone();
        bestScoreTitleLine.setPosition(769, 356.5);

        scoreText = new TextObject();
        scoreText.numberMode(NumType.INTEGER, 7);
        scoreText.setFont(baoli);
        scoreText.setTextSize(50);
        scoreText.setPosition(777, 342);
        final GroupObject bestScore = new GroupObject(bestScoreTitleLine, bestScoreTitleText, scoreText);

        final ImageObject jacketImage = new ImageObject("image/jacket.png");
        jacketImage.setSize(255, 255);
        jacketImage.setPosition(771, 456);
        final FigureObject jacketFrame = new FigureObject();
        jacketFrame.setSize(259, 259);
        jacketFrame.setPosition(769, 454);
        final GroupObject jacket = new GroupObject(jacketFrame, jacketImage);
        jacket.addState("fadeIn", new TweenState(ParameterType.ALPHA)
            .setTween(0.0f, 1.0f, 200));


        final ImageObject musicBracketImage = new ImageObject("image/parts/bracket1.png");
        musicBracketImage.setPosition(114, 236);
        musicBracket = new GroupObject(musicBracketImage);
        musicBracket.addState("idle", new TweenState(ParameterType.SCALE)
            .setTween(1.0f, 0.96f, 400)
            .setLoop(-1, LoopType.YOYO, 100));
        musicBracket.addState("fadeIn", new TweenState(ParameterType.ALPHA)
            .setTween(0.0f, 1.0f, 200));

        final ImageObject levelBracketImage = new ImageObject("image/parts/bracket2.png");
        levelBracketImage.setPosition(769, 216);
        levelBracket = new GroupObject(levelBracketImage);
        levelBracket.addState("idle", new TweenState(ParameterType.SCALE)
            .setTween(1.0f, 0.92f, 400)
            .setLoop(-1, LoopType.YOYO, 100));
        levelBracket.addState("fadeIn", new TweenState(ParameterType.ALPHA)
            .setTween(0.0f, 1.0f, 200));


        addObjects(frame, new GroupObject(hint), board, sort, levelLabel, level, bestScore, jacket);
        for(GroupObject group : musicGroup) {
            addObjects(group);
        }
        addObjects(musicBracket, levelBracket);


        sequences.put("enterSQ", new Sequence() {
            @Override
            protected void onProcess() {
                switch(keyTime) {
                case 0:
                    frame.enableGroup();
                    board.enableGroup();
                    break;
                case 200:
                    sortLine.startState("enter");
                    bestScoreTitleLine.startState("enter");
                    levelTitleLine.startState("enter");
                    break;
                case 400:
                    sortText.startState("fadeIn");
                    bestScoreTitleText.startState("fadeIn");
                    levelTitleText.startState("fadeIn");
                    break;
                case 600:
                    levelLabel.startState("fadeIn");
                    jacket.startState("fadeIn");
                    for(GroupObject group : musicGroup) {
                        group.startState("fadeIn");
                    }
                    break;
                case 800:
                    updateLevel();
                    updateScore();
                    break;
                case 900:
                    musicBracket.startState("fadeIn", "idle");
                    levelBracket.startState("fadeIn", "idle");
                    hint.startState("fadeIn");
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
                    if(keyListener.isScratchStatus(1)) {
                        selectedNum++;
                        selectedNum %= 5;
                    } else if (keyListener.isScratchStatus(-1)) {
                        selectedNum = selectedNum == 0 ? 4 : selectedNum - 1;
                        selectedNum %= 5;
                    }
                    moveMusicBracket();
                }
                if(keyListener.isPressed(7)) {
                    resetSequence();
                    selectedLevel++;
                    selectedLevel %= 3;
                    moveLevelBracket();
                }
                if(keyTime > 600 && keyListener.isPressed(6)) {
                    subScene.startScene();
                }
            }
        });
    }

    private void moveMusicBracket() {
        musicBracket.addState("move", new TweenState(ParameterType.POSITION)
            .setFreakyTween(114, 236 + 96 * selectedNum, 500)
            .setEasing(new EasingOutQuint()));
        musicBracket.startState("move");
        updateLevel();
        updateScore();
    }

    private void moveLevelBracket() {
        levelBracket.addState("move", new TweenState(ParameterType.POSITION)
            .setFreakyTween(769 + 89 * selectedLevel, 216, 500)
            .setEasing(new EasingOutQuint()));
        levelBracket.startState("move");
        updateScore();
    }

    private void updateLevel() {
        for(int i = 0; i < 3; i++) {
            int levelNum = musicData.get(selectedNum).getLevel().get(i);
            levelTexts[i].addState("update", new TweenState(ParameterType.NUMBER)
                .setTween(0, levelNum, 200));
            levelTexts[i].startState("update");
        }
    }

    private void updateScore() {
        int scoreNum = musicData.get(selectedNum).getScore().get(selectedLevel);
        scoreText.addState("update", new TweenState(ParameterType.NUMBER)
            .setTween(0, scoreNum, 200));
        scoreText.startState("update");
    }

    @Override
    protected Scene disposeScene() {
        return this;
    }
}
