private abstract class State implements Cloneable {
    protected GameObject object;
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
        State state = new State() {
            @Override protected void onUpdate() {}
        };
        try {
            state = (State)super.clone();
            //state.object = this.object.clone();
        } catch (Exception e){
            e.printStackTrace();
        }
        return state;
    }
    // Stateを開始するメソッド
    protected final void enter() {
        stateFrame = 0;
        stateTime = 0;
        isActive = true;
        onEnter();
    }
    protected final void exitState() {
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

    protected void checkLoop() {
        if(loopType == LoopType.YOYO && !reverceFlag) {
            back();
            return;
        }
        if(loopCounter == loopNum) {
            exitState();
        }
        if(loopType == LoopType.RESTART || loopType == LoopType.YOYO) {
            replay();
        }
    }

    protected final State setObject(GameObject object) {
        this.object = object;
        return this;
    }
    /**
     * サブクラスにて詳細を記述
     */
    // Stateに遷移した時に実行するメソッド
    protected void onEnter() {}
    // Stateに留まっている時に実行するメソッド
    protected abstract void onUpdate();
    // Stateに遷移する時に実行するメソッド
    protected void onExit() {}
}

private class TweenState extends State {
    private ParameterType type;
    private float[] firstParam = new float[2];
    private float[] lastParam = new float[2];
    private float[] addParam = new float[2];
    private float[] paramRange = new float[2];
    private int duration, loopInterval;
    private Easing easing = new EasingLinear();
    private boolean freakyParam, additionalParam;

    // ディープコピーを可能とするためにオーバーライド
    @Override
    public TweenState clone() {
        TweenState state = new TweenState();
        try {
           state = (TweenState)super.clone();
           state.firstParam = Arrays.copyOf(this.firstParam, this.firstParam.length);
           state.lastParam = Arrays.copyOf(this.lastParam, this.lastParam.length);
           state.addParam = Arrays.copyOf(this.addParam, this.addParam.length);
           state.paramRange = Arrays.copyOf(this.paramRange, this.paramRange.length);
           //state.object = this.object.clone();
           // ???enumはcloneが必要？
        } catch (Exception e){
            e.printStackTrace();
        }
        return state;
    }

    private TweenState() {}

    private TweenState(ParameterType type) {
        this.type = type;
    }

    private TweenState setTween(float firstParam, float lastParam, int duration) {
        this.firstParam[0] = firstParam;
        this.lastParam[0] = lastParam;
        this.duration = duration;
        paramRange[0] = this.lastParam[0] - this.firstParam[0];
        return this;
    }

    private TweenState setTween(float firstParamX, float firstParamY, float lastParamX, float lastParamY, int duration) {
        this.firstParam[0] = firstParamX;
        this.firstParam[1] = firstParamY;
        this.lastParam[0] = lastParamX;
        this.lastParam[1] = lastParamY;
        this.duration = duration;
        paramRange[0] = this.lastParam[0] - this.firstParam[0];
        paramRange[1] = this.lastParam[1] - this.firstParam[1];
        return this;
    }

    private TweenState setFreakyTween(float lastParam, int duration) {
        this.lastParam[0] = lastParam;
        this.duration = duration;
        freakyParam = true;
        return this;
    }

    private TweenState setFreakyTween(float lastParamX, float lastParamY, int duration) {
        this.lastParam[0] = lastParamX;
        this.lastParam[1] = lastParamY;
        this.duration = duration;
        freakyParam = true;
        return this;
    }

    private TweenState setAdditionalTween(float addParam, int duration) {
        this.addParam[0] = addParam;
        this.duration = duration;
        freakyParam = true;
        additionalParam = true;
        return this;
    }

    private TweenState setAdditionalTween(float addParamX, float addParamY, int duration) {
        this.addParam[0] = addParamX;
        this.addParam[1] = addParamY;
        this.duration = duration;
        freakyParam = true;
        additionalParam = true;
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
        if(!freakyParam) {
            setParameter(0.0f);
            return;
        }
        getParameter();
    }

    @Override
    protected void onUpdate() {
        float ratio = getRatio(stateTime, duration, easing);
        setParameter(ratio);
        if(stateTime > duration + loopInterval) {
            stateFrame = toFrame(duration);
            checkLoop();
        } else if(stateTime < -loopInterval) {
            checkLoop();
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
        case ROTATION:
            firstParam[0] = object.getRotation();
            break;
        case COLOR:
            firstParam[0] = object.getColorB();
            break;
        }
        if(additionalParam) {
            lastParam[0] = firstParam[0] + addParam[0];
            lastParam[1] = firstParam[1] + addParam[1];
        }
        paramRange[0] = lastParam[0] - firstParam[0];
        paramRange[1] = lastParam[1] - firstParam[1];
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
        case ROTATION:
            object.setRotation(firstParam[0] + paramRange[0] * ratio);
            break;
        case COLOR:
            object.setColor(firstParam[0] + paramRange[0] * ratio);
            break;
        }
    }
}
