public class InputListner extends Thread {
    // ゲームパッド用パーツ用意
    ControlIO control;
    private ControlDevice device;
    private ControlButton[] button;
    private ControlSlider scratch;
    // キー制御
    private boolean[] onKey;
    private boolean[] press;
    private int scratch_status;

    public void run() {
        keyStatus = new ArrayList<Boolean>();
        for(int i = 0; i < 8; i++) {
            keyStatus.add(false);
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

    public void keyControll() {
        //キーの処理
        press = new boolean[8];
        // 白黒ボタン & その他キー
        for(int i = 0; i < 8; i++) {
            if(keyStatus.get(i) || (button[i] != null && button[i].pressed())) {
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
        if(keyStatus.get(5) || (scratch != null && scratch.getValue() == 1.0)) {
            // 右回転
            if(scratch_status != 1) {
                // 以前が停止か左回りなら回した瞬間とする
                press[5] = true;
                scratch_status = 1;
            }
        }
        else if(keyStatus.get(5) || (scratch != null && scratch.getValue() == -1.0)) {
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