private class GameObject implements Cloneable {
    protected boolean isActive, isFreeRef;
    protected float posX, posY, posX2, posY2, sizeX, sizeY, posRX, posRY, rotation;
    protected float scale = 1.0f;
    protected float alpha = 1.0f;
    private int blend = BLEND;
    protected color colors;
    protected HashMap<String, State> states = new HashMap<String, State>();
    //protected ArrayList<State> subStates = new ArrayList<State>();

    @Override
    public GameObject clone(){
        GameObject object = new GameObject();
        try {
            object = (GameObject)super.clone();
            object.states = new HashMap<String, State>(this.states);
           // object.subStates = new ArrayList<State>(this.subStates);
        } catch (Exception e){
            e.printStackTrace();
        }
        return object;
    }

    protected final boolean isActive() {
        return isActive;
    }
    /*
    protected final void setFreeRef(boolean isFreeRef) {
        this.isFreeRef = isFreeRef;
        adjustParameter();
    }*/

    protected final void setPosition(float posX, float posY) {
        this.posX = posX;
        this.posY = posY;
        adjustParameter();
    }

    protected final float[] getPosition() {
        float[] position = {posX, posY};
        return position;
    }

    protected final void setPosition2(float posX2, float posY2) {
        this.posX2 = posX2;
        this.posY2 = posY2;
        adjustParameter();
    }

    protected final float[] getPosition2() {
        float[] position2 = {posX2, posY2};
        return position2;
    }

    protected final void setSize(float sizeX, float sizeY) {
        this.sizeX = sizeX;
        this.sizeY = sizeY;
        adjustParameter();
    }

    protected final float[] getSize() {
        float[] size = {sizeX, sizeY};
        return size;
    }

    protected final void setScale(float scale) {
        if(scale < 0.0f) {
            println("Error:scale can't support under 0.0f");
            this.scale = 0.0f;
        }
        this.scale = scale;
    }

    protected final float getScale() {
        return scale;
    }

    /*
    protected final void setRefPosition(float posRX, float posRY) {
        this.posRX = posRX;
        this.posRY = posRY;
        adjustParameter();
    }*/

    protected final float[] getRefPosition() {
        float[] refPosition = {posRX, posRY};
        return refPosition;
    }

    protected final void setBlend(int blend) {
        this.blend = blend;
    }

    protected final void setColor(color colors) {
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

    protected final void addState(String name, State state) {
        State cloneState = state.clone();
        states.put(name, cloneState.setObject(this));
    }

    protected final void enable() {
        isActive = true;
    }

    protected final void startState(String ... names) {
        isActive = true;
        for(String name : names) {
            if(states.get(name) == null) {
                println("Error:No such state");
                return;
            }
            states.get(name).enter();
        }
    }

    protected final void updateState() {
        if(!isActive) {
            return;
        }
        /*if(nowState != null) {
            nowState.update();
        }*/
        for(Entry<String, State> entry : states.entrySet()) {
            entry.getValue().update();
        }
        /*for(State subState : subStates) {
            subState.update();
        }*/
    }
/*
    protected final void transitionState(String name) {
        if(states.get(name) == null) {
            println("No such state");
            return;
        }
        nowState.dispose();
        nowState = states.get(name);
        nowState.start();
    }*/

    protected final void disable() {
        isActive = false;
    }

    // 実装メソッド
    protected final void draw() {
        if(!isActive) {
            return;
        }
        blendMode(blend);
        // 回転軸座標を図形の中心に移動
        concreteDraw();
        // 座標軸とブレンドモードを戻す
        blendMode(BLEND);
    }

    protected void concreteDraw() {};
    protected void adjustParameter() {};
}

private class GroupObject {
    GameObject[] objects;

    private GroupObject(GameObject ... objects) {
        this.objects = objects;
    }

    private void enable() {
        for(GameObject object : objects) {
            object.enable();
        }
    }

    private void disable() {
        for(GameObject object : objects) {
            object.disable();
        }
    }

    private void setBlend(int blend) {
        for(GameObject object : objects) {
            object.setBlend(blend);
        }
    }

    private void setColor(color colors) {
        for(GameObject object : objects) {
            object.setColor(colors);
        }
    }

    private void setAlpha(float alpha) {
        for(GameObject object : objects) {
            object.setAlpha(alpha);
        }
    }

    private void setRotation(float rotation) {
        for(GameObject object : objects) {
            object.setRotation(rotation);
        }
    }

    private void setScale(float scale) {
        for(GameObject object : objects) {
            object.setScale(scale);
        }
    }

    protected final void addState(String name, State state) {
        for(GameObject object : objects) {
            object.addState(name, state);
        }
    }

    protected final void startState(String ... names) {
        for(GameObject object : objects) {
            object.startState(names);
        }
    }
}

/*private class RotateFigureObject extends LifeCycleObject {
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
        /*
        rectMode(CENTER);
        noStroke();
        blendMode(ADD);
        rect(0, 0, sizeX, sizeY);
        // 座標軸とブレンドモードを戻す
        popMatrix();
        blendMode(BLEND);
    }
}*/

/*private class OverlayObject extends LifeCycleObject {
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
}*/
