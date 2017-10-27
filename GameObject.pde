private abstract class GameObject implements Cloneable {
    private boolean isActive;
    protected boolean isFreeRef;
    protected float posX, posY, posX2, posY2, sizeX, sizeY, posRX, posRY, rotation;
    protected float number;
    protected float scale = 1.0f;
    protected float alpha = 1.0f;
    private int blend = BLEND;
    protected color colors;
    protected float colorH, colorS, colorB;
    protected Map<String, State> states = new HashMap<String, State>();
    //protected ArrayList<State> subStates = new ArrayList<State>();

    @Override
    public GameObject clone(){
        GameObject object = new GameObject() {
            @Override protected void concreteDraw() {};
            @Override protected void adjustParameter() {};
        };
        try {
            object = (GameObject)super.clone();
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

    protected final void addPosition(float posX, float posY) {
        this.posX += posX;
        this.posY += posY;
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

    protected final void addPosition2(float posX2, float posY2) {
        this.posX2 += posX2;
        this.posY2 += posY2;
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

    protected final void addSize(float sizeX, float sizeY) {
        this.sizeX += sizeX;
        this.sizeY += sizeY;
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

    protected final void addScale(float scale) {
        this.scale += scale;
        if(scale < 0.0f) {
            this.scale = 0.0f;
        }
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

    protected final void setColor(float colorB) {
        setColor(0.0f, 0.0f , colorB);
    }

    protected final void setColor(float colorH, float colorS, float colorB) {
        float[] colorHSB = {colorH, colorS, colorB};
        for(float c : colorHSB) {
            if(c > 100.0f) {
                c = 100.0f;
            } else if(c < 0.0f) {
                c = 100.0f;
            }
        }
        this.colorH = colorHSB[0];
        this.colorS = colorHSB[1];
        this.colorB = colorHSB[2];
        setColor(color(colorHSB[0], colorHSB[1], colorHSB[2]));
    }

    protected final color getColor() {
        return colors;
    }

    protected final float getColorB() {
        return colorB;
    }

    protected final float[] getColorHSB() {
        float[] colorHSB = {colorH, colorS, colorB};
        return colorHSB;
    }

    protected final void setAlpha(float alpha) {
        this.alpha = alpha;
        alpha = constrain(alpha, 0.0f, 1.0f);
    }

    protected final void addAlpha(float alpha) {
        this.alpha += alpha;
        alpha = constrain(alpha, 0.0f, 1.0f);
    }

    protected final float getAlpha() {
        return alpha;
    }

    protected final void setNumber(float number) {
        this.number = number;
    }

    protected final void addNumber(float number) {
        this.number += number;
    }

    protected final float getNumber() {
        return number;
    }

    protected final void setRotation(float rotation) {
        this.rotation = rotation;
        rotation %= 360;
    }

    protected final void addRotation(float rotation) {
        this.rotation += rotation;
        rotation %= 360;
    }

    protected final float getRotation() {
        return rotation;
    }

    protected final void addState(String name, State state) {
        State cloneState = state.clone();
        states.put(name, cloneState.setObject(this));
    }

    protected final void enableObject() {
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

    protected final void stopState(String ... names) {
        for(String name : names) {
            if(states.get(name) == null) {
                println("Error:No such state");
                return;
            }
            states.get(name).exitState();
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

    protected final void disableObject() {
        isActive = false;
    }

    // 実装メソッド
    protected final void drawObject() {
        if(!isActive) {
            return;
        }
        blendMode(blend);
        concreteDraw();
        // 座標軸とブレンドモードを戻す
        blendMode(BLEND);
    }

    protected abstract void concreteDraw();
    protected abstract void adjustParameter();
}
