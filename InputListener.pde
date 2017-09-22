public class InputListner implements Runnable {
    // ゲームパッド用パーツ用意
    ControlIO control;
    private ControlDevice device;
    private ControlButton[] button;
    private ControlSlider scratch;
    // キー制御
    private boolean[] onKey;
    private boolean[] press;
    private int scratch_status;
    private ArrayList<Boolean> key_status;     //キーを覚える配列（同時押し用）
    Thread init;

    public InputListner() {
        init = new Thread(this);
        init.start();
    }

    public void run() {
        key_status = new ArrayList<Boolean>();
        for(int i = 0; i < 8; i++) {
            key_status.add(false);
        }
        onKey = new boolean[8];
        press = new boolean[8];
        button = new ControlButton[8];
        control = ControlIO.getInstance(applet);
        device = control.getMatchedDeviceSilent("beatmania_gamepad");
        if(device != null) {
            button[0] = device.getButton("bt1");
            button[1] = device.getButton("bt2");
            button[2] = device.getButton("bt3");
            button[3] = device.getButton("bt4");
            button[4] = device.getButton("bt5");
            button[5] = null;                       //本来はscratchが来る場所
            button[6] = device.getButton("sta");
            button[7] = device.getButton("sel");
            scratch = device.getSlider("scr");
        }
    }

    public void keyPressed() {
        if(init.isAlive()) {
            return;
        }
        switch(keyCode) {
        case ESC:
            exit();
        case SHIFT:
            key_status.set(5, true);        //SCRATCH
            break;
        case ENTER:
            case RETURN:
            key_status.set(6, true);        //START
            break;
        case TAB:
            key_status.set(7, true);       //SELECT
            break;
        }

        switch(key) {
        case 'c':
        case 'C':
            key_status.set(0, true);
            break;
        case 'v':
        case 'V':
            key_status.set(1, true);
            break;
        case 'b':
        case 'B':
            key_status.set(2, true);
            break;
        case 'n':
        case 'N':
            key_status.set(3, true);
            break;
        case 'm':
        case 'M':
            key_status.set(4, true);
            break;
        }
    }

    public void keyReleased() {
        if(init.isAlive()) {
            return;
        }
        switch(keyCode) {
        case SHIFT:
            key_status.set(5, false);
            break;
        case ENTER:
        case RETURN:
            key_status.set(6, false);          //START
            break;
        case TAB:
            key_status.set(7, false);          //SELECT
            break;
        }

        switch(key) {
        case 'c':
        case 'C':
            key_status.set(0, false);
            break;
        case 'v':
        case 'V':
            key_status.set(1, false);
            break;
        case 'b':
        case 'B':
            key_status.set(2, false);
            break;
        case 'n':
        case 'N':
            key_status.set(3, false);
            break;
        case 'm':
        case 'M':
            key_status.set(4, false);
            break;
        }
    }

    public void keyControll() {
        if(init.isAlive()) {
            return;
        }
        //キーの処理
        press = new boolean[8];

        // 白黒ボタン & その他キー
        for(int i = 0; i < 8; i++) {
            if(key_status.get(i) || (button[i] != null && button[i].pressed())) {
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
        if(key_status.get(5) || (scratch != null && scratch.getValue() == 1.0)) {
            // 右回転
            if(scratch_status != 1) {
                // 以前が停止か左回りなら回した瞬間とする
                press[5] = true;
                scratch_status = 1;
            }
        }
        else if(key_status.get(5) || (scratch != null && scratch.getValue() == -1.0)) {
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