import java.io.*;                            // ファイルの読み書き
import java.math.BigDecimal;

import ddf.minim.*;
import processing.sound.*;
import org.gamecontrolplus.*;                // ゲームパッド用

// ゲームパッド用パーツ用意
private ControlIO control;
private ControlDevice device;
private ControlButton[] button;
private ControlSlider scratch;

// キー制御
private boolean[] onKey;
private boolean[] press;
private int scratch_status;
private ArrayList<Boolean> bl_key_stat;     //キーを覚える配列（同時押し用）

private PFont font;                         // 暫定

private boolean isLoading;                  // スレッド終了判定フラグ

private State state;                        // 各画面のスーパークラス

private PApplet applet;                     // 別クラスでの"this"の代替

private int phase;                          // 0:open 1:stay 2:close 3:move
private boolean controlable;                // 操作の制御

public void setup() {
    // MacBook Pro 13インチのデフォルトより1段階低い解像度
    size(1280, 800, P2D);
    frameRate(60);
    //fullScreen(P2D);
    pixelDensity(2); //retinaに対応
    //noCursor();

    applet = this;

    // リソースロード用のスレッドの起動
    isLoading = true;
    Thread t = new Thread(new LoadThread());
    t.start();
}

public synchronized void draw() {
    if(isLoading) {
        background(255, 200, 180);
        textSize(60);
        textAlign(CENTER);
        text("Now Loading...", width / 2, height / 2);
    } else {
        keyControll();
        // 動作は各クラス側で行う
        state = state.doState();
    }
}

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

public void setText(int size, int col, int align) {
    textFont(font);  //設定したフォントを使用
    textSize(size);
    //textFont(createFont("Arial", 50));
    textAlign(align);
    fill(col);
}

// バックグラウンド処理はこちら側に書く
public class LoadThread implements Runnable {
    public synchronized void run() {
        font = createFont("Georgia", 100);
        bl_key_stat = new ArrayList<Boolean>();
        for(int i = 0; i < 8; i++) {
            bl_key_stat.add(false);
        }
        onKey = new boolean[8];

        //ゲームパッドの設定/////////////////////////////////////////////////////////////////////
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
        ////////////////////////////////////////////////////////////////////////////////////

        // タイトル画面のクラスの呼び出し
        state = new PlayState();
        isLoading = false;
    }
}
