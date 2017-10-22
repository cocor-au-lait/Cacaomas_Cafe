private abstract class GameObject implements Cloneable {
    private boolean isActive;
    protected boolean isFreeRef;
    protected float posX, posY, posX2, posY2, sizeX, sizeY, posRX, posRY, rotation;
    protected float scale = 1.0f;
    protected float alpha = 1.0f;
    private int blend = BLEND;
    protected color colors;
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

    protected final color getColor() {
        return colors;
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

private class GroupObject implements Cloneable {
    List<GameObject> objects;

    private GroupObject(GameObject ... objects) {
        this.objects = new ArrayList<GameObject>(Arrays.asList(objects));
    }

    @Override
    public GroupObject clone(){
        GroupObject group = new GroupObject();
        try {
            group = (GroupObject)super.clone();
            group.objects = new ArrayList<GameObject>();
            for(GameObject object : this.objects) {
                group.objects.add(object.clone());
            }
        } catch (Exception e){
            e.printStackTrace();
        }
        return group;
    }

    private List<GameObject> getObjects() {
        return objects;
    }

    private void jointGroup(GroupObject ... groups) {
        List<GameObject> temp = new ArrayList<GameObject>(this.objects);
        objects = new ArrayList<GameObject>();
        for(GroupObject group : groups) {
            this.addObjects(group.getObjects());
        }
        this.addObjects(temp);
    }

    private void addObjects(GameObject ... objects) {
        for(GameObject object : objects) {
            this.objects.add(object);
        }
    }

    private void addObjects(List<GameObject> objects) {
        for(GameObject object : objects) {
            this.objects.add(object);
        }
    }

    private void enableGroup() {
        for(GameObject object : objects) {
            object.enableObject();
        }
    }

    private void disableGroup() {
        for(GameObject object : objects) {
            object.disableObject();
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

    private void addAlpha(float alpha) {
        for(GameObject object : objects) {
            object.addAlpha(alpha);
        }
    }

    private void addPosition(float posX, float posY) {
        for(GameObject object : objects) {
            object.addPosition(posX, posY);
        }
    }

    private void setRotation(float rotation) {
        for(GameObject object : objects) {
            object.setRotation(rotation);
        }
    }

    private void addRotation(float rotation) {
        for(GameObject object : objects) {
            object.addRotation(rotation);
        }
    }

    private void setScale(float scale) {
        for(GameObject object : objects) {
            object.setScale(scale);
        }
    }

    private void addScale(float scale) {
        for(GameObject object : objects) {
            object.addScale(scale);
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
