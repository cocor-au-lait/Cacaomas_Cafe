private abstract class GameObject {
    protected int objectStartTime;
    protected int objectElapsedTime;
    protected boolean isActive, isFreeRefMode;
    protected float posX, posY, sizeX, sizeY, posRX, posRY, rotation;
    protected float alpha = 1.0f;
    protected int align = CORNER;;
    protected int blend = BLEND;
    protected color colors;
    protected int groupId = -1;
    protected String parent;

    protected final void setActive(boolean isActive) {
        this.isActive = isActive;
    }

    protected final boolean isActive() {
        return isActive;
    }

    protected final void setFreeRef(boolean isFreeRef) {
        this.isFreeRef = isFreeRef;
    }

    protected final void setPosition(float posX, float posY) {
        this.posX = posX;
        this.posY = posY;
        if(isFreeRef) {
            setRefPosition(posX + sizeX / 2, posY + sizeY / 2);
        }
    }

    protected final float[] getPosition() {
        float[] position = {posX, posY};
        return position;
    }

    protected void setSize(float sizeX, float sizeY) {
        this.sizeX = sizeX;
        this.sizeY = sizeY;
        if(isFreeRef) {
            setRefPosition(posX + sizeX / 2, posY + sizeY / 2);
        }
    }

    protected final float[] getSize() {
        float[] size = {sizeX, sizeY};
        return size;
    }

    protected final void setRefPosition(float posRX, float posRY) {
        this.posRX = posRX;
        this.posRY = posRY;
    }

    protected final float[] getRefPosition() {
        float[] refPosition = {posRX, posRY};
        return refPosition;
    }

    protected final void setAlign(int align) {
        this.align = align;
    }

    protected final int getAlign() {
        return align;
    }

    protected final void setBlend(int blend) {
        this.blend = blend;
    }

    protected final void getBlend() {
        return blend;
    }

    protected void setColor(color colors) {
        this.colors = colors;
    }

    protected final color getColor() {
        return colors;
    }

    protected final void setAlpha(float alpha) {
        this.alpha = alpha;
    }

    protected final float getAlpha() {
        return alpha;
    }

    protected final void setRotation(float rotation) {
        this.rotation = rotation;
    }

    protected final float getRotation() {
        return rotation;
    }

    protected final int getElapsedTime() {
        return objectElapsedTime;
    }

    protected final void setParent(String parent) {
        this.parent = parent;
    }

    protected final String getParent() {
        return parent;
    }

    // 実装メソッド
    protected final void draw() {
        if(!isActive) {
            return;
        }
        objectElapsedTime = millis() - objectStartTime;
        //phaseElapsedTime = millis() - phaseStartTime;
        blendMode(blend);
        pushMatrix();
        // 回転軸座標を図形の中心に移動
        translate(posRX, posRY);
        rotate(rotation);
        concreteDraw();
        // 座標軸とブレンドモードを戻す
        popMatrix();
        blendMode(BLEND);
    }

    protected abstract void concreteDraw();
}

private class RotateFigureObject extends LifeCycleObject {
    private float degAdd = 30.0f;           // 1フレーム毎に回転する角度の増加量
    private int vertexNum = 4;              // 頂点の数（何角形か）
    private float posX, posY, sizeX, sizeY, alpha;
    private int direction = LEFT;
    private float stableDegAdd;
    private color colors;
    private float deg;

    // ｘ座標、ｙ座標、大きさ、安定時の回転量、回転方向
    private RotateFigureObject(float stableDegAdd, int direction) {
        this.stableDegAdd = stableDegAdd;
        this.direction = direction;
    }

    private final void setPosition(float posX, float posY) {
        this.posX = posX;
        this.posY = posY;
    }

    private final void setSize(float sizeX, float sizeY) {
        this.sizeX = sizeX;
        this.sizeY = sizeY;
    }

    private final void setColor(color colors, float alpha) {
        this.colors = colors;
        this.alpha = alpha;
    }

    @Override
    protected void run() {
        // 起動直後から少しずつ回転量が減っていく
        if(degAdd > stableDegAdd) {
            // lerp関数を利用して少しずつ安定時の回転量に落としていく
            degAdd = lerp(stableDegAdd, degAdd, 0.8f);
        }
        // 実際に回転させる角度を算出
        // 360度換算なので360度=0度に変換
        deg = deg < 360.0f ? deg + degAdd : 0.0f;
        // 加算処理に変更
        pushMatrix();
        // 回転軸座標を図形の中心に移動
        translate(posX + sizeX / 2, posY + sizeY / 2);
        // 回転方向別に処理
        // if(deg == LEFT) → 左方向に違えば右方向に回転
        rotate(radians(direction == LEFT ? deg : -deg));
        //
        noStroke();
        fill(colors, alpha);
        /*beginShape();
        for (int i = 0; i < vertexNum; i++) {
            vertex(sizeX * cos(radians(360 * i / vertexNum)), sizeY * sin(radians(360 * i / vertexNum)));
        }
        endShape(CLOSE);*/
        rectMode(CENTER);
        noStroke();
        blendMode(ADD);
        rect(0, 0, sizeX, sizeY);
        // 座標軸とブレンドモードを戻す
        popMatrix();
        blendMode(BLEND);
    }
}

private class OverlayObject extends LifeCycleObject {
    private int fadeTime;
    private color colors;
    private float alpha;

    private void setFadeTime(int fadeTime) {
        this.fadeTime = fadeTime;
    }

    private void setColor(color colors) {
        this.colors = colors;
    }

    @Override
    protected void run() {
        float ratio = calcRatio(phaseElapsedTime, fadeTime);

        switch(phase) {
        case Birth:
            alpha = ratio * 255.0f;
            if(ratio == 1.0f) {
                setPhase(DECAY);
            }
            break;
        case Decay:
            alpha = (1.0f - ratio) * 255.0f;
            if(ratio == 1.0f) {
                setPhase(DEAD);
            }
        }
        fill(colors, alpha);
        rectMode(CORNER);
        noStroke();
        rect(0, 0, width, height);
    }
}
