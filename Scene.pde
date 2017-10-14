private abstract class Scene implements Runnable {
    protected boolean controllable;         // 操作の受け付けの制御
    private Thread thread;                // リソースの初期化を裏で行うスレッド
    private boolean isActive;
    private int sceneFrame;
    private int sceneTime;
    protected ArrayList<GameObject> objects = new ArrayList<GameObject>();
    protected ArrayList<Sequence> sequences = new ArrayList<Sequence>();

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

    protected final void startScene() {
        isActive = true;
    }

    private final void process() {
        if(!isActive) {
            return;
        }
        for(int i = 0; i < frameTimer.getDiffFrame(); i++) {
            for(GameObject object : objects) {
                object.checkState();
            }
            for(Sequence sequence : sequences) {
                sequence.process();
            }
        }
        // オブジェクトを宣言した順に描画を行う
        for(GameObject object : objects) {
            object.draw();
        }
        sceneTime = toTime(++sceneFrame);
    }

    protected abstract Scene dispose();
}
