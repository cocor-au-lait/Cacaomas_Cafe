import java.io.*;                            // ファイルの読み書き
import java.math.BigDecimal;

import ddf.minim.*;
import processing.sound.*;
import org.gamecontrolplus.*;                // ゲームパッド用
import de.bezier.data.sql.*;

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
// データベース
private SQLite db;
// フォント（暫定）
private PFont font;
// 音楽ファイルコア
private Minim minim;
// 画面移動描画クラス
private StateMove stateMove;
// 譜面ファイル制御クラス
private BmsController bms;
// 各画面のスーパークラス
private State state;
// 画面切り替えの際にオーバーレイして切り替えアニメーションをするThreadクラス
private StateTransition transition;
// 別Statedでアプレットを読み込むための変数
private PApplet applet;
private Thread thread;

public void setup() {
    thread = new SetupThread(this);
    thread.start();
    // MacBook Pro 13インチのデフォルトより1段階低い解像度
    size(1280, 800, P3D);
    frameRate(60);
    //smooth(4);
    //fullScreen(P2D);
    pixelDensity(2); //retinaに対応
    //noCursor();
    state = new SetupState();
    transition = new StateTransition();
}

public void draw() {
    // 各ステートにおける動作、描画
    state = state.doState();
    transition.drawTransition();
}
