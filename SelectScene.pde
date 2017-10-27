private class SelectScene extends Scene {
    public void run() {
        final GroupObject frame = getFrameGroup("Music Select");


        addObjects(frame);


        sequences.put("enterSQ", new Sequence() {
            @Override
            protected void onProcess() {
                switch(keyTime) {
                case 0:
                    frame.enableGroup();
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