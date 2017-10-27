private abstract class Scene implements Runnable {
    protected boolean controllable;         // 操作の受け付けの制御
    private boolean hasCached;
    private Thread thread;                // リソースの初期化を裏で行うスレッド
    private boolean isActive;
    private int sceneFrame;
    protected int sceneTime;
    protected List<GameObject> objects = new ArrayList<GameObject>();
    protected Map<String, Sequence> sequences = new HashMap<String, Sequence>();

    private Scene() {
        // リソースの初期化を裏で開始する
        thread = new Thread(this);
        thread.start();
    }

    // Entryと同じ
    public void run() {
        // 画像などのリソースをこちらで読み込むことで
        // バックでロード中のアニメーションを描画可能
    }

    // リソースの読み込みが終わっているか
    protected final boolean hasLoaded() {
        return !thread.isAlive();
    }

    protected final boolean isActive() {
        return isActive;
    }

    protected final void stopScene() {
        isActive = false;
    }

    protected final void startScene() {
        startScene("enterSQ");
    }

    protected final void startScene(String ... sequenceNames) {
        cacheObjects();
        for(String sequenceName : sequenceNames) {
            Sequence sequence = sequences.get(sequenceName);
            if(sequence == null) {
                println("Error:No such sequence");
                exit();
            }
            sequence.startSequence();
        }
        isActive = true;
    }

    protected final void enableObjects(GameObject ... objects) {
        for(GameObject object : objects) {
            object.enableObject();
        }
    }

    protected final void enableObjects() {
        for(GameObject object : objects) {
            object.enableObject();
        }
    }

    protected final void disableObjects(GameObject ... objects) {
        for(GameObject object : objects) {
            object.disableObject();
        }
    }

    protected final void disableObjects() {
        for(GameObject object : objects) {
            object.disableObject();
        }
    }

    protected final void addObjects(GroupObject ... groups) {
        for(GroupObject group : groups) {
            for(GameObject object : group.getObjects()) {
                objects.add(object);
            }
        }
    }

    protected final void processScene() {
        if(!isActive) {
            return;
        }
        // 各シーンの全オブジェクトに付与されているステートの更新を行う
        for(GameObject object : objects) {
            object.updateState();
        }
        for(Entry<String, Sequence> entry : sequences.entrySet()) {
            entry.getValue().processSequence();
        }
        sceneTime = toTime(++sceneFrame);
    }

    protected void cacheObjects() {
        for(GameObject object : objects) {
            float tempAlpha = object.getAlpha();
            object.enableObject();
            object.setAlpha(0.0f);
            object.drawObject();
            object.setAlpha(tempAlpha);
            object.disableObject();
            hasCached = true;
        }
    }

    private final void drawScene() {
        if(!isActive || overFrame == 0) {
            return;
        }
        // オブジェクトを宣言した順に描画を行う
        for(GameObject object : objects) {
            object.drawObject();
        }
    }

    protected abstract Scene disposeScene();
}
