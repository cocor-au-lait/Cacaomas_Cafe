private class TextObject extends GameObject {
    private PFont font;
    private String string;
    private float textSize;
    private color colors;
    private boolean hasSize;

    private TextObject() {
        align = LEFT;
    }

    @Override
    protected void setSize(float sizeX, float sizeY) {
        super.setSize(sizeX, sizeY);
        hasSetSize = true;
    }

    private void removeSize() {
        hasSize = false;
    }

    private boolean hasSize() {
        return hasSize;
    }

    private void setString(String string) {
        this.string = string;
    }

    private String getString() {
        return string;
    }

    private void setFont(PFont font) {
        this.font = font;
    }

    private PFont getFont() {
        return font;
    }

    private void setTextSize(float textSize) {
        this.textSize = textSize;
    }

    @Override
    protected void concreteDraw() {
        fill(colors, alpha);
        textFont(font);
        textSize(size);
        textAlign(align);
        if(hasSetSize) {
            text(string, posX, posY, posRX, posRY);
        } else {
            text(string, posX, posY);
        }
    }
}

private class LoopFadeTextObject extends TextObject {
    private int fadeTime;
    private boolean fadeMode;

    private LoopFadeTextObject(String string) {
        super(string);
    }

    private final void setFadeTime(int fadeTime) {
        this.fadeTime = fadeTime;
    }

    @Override
    protected void run() {
        // 時間が経過するごとに0.0f~1.0fで比率が上がっていく
        float ratio = calcRatio(objectElapsedTime, fadeTime);
        // 伸び率にイージングを加える
        ratio = easeInOutCubic(ratio);
        // 比率が1.0fに達したら今度は比率がヘルモードに移行する
        // 比率が減るモードで1,0fに達したら増えるモードに戻る
        // 経過時間をリセットすることで比率0.0fから開始し直す
        if(ratio == 1.0f) {
            ratio = 0;
            fadeMode = !fadeMode;
            objectStartTime = millis();
        }
        // 経過時間ごとに減るモードでは比率を逆転させる
        if(fadeMode) {
            ratio = 1.0f - ratio;
        }
        // 比率をアルファ値に変換する
        alpha = ratio;
        // テキストの描画
        super.run();
        //text("pless ENTER/START key to start", width / 2, height * 0.8);
    }
}

private class FadeTextObject extends TextObject {
    private int fadeInTime, fadeOutTime;

    private FadeTextObject(String string) {
        super(string);
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
            //alpha = ratio * 255.0f;
            if(ratio == 1.0f) {
                setPhase(BIRTH);
            }
            break;
        }
        case Survive: {
            //alpha = 255.0f;
            break;
        }
        case Decay: {
            float ratio = calcRatio(phaseElapsedTime, fadeOutTime);
            //alpha = (1.0f - ratio) * 255.0f;
            if(ratio == 1.0f) {
                setPhase(DEAD);
            }
        }
        }
        super.run();
    }
}
