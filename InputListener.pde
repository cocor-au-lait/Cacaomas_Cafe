private class InputListner extends Thread {
    // ゲームパッド用パーツ用意
    ControlIO control;
    private ControlDevice device;
    private ControlButton[] button;
    private ControlSlider scratch;
    // キー制御
    private boolean[] onKey;
    private boolean[] press;
    private int scratchStatus;
    // 初期化をThreadで行わせることで描画の開始を早くする
    public void run() {
        keyStatus = new ArrayList<Boolean>();
        for(int i = 0; i < 12; i++) {
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

    private boolean isPressed(int num) {
        if(overFrame > 0) {
            return false;
        }
        return press[num];
    }

    private boolean isScratchStatus(int scratchStatus) {
        return this.scratchStatus == scratchStatus;
    }

    private void manageInput() {
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
        boolean keyStatusRight = keyStatus.get(5) || keyStatus.get(8) || keyStatus.get(11);
        boolean keyStatusLeft = keyStatus.get(5) || keyStatus.get(9) || keyStatus.get(10);
        if(keyStatusRight || (scratch != null && scratch.getValue() == 1.0)) {
            // 右回転
            if(scratchStatus != 1) {
                // 以前が停止か左回りなら回した瞬間とする
                press[5] = true;
                scratchStatus = 1;
            }
        }
        else if(keyStatusLeft || (scratch != null && scratch.getValue() == -1.0)) {
            // 左回転
            if(scratchStatus != -1) {
                // 以前が停止か右回りなら回した瞬間とする
                press[5] = true;
                scratchStatus = -1;
            }
        }
        else {
            // 回転停止
            scratchStatus = 0;
        }
    }
}
