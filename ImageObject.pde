private class ImageObject extends LifeCycleObject {
    private PImage file;
    private float posX, posY, sizeX, sizeY;
    protected float alpha;
    private color colors;
    private int mode = CORNER;

    private ImageObject() {
    }

    private ImageObject(String filename) {
        file = loadImage(filename);
        sizeX = file.width;
        sizeY = file.height;
    }

    protected final void setImage(String filename) {
        file = loadImage(filename);
        sizeX = file.width;
        sizeY = file.height;
    }

    protected final void setPosition(float posX, float posY, int mode) {
        this.posX = posX;
        this.posY = posY;
        this.mode = mode;
    }

    protected final void setSize(float sizeX, float sizeY) {
        this.sizeX = sizeX;
        this.sizeY = sizeY;
    }

    protected final void setColor(color colors, float alpha) {
        this.colors = colors;
        this.alpha = alpha;
    }

    @Override
    protected void run() {
        tint(colors, alpha);
        imageMode(mode);
        image(file, posX, posY, sizeX, sizeY);
        noTint();
    }
}

private class FadeImageObject extends ImageObject {
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
}
