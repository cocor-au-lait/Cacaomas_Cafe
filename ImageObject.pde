private class ImageObject extends GameObject {
    private PImage image;
    private int filter;
    private float filterSize;
    private int mode = CORNER;
    private float wipePosX, wipePosY, wipeSizeX, wipeSizeY;

    private ImageObject() {
        colors = color(255);
    }

    @Override
    public ImageObject clone(){
        ImageObject object = new ImageObject();
        try {
            object = (ImageObject)super.clone();
            object.states = new HashMap<String, State>(this.states);
            //object.subStates = new ArrayList<State>(this.subStates);
        } catch (Exception e){
            e.printStackTrace();
        }
        return object;
    }

    private void setMode(int mode) {
        this.mode = mode;
        adjustParameter();
    }

    private void setImage(String filename) {
        image = loadImage(filename);
        sizeX = image.width;
        sizeY = image.height;
        wipeSizeX = image.width;
        wipeSizeY = image.height;
        adjustParameter();
    }

    private void setWipe(float wipePosX, float wipePosY, float wipeSizeX, float wipeSizeY) {
        this.wipePosX = wipePosX;
        this.wipePosY = wipePosY;
        this.wipeSizeX = wipeSizeX;
        this.wipeSizeY = wipeSizeY;
    }

    @Override
    protected void adjustParameter() {
        if(isFreeRef) {
            return;
        }
        // アンカー座標がテキストボックスの中心になるように設定をする
        switch(mode) {
        case CORNER:
            posRX = posX + sizeX / 2.0f;
            posRY = posY + sizeY / 2.0f;
            break;
        case CENTER:
            posRX = posX;
            posRY = posY;
            break;
        case CORNERS:
            posRX = posX + (posX2 - posX/*size*/) / 2;
            posRY = posY + (posY2 - posY/*size*/) / 2;
            break;
        }
    }

    @Override
    protected void concreteDraw() {
        pushMatrix();
        translate(posRX, posRY);
        rotate(rotation);
        popMatrix();
        tint(colors, alpha);
        imageMode(mode);

        float diffX = (sizeX * (scale - 1.0f)) / 2.0f;
        float diffY = (sizeY * (scale - 1.0f)) / 2.0f;
        float realPosX, realPosY, realPosX2, realPosY2, realSizeX, realSizeY;
        switch(mode) {
        case CORNER:
            realPosX = (posX - diffX) * DISPLAY_SCALE + WIDTH_MARGIN;
            realPosY = (posY - diffY) * DISPLAY_SCALE + HEIGHT_MARGIN;
            realSizeX = sizeX * scale * DISPLAY_SCALE;
            realSizeY = sizeY * scale * DISPLAY_SCALE;
            image(image, realPosX, realPosY, realSizeX, realSizeY);
            break;
        case CENTER:
            realPosX = posX * DISPLAY_SCALE + WIDTH_MARGIN;
            realPosY = posY * DISPLAY_SCALE + HEIGHT_MARGIN;
            realSizeX = sizeX * scale * DISPLAY_SCALE;
            realSizeY = sizeY * scale * DISPLAY_SCALE;
            image(image, realPosX, realPosY, realSizeX, realSizeY);
            break;
        case CORNERS:
            realPosX = (posX - diffX) * DISPLAY_SCALE + WIDTH_MARGIN;
            realPosY = (posY - diffY) * DISPLAY_SCALE + HEIGHT_MARGIN;
            realPosX2 = (posX2 + diffX) * DISPLAY_SCALE + WIDTH_MARGIN;
            realPosY2 = (posY2 + diffY) * DISPLAY_SCALE + HEIGHT_MARGIN;
            image(image, realPosX, realPosY, realPosX2, realPosY2);
            break;
        };

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
