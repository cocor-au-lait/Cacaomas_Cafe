private abstract class Scene implements Runnable {
    protected boolean controllable;         // 操作の受け付けの制御
    private Thread thread;                // リソースの初期化を裏で行うスレッド
    private boolean isActive;
    private int sceneFrame;
    protected int sceneTime;
    protected List<GameObject> objects = new ArrayList<GameObject>();
    protected HashMap<String, Sequence> sequences = new HashMap<String, Sequence>();

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

    protected final void startScene(String ... sequenceNames) {
        for(String sequenceName : sequenceNames) {
            sequences.get(sequenceName).startSequence();
        }
        isActive = true;
    }

    private final void processScene() {
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

    private final void drawScene() {
        if(!isActive) {
            return;
        }
        // オブジェクトを宣言した順に描画を行う
        for(GameObject object : objects) {
            object.drawObject();
        }
    }

    protected abstract Scene disposeScene();
}
