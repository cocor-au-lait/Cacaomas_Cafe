public abstract class State{
    protected int select;             // 画面で選んでる項目
    protected Thread thread;
    protected int phase;                          // 0:open 1:stay 2:close 3:move
    protected boolean controlable;                // 操作の制御
    protected int start_time;
    protected int elapsed_time;

    public State doState() {
        elapsed_time = millis() - start_time;
        // 画面描画アニメーション
        if(now_loading) {
            loadingState();
        } else {
            // キーボードとコントローラーの監視
            keyControll();
            drawState();
        }
        //状況に応じて上書き描画
        /*
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
        */

        return this;
    }

    public abstract void loadingState();        // ロード中の描画を行う
    public abstract void drawState();           // メインの描画を行う
    public abstract State nextState();          // 次の画面を呼び出す

    public void keyPressed() {
        if(!controlable) {
            return;
        }
        switch(keyCode) {
        case ESC:
            exit();
        case SHIFT:
            bl_key_stat.set(5, true);        //SCRATCH
            break;
        case ENTER:
            case RETURN:
            bl_key_stat.set(6, true);        //START
            break;
        case TAB:
            bl_key_stat.set(7, true);       //SELECT
            break;
        }

        switch(key) {
        case 'c':
        case 'C':
            bl_key_stat.set(0, true);
            break;
        case 'v':
        case 'V':
            bl_key_stat.set(1, true);
            break;
        case 'b':
        case 'B':
            bl_key_stat.set(2, true);
            break;
        case 'n':
        case 'N':
            bl_key_stat.set(3, true);
            break;
        case 'm':
        case 'M':
            bl_key_stat.set(4, true);
            break;
        }
    }

    public void keyReleased() {
        if(!controlable) {
            return;
        }
        switch(keyCode) {
        case SHIFT:
            bl_key_stat.set(5, false);
            break;
        case ENTER:
        case RETURN:
            bl_key_stat.set(6, false);          //START
            break;
        case TAB:
            bl_key_stat.set(7, false);          //SELECT
            break;
        }

        switch(key) {
        case 'c':
        case 'C':
            bl_key_stat.set(0, false);
            break;
        case 'v':
        case 'V':
            bl_key_stat.set(1, false);
            break;
        case 'b':
        case 'B':
            bl_key_stat.set(2, false);
            break;
        case 'n':
        case 'N':
            bl_key_stat.set(3, false);
            break;
        case 'm':
        case 'M':
            bl_key_stat.set(4, false);
            break;
        }
    }

    public void keyControll() {
        //キーの処理
        press = new boolean[8];

        // 白黒ボタン & その他キー
        for(int i = 0; i < 8; i++) {
            if(bl_key_stat.get(i) || (button[i] != null && button[i].pressed())) {
                // キーボードかジョイスティックの入力があった場合
                if(!onKey[i]) {
                    // まだ押されていなければ押された瞬間とする
                    press[i] = true;
                    onKey[i] = true;
                }
            } else {
                // 押されていなければフラグをリセット
                onKey[i] = false;
            }
        }

        // スクラッチの処理
        if(bl_key_stat.get(5) || (scratch != null && scratch.getValue() == 1.0)) {
            // 右回転
            if(scratch_status != 1) {
                // 以前が停止か左回りなら回した瞬間とする
                press[5] = true;
                scratch_status = 1;
            }
        }
        else if(bl_key_stat.get(5) || (scratch != null && scratch.getValue() == -1.0)) {
            // 左回転
            if(scratch_status != -1) {
                // 以前が停止か右回りなら回した瞬間とする
                press[5] = true;
                scratch_status = -1;
            }
        }
        else {
            // 回転停止
            scratch_status = 0;
        }
    }
}
