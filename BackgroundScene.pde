private class BackgroundScene extends Scene {
    public void run() {
        //final Movie bgMovie = new Movie(applet, "movie/bg.mp4");
        final FigureObject yellow_wall = new FigureObject();
        yellow_wall.setPosition(0, 0);
        yellow_wall.setSize(BASE_WIDTH, BASE_HEIGHT);
        yellow_wall.setColor(color(#FDD491));
        objects.add(yellow_wall);
        yellow_wall.enable();
        hasLoadedBackgroundScene = true;
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
    }

    @Override
    protected Scene dispose() {
        return this;
    }
}
