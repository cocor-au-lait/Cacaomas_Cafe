public abstract class State{
    protected int select;             // 画面で選んでる項目
    protected Minim minim;
    protected StateMove stateMove;    // 画面移動描画クラス
    protected BmsController bms;      // 譜面ファイル制御クラス

    // デバック用関数 //////////////////////////////
    FPS fps;
    /////////////////////////////////////////////

    public State() {
        phase = 0;
        minim = new Minim(applet);
        fps = new FPS(60);
        stateMove = new StateMove();
        bms = new BmsController();
    }

    public State doState() {
        drawState();
        //状況に応じて上書き描画
        switch(phase) {
            case 0:    //open
                openState();
                break;
            case 2:    //close
                closeState();
                break;
            case 3:    //move
                closeState();
                return nextState();
        }

        //fps&時間描画//////////////////////////////////////////////////
        fill(255);
        textSize(20);
        fps.update();
        fps.drawing(width * 0.95, height * 0.10);
        ///////////////////////////////////////////////////////////////

        return this;
    }

    public abstract void drawState();            // メインの描画を行う
    public abstract void openState();            // 移行直後の描画
    public abstract void closeState();           // 移行直前の描画
    public abstract State nextState();           // 次の画面を呼び出す
}
