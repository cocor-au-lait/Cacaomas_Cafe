private class ImageObject extends GameObject {
    private PImage file;
    private int mode = CORNER;

    @Override
    public ImageObject clone(){
        ImageObject object = new ImageObject();
        try {
            object = (ImageObject)super.clone();
            object.states = new HashMap<String, State>(this.states);
            object.subStates = new ArrayList<State>(this.subStates);
        } catch (Exception e){
            e.printStackTrace();
        }
        return object;
    }

    private void setMode(int mode) {
        this.mode = mode;
    }

    protected final void setImage(String filename) {
        file = loadImage(filename);
        sizeX = file.width;
        sizeY = file.height;
        colors = color(255);
    }

    @Override
    protected void concreteDraw() {
        tint(colors, alpha);
        imageMode(mode);
        image(file, posX, posY, sizeX, sizeY);
        noTint();
    }
}

/*private class FadeImageObject extends ImageObject {
    private int fadeInTime, fadeOutTime;

    private FadeImageObject(String filename) {
        super(filename);
    }

    private final void setFadeTime(int fadeTime) {
        this.fadeInTime = fadeTime;
        this.fadeOutTime = fadeTime;
    }

    private final void setFadeTime(int fadeInTime, int fadeOutTime) {
        this.fadeInTime = fadeInTime;
        this.fadeOutTime = fadeOutTime;
    }

    @Override
    protected void run() {
        switch(phase) {
        case Birth: {
            float ratio = calcRatio(phaseElapsedTime, fadeInTime);
            alpha = ratio * 255.0f;
            if(ratio == 1.0f) {
                setPhase(SURVIVE);
            }
            break;
        }
        case Survive: {
            alpha = 255.0f;
            break;
        }
        case Decay: {
            float ratio = calcRatio(phaseElapsedTime, fadeOutTime);
            alpha = (1.0f - ratio) * 255.0f;
            if(ratio == 1.0f) {
                setPhase(DEAD);
            }
        }
        }
        super.run();
    }
}*/