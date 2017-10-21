private class ModeSelectScene extends Scene {
    public void run() {
        final TextObject titleText = new TextObject("Mode Select");
        titleText.setFont(bickham);
        titleText.setTextSize(141);
        titleText.setAlign(CENTER, TOP);
        titleText.setPosition(BASE_WIDTH / 2, 0);
        final FigureObject titleTextLine = new FigureObject();
        titleTextLine.setPosition(80, 120);
        titleTextLine.setSize(1120, 3);

        final ImageObject circle1 = new ImageObject("image/parts/circle.png");
        circle1.setSize(291, 291);
        circle1.setPosition(495, 166);


        objects = Arrays.asList(titleText, titleTextLine);


        sequences.put("enterSQ", new Sequence() {
            @Override
            protected void onProcess() {
                switch(keyTime) {
                case 0:
                    enableObjects(titleText, titleTextLine);
                    break;
                }
            }
        });
    }

    @Override
    protected Scene disposeScene() {
        return this;
    }
}
