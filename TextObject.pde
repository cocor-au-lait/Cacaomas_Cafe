private class TextObject extends GameObject {
    private PFont font = font0;
    private int alignX = LEFT;
    private int alignY = TOP;
    private String string;
    private float textSize;
    private boolean hasSize;

    private TextObject() {
        string = "";
    }

    private TextObject(String string) {
        this.string = string;
    }

    @Override
    public TextObject clone(){
        TextObject object = new TextObject();
        try {
            object = (TextObject)super.clone();
            object.states = new HashMap<String, State>(this.states);
            for(Entry<String, State> entry : object.states.entrySet()) {
                object.addState(entry.getKey(), entry.getValue());
            }
           // object.subStates = new ArrayList<State>(this.subStates);
        } catch (Exception e){
            e.printStackTrace();
        }
        return object;
    }

    @Override
    protected void adjustParameter() {
        if(isFreeRef) {
            return;
        }
        if(textSize == 0.0f || scale == 0.0f) {
            posRX = 0.0f;
            posRY = 0.0f;
            return;
        }
        textFont(font);
        textSize(textSize * scale);
        switch(alignX) {
        case LEFT:
            posRX = posX + textWidth(string) / 2.0f;
            break;
        case CENTER:
            posRX = posX;
            break;
        case RIGHT:
            posRX = posX - textWidth(string) / 2.0f;
            break;
        }
        switch(alignY) {
        case TOP:
            posRY = posY + textAscent() / 2.0f;
            break;
        case CENTER:
            posRY = posY;
            break;
        case BASELINE:
            posRY = posY - textAscent() / 2.0f;
            break;
        case BOTTOM:
            posRY = posY - (textAscent() + textDescent()) / 2.0f;
            break;
        }
    }

/*
    private void removeSize() {
        hasSize = false;
    }


    private boolean hasSize() {
        return hasSize;
    }

    */

    private void setText(String string) {
        this.string = string;
        adjustParameter();
    }

    private String getText() {
        return string;
    }


    protected final void setAlign(int alignX, int alignY) {
        this.alignX = alignX;
        this.alignY = alignY;
        adjustParameter();
    }

    private void setFont(PFont font) {
        this.font = font;
        adjustParameter();
    }

    private void setTextSize(float textSize) {
        if(textSize < 0.0f) {
            println("Error:textSize can't support under 0.0f");
            this.textSize = 0.0f;
        }
        this.textSize = textSize;
        adjustParameter();
    }

    @Override
    protected void concreteDraw() {
        if(textSize == 0.0f || scale == 0.0f) {
            return;
        }
        textFont(font);
        textSize(textSize * scale);

        float diffX = textWidth(string) * (scale - 1.0f) / 2.0f;
        float diffY = textAscent() * (scale - 1.0f) / 2.0f;
        float realPosX = 0.0f;
        float realPosY = 0.0f;
        switch(alignX) {
        case LEFT:
            realPosX = (posX - diffX) * DISPLAY_SCALE + WIDTH_MARGIN;
            break;
        case CENTER:
            realPosX = posX * DISPLAY_SCALE + WIDTH_MARGIN;
            break;
        case RIGHT:
            realPosX = (posX + diffX) * DISPLAY_SCALE + WIDTH_MARGIN;
            break;
        }
        switch(alignY) {
        case TOP:
            realPosY = (posY - diffX) * DISPLAY_SCALE + HEIGHT_MARGIN;
            break;
        case CENTER:
            realPosY = posY * DISPLAY_SCALE + HEIGHT_MARGIN;
            break;
        case BASELINE:
            realPosY = (posY + diffY) * DISPLAY_SCALE + HEIGHT_MARGIN;
            break;
        case BOTTOM:
            diffY = (textAscent() + textDescent()) * (scale - 1.0f) / 2.0f;
            realPosY = posY * DISPLAY_SCALE + diffY + HEIGHT_MARGIN;
            break;
        }

        textSize(textSize * scale * DISPLAY_SCALE);
        fill(colors, alpha);
        textAlign(alignX, alignY);
        if(hasSize) {
            //text(string, realPosX, realPosY, realSizeX , realSizeY);
        } else {
            text(string, realPosX, realPosY);
        }
    }
}
