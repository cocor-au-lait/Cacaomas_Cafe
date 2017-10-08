private class FigureObject extends GameObject {
    private float strokeWeight, strokeColors, strokeAlpha;
    private int strokeJoin, strokeCap;
    private boolean canFill, canStroke;

    private FigureObject() {
        align = CORNER;
    }

    //セッター＆ゲッター
    private void setStrokeWeight(float strokeWeight) {
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
        this.setStrokeJoin = setStrokeJoin;
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

    private setStroke(boolean canStroke) {
        this.canStroke = canStroke;
    }

    private boolean canStroke() {
        return canStroke;
    }

    private setFill(boolean canFill) {
        this.canFill = canFill;
    }

    private boolean canFill() {
        return canFill;
    }

    // 実装メソッド
    @Override
    protected void concreteDraw() {
        if(canFill) {
            fill(colors, alpha);
        } else {
            noFill();
        }
        if(canStroke) {
            stroke(strokeColors, strokeAlpha);
        } else {
            noStroke();
        }
        /*beginShape();
        for (int i = 0; i < vertexNum; i++) {
            vertex(size * cos(radians(360 * i / vertexNum)), size * sin(radians(360 * i / vertexNum)));
        }
        endShape(CLOSE);*/
        rectMode(mode);
        rect(posX, posY, sizeX, sizeY);
    }
}
