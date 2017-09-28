import java.io.*;                   // ファイルの読み書き
import java.math.BigDecimal;

import ddf.minim.*;
// ###将来的にサウンドファイルをMinimに統一する可能性
// SoundFileだと読み込みの際にappletを引数に入れないといけないため
import processing.sound.*;
import org.gamecontrolplus.*;       // ゲームパッド用
import de.bezier.data.sql.*;        // データベース用

// 以下の変数は一度インスタンスするだけでいいためこちらに記述
// 譜面ファイル制御クラス
private BmsController bms;
// データベース管理
private SQLite db;
// データベースprivate SQLite db;
// ###加えて各ステートで使うフォントを読み込ませる
private PFont font;
// 音楽ファイルコア（画面遷移の際にも音が再生できるようにグローバル変数として設定）
private Minim minim;
// 各画面スーパークラス
private State state;
// 画面遷移描画スーパークラス
private State transition;
// ボタン、キーボードの監視クラス
private InputListner listener;
private PApplet applet;
// キーを覚える配列（同時押し用）
private ArrayList<Boolean> keyStatus;

private FrameRate debugFramerate = new FrameRate(60);

public void setup() {
    // MacBook Pro 13インチのデフォルトより1段階低い解像度
    // GPUパワーを使うためP2Dレンダーを使用
    // !!!FX2Dレンダーはフォントが設定できなくなるので断念
    size(1280, 800, P2D);
    //fullScreen(P2D);
    frameRate(60);
    colorMode(HSB);
    //smooth(4);
    pixelDensity(2);    //retina解像度に対応
    //noCursor();
    applet = this;
    font = createFont("PrestigeEliteStd-Bd", 70, true);
    state = new SetupState();
}

public void draw() {
    debugFramerate.Update();
    surface.setTitle(debugFramerate.fps + "fps");
    // 各ステートにおける動作、描画
    listener.keyControll();
    state.doState();
    transition.doState();
}
// キーボードを押した時の処理（メインクラスでしか記述できないため）
public void keyPressed() {
    switch(keyCode) {
    case ESC:
        exit();
    case SHIFT:
        keyStatus.set(5, true);        //SCRATCH
        break;
    case ENTER:
    case RETURN:
        keyStatus.set(6, true);        //START
        break;
    case TAB:
        keyStatus.set(7, true);       //SELECT
        break;
    }

    switch(key) {
    case 'c':
    case 'C':
        keyStatus.set(0, true);
        break;
    case 'v':
    case 'V':
        keyStatus.set(1, true);
        break;
    case 'b':
    case 'B':
        keyStatus.set(2, true);
        break;
    case 'n':
    case 'N':
        keyStatus.set(3, true);
        break;
    case 'm':
    case 'M':
        keyStatus.set(4, true);
        break;
    }
}
// キーボードを離した時の処理（メインクラスでしか記述できないため）
public void keyReleased() {
    switch(keyCode) {
    case SHIFT:
        keyStatus.set(5, false);
        break;
    case ENTER:
    case RETURN:
        keyStatus.set(6, false);          //START
        break;
    case TAB:
        keyStatus.set(7, false);          //SELECT
        break;
    }

    switch(key) {
    case 'c':
    case 'C':
        keyStatus.set(0, false);
        break;
    case 'v':
    case 'V':
        keyStatus.set(1, false);
        break;
    case 'b':
    case 'B':
        keyStatus.set(2, false);
        break;
    case 'n':
    case 'N':
        keyStatus.set(3, false);
        break;
    case 'm':
    case 'M':
        keyStatus.set(4, false);
        break;
    }
}
