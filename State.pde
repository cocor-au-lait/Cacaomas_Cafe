// ほとんどの場合無名クラスとして実装するものの、ディープコピーを可能とするためにAbstractは外している
private class State implements Cloneable {
    protected int stateFrame;
    protected int stateTime;
    protected int loopCounter, loopNum;
    protected LoopType loopType;
    private boolean reverceFlag;
    // Stateが起動しているかどうか
    private boolean isActive;

    // ディープコピーを可能とするためにオーバーライド
    @Override
    public State clone() {
        State state = new State();
        try {
           state = (State)super.clone();
        } catch (Exception e){
            e.printStackTrace();
        }
        return state;
    }
    // Stateを開始するメソッド
    protected final State enter() {
        stateFrame = 0;
        isActive = true;
        onEnter();
        return this;
    }
    protected final void exit() {
        isActive = false;
        onExit();
    }
    // StateのメソッドをFrameごとに実行
    protected final void update() {
        if(!isActive) {
            return;
        }
        onUpdate();
        if(!reverceFlag) {
            stateTime = toTime(++stateFrame);
        } else {
            stateTime = toTime(--stateFrame);
        }
    }

    protected final void back() {
        reverceFlag = true;
    }

    protected final void replay() {
        reverceFlag = false;
        stateFrame = 0;
        loopCounter++;
    }

    protected final boolean isActive() {
        return isActive;
    }

    /*protected final State setLoop(int loopNum, int loopType) {
        this.loopNum = loopNum;
        this.loopType = loopType;
        return this;
    }*/

    protected void checkLoop() {
        if(loopType == LoopType.YOYO && !reverceFlag) {
            back();
            return;
        }
        if(loopCounter == loopNum) {
            this.exit();
        }
        if(loopType == LoopType.RESTART) {
            replay();
        }
    }
    /**
     * サブクラスにて詳細を記述
     */
    // Stateに遷移した時に実行するメソッド
    protected void onEnter() {}
    // Stateに留まっている時に実行するメソッド
    protected void onUpdate() {}
    // Stateに遷移する時に実行するメソッド
    protected void onExit() {}
}

private class TweenState extends State {
    private GameObject object;
    private ParameterType type;
    private float[] firstParam = new float[2];
    private float[] lastParam = new float[2];
    private float[] paramRange = new float[2];
    private int duration, loopInterval;
    private Easing easing = new EasingLinear();

    private TweenState (GameObject object, ParameterType type) {
        this.object = object;
        this.type = type;
    }

    private TweenState setTween(float lastParam, int duration) {
        this.lastParam[0] = lastParam;
        this.duration = duration;
        return this;
    }

    private TweenState setTween(float lastParamX, float lastParamY, int duration) {
        this.lastParam[0] = lastParamX;
        this.lastParam[1] = lastParamY;
        this.duration = duration;
        return this;
    }

    private TweenState setEasing(Easing easing) {
        this.easing = easing;
        return this;
    }

    private TweenState setLoop(int loopNum, LoopType loopType, int loopInterval) {
        this.loopNum = loopNum;
        this.loopType = loopType;
        this.loopInterval = loopInterval;
        return this;
    }

    @Override
    protected void onEnter() {
        getParameter();
        paramRange[0] = lastParam[0] - firstParam[0];
        paramRange[1] = lastParam[1] - firstParam[1];
    }

    @Override
    protected void onUpdate() {
        float ratio = getRatio(stateTime, duration, easing);
        setParameter(ratio);
        if(stateTime > duration + loopInterval) {
            stateFrame = toFrame(duration);
            checkLoop();
        } else if(stateTime < -loopInterval) {
            replay();
        }
    }

    private void getParameter() {
        switch(type) {
        case ALPHA:
            firstParam[0] = object.getAlpha();
            break;
        case SCALE:
            firstParam[0] = object.getScale();
            break;
        case POSITION:
            float[] postition = object.getPosition();
            firstParam[0] = postition[0];
            firstParam[1] = postition[1];
            break;
        case SIZE:
            float[] size = object.getSize();
            firstParam[0] = size[0];
            firstParam[1] = size[1];
            break;
        }
    }

    private void setParameter(float ratio) {
        switch(type) {
        case ALPHA:
            object.setAlpha(firstParam[0] + paramRange[0] * ratio);
            break;
        case SCALE:
            object.setScale(firstParam[0] + paramRange[0] * ratio);
            break;
        case POSITION:
            object.setPosition(firstParam[0] + paramRange[0] * ratio,
                firstParam[1] + paramRange[1] * ratio);
            break;
        case SIZE:
            object.setSize(firstParam[0] + paramRange[0] * ratio,
                firstParam[1] + paramRange[1] * ratio);
            break;
        }
    }
}
