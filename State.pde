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
