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
// スレッド終了判定フラグ
private boolean now_loading;
private PApplet applet;
// 各画面のスーパークラス
private State state;

// デバック用関数 //////////////////////////////
protected FPS fps;
/////////////////////////////////////////////

public void setup() {
    // MacBook Pro 13インチのデフォルトより1段階低い解像度
    size(1280, 800, P2D);
    frameRate(60);
    //smooth(4);
    //fullScreen(P2D);
    pixelDensity(2); //retinaに対応
    //noCursor();
    state = new SetupState(this);
}

public void draw() {
    // 動作は各クラス側で行う
    state = state.doState();
}