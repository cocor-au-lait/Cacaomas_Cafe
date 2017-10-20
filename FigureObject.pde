private class FigureObject extends GameObject {
    /*private float strokeWeight, strokeAlpha;
    private color strokeColors;
    private int strokeJoin, strokeCap;*/
    private boolean canFill, canStroke;
    private int mode = CORNER;
    private int cornerNum = 4;

    private  FigureObject() {
        canFill = true;
        canStroke = false;
    }

    @Override
    public FigureObject clone(){
        FigureObject object = new FigureObject();
        try {
            object = (FigureObject)super.clone();
            object.states = new HashMap<String, State>(this.states);
            //object.subStates = new ArrayList<State>(this.subStates);
        } catch (Exception e){
            e.printStackTrace();
        }
        return object;
    }


    //セッター＆ゲッター
    /*private void setStrokeWeight(float strokeWeight) {
        this.strokeWeight = strokeWeight;
    }

    private float getStrokeWeight() {
        return strokeWeight;
    }

    private void setStrokeColor(color strokeColors) {
        this.strokeColors = strokeColors;
        canStroke = true;
    }

    private color getStrokeColor() {
        return strokeColors;
    }

    private void setStrokeAlpha(float strokeAlpha) {
        this.strokeAlpha = strokeAlpha;
    }

    private float getStrokeAlpha() {
        return strokeAlpha;
    }

    private void setStrokeJoin(int strokeJoin) {
        this.strokeJoin = strokeJoin;
    }

    private int getStrokeJoin() {
        return strokeJoin;
    }

    private void setStrokeCap() {
        this.strokeCap = strokeCap;
    }

    private int getStrokeCap() {
        return strokeCap;
    }

    private void setStroke(boolean canStroke) {
        this.canStroke = canStroke;
    }

    private boolean canStroke() {
        return canStroke;
    }

    private void setFill(boolean canFill) {
        this.canFill = canFill;
    }

    private boolean canFill() {
        return canFill;
    }*/

    private void setMode(int mode) {
        this.mode = mode;
        adjustParameter();
    }

    private void setCornerNum(int num) {
        this.cornerNum = num;
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

    // 実装メソッド
    @Override
    protected void concreteDraw() {
        pushMatrix();
        translate(posRX, posRY);
        rotate(radians(rotation));
        translate(-posRX, -posRY);

        if(canFill) {
            fill(colors, alpha);
        } else {
            noFill();
        }
        if(canStroke) {
            //stroke(strokeColors, strokeAlpha);
        } else {
            noStroke();
        }

        rectMode(mode);

        float diffX = (sizeX * (scale - 1.0f)) / 2.0f;
        float diffY = (sizeY * (scale - 1.0f)) / 2.0f;
        float realPosX, realPosY, realPosX2, realPosY2, realSizeX, realSizeY;
        switch(mode) {
        case CORNER:
            realPosX = (posX - diffX) * DISPLAY_SCALE + WIDTH_MARGIN;
            realPosY = (posY - diffY) * DISPLAY_SCALE + HEIGHT_MARGIN;
            realSizeX = sizeX * scale * DISPLAY_SCALE;
            realSizeY = sizeY * scale * DISPLAY_SCALE;
            if(cornerNum == 4) {
                rect(realPosX, realPosY, realSizeX, realSizeY);
            } else {
                ellipse(realPosX, realPosY, realSizeX, realSizeY);
            }
            break;
        case CENTER:
            realPosX = posX * DISPLAY_SCALE + WIDTH_MARGIN;
            realPosY = posY * DISPLAY_SCALE + HEIGHT_MARGIN;
            realSizeX = sizeX * scale * DISPLAY_SCALE;
            realSizeY = sizeY * scale * DISPLAY_SCALE;
            if(cornerNum == 4) {
                rect(realPosX, realPosY, realSizeX, realSizeY);
            } else {
                ellipse(realPosX, realPosY, realSizeX, realSizeY);
            }
            break;
        case CORNERS:
            realPosX = (posX - diffX) * DISPLAY_SCALE + WIDTH_MARGIN;
            realPosY = (posY - diffY) * DISPLAY_SCALE + HEIGHT_MARGIN;
            realPosX2 = (posX2 + diffX) * DISPLAY_SCALE + WIDTH_MARGIN;
            realPosY2 = (posY2 + diffY) * DISPLAY_SCALE + HEIGHT_MARGIN;
            if(cornerNum == 4) {
                rect(realPosX, realPosY, realPosX2, realPosY2);
            } else {
                ellipse(realPosX, realPosY, realPosX2, realPosY2);
            }
            break;
        }

        popMatrix();
    }
}
