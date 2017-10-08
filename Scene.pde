private abstract class Scene implements Runnable {
    //protected int sceneStartTime;           // インスタンス時の時間(ms)
    //protected int sceneElapsedTime;         // インスタンスから経過した時間(ms)
    //protected int stepStartTime;            // 任意のタイミングで取得する時間(ms)
    //protected int stepElapsedTime;          // 任意のタイミングから経過した時間(ms)
    private int sceneElapsedFrame;
    protected int sceneElapsedTime;
    protected boolean controllable;         // 操作の受け付けの制御
    private Thread thread;                // リソースの初期化を裏で行うスレッド
    private boolean canDraw;
    protected Map<String, GameObject> objects;

    private Scene() {
        objects = new LinkedHashMap<String, GameObject>();
        // リソースの初期化を裏で開始する
        thread = new Thread(this);
        thread.start();
    }

    /*
    protected void run() {
        // 画像などのリソースをこちらで読み込むことで
        // バックでロード中のアニメーションを描画可能
    }
    */

    protected final void startScene() {
        canDraw = true;
    }

    // リソースの読み込みが終わっているか
    protected final boolean hasLoaded() {
        return !thread.isAlive();
    }

    private final void play() {
        if(!canDraw) {
            return;
        }
        // 経過時間の算出
        //sceneElapsedTime = millis() - sceneStartTime;
        //stepElapsedTime = millis() - stepStartTime;
        for(i = 0; i < frameTimer.getDiffFrame(); i++) {
            sceneElapsedFrame++;
            sceneElapsedTime = (int)((float)sceneElapsedFrame * 60.0f / 1000.0f);
            manageObjects();
        }
        // オブジェクトを宣言した順に描画を行う
        for(Map.Entry<String, GameObject> entry : objects.entrySet()) {
            entry.getValue().draw();
        }
    }

    protected abstract void manageObjects();
    /********************1.STANBY********************/
    /*---------------------LOOP---------------------*/
    /*-------------------TRIGGER--------------------*/
    /********************2.ACTION********************/
    /********************3.STEPUP********************/
    /**********************END***********************/
}

private class EmptyScene extends Scene {
    public void run() {}
    protected void manageObjects() {}
}
