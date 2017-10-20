private class BackgroundScene extends Scene {
    public void run() {
        //final Movie bgMovie = new Movie(applet, "movie/bg.mp4");
        final FigureObject yellow_wall = new FigureObject();
        yellow_wall.setPosition(0, 0);
        yellow_wall.setSize(BASE_WIDTH, BASE_HEIGHT);
        yellow_wall.setColor(color(#FDD491));

        final FigureObject rotater[] = new FigureObject[5];
        rotater[0] = new FigureObject();
        rotater[0].setMode(CENTER);
        rotater[0].setColor(15);
        rotater[0].setBlend(ADD);
        rotater[0].setPosition(154  , 473);
        rotater[0].setSize(200, 200);
        rotater[1] = rotater[0].clone();
        rotater[1].setPosition(291, 225);
        rotater[1].setSize(300, 300);
        rotater[2] = rotater[0].clone();
        rotater[2].setPosition(740, 74);
        rotater[2].setSize(400, 400);
        rotater[3] = rotater[0].clone();
        rotater[3].setPosition(1001, 334);
        rotater[3].setSize(500, 500);
        rotater[4] = rotater[0].clone();
        rotater[4].setPosition(1080, 590);
        rotater[4].setSize(300, 200);

        objects = Arrays.asList((GameObject)yellow_wall,
            rotater[0], rotater[1], rotater[2], rotater[3], rotater[4]);

        sequences.put("idleSQ", new Sequence() {
            @Override
            protected void onStart() {
                yellow_wall.enable();
                rotater[0].enable();
                rotater[1].enable();
                rotater[2].enable();
                rotater[3].enable();
                rotater[4].enable();
            }
            @Override
            protected void onProcess() {
                rotater[0].addRotation(0.2f);
                rotater[1].addRotation(-0.15f);
                rotater[2].addRotation(0.3f);
                rotater[3].addRotation(-0.15f);
                rotater[4].addRotation(0.1f);
            }
        });
        /*sequences.put("movie", new Sequence() {
            @Override
            protected void executeSchedule() {
                if(keyTime == 0) {
                    bgMovie.loop();
                }
                imageMode(CORNER);
                image(bgMovie, 0, 0, width, height);
            }
        });
        sequences.get("movie").startSequence();*/
        hasLoadedBackgroundScene = true;
    }

    @Override
    protected Scene disposeScene() {
        return this;
    }
}
