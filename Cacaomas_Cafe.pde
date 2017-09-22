import java.io.*;                            // ファイルの読み書き
import java.math.BigDecimal;

import ddf.minim.*;
import processing.sound.*;
import org.gamecontrolplus.*;                // ゲームパッド用
import de.bezier.data.sql.*;

// 譜面ファイル制御クラス
private BmsController bms;
// データベース
private SQLite db;
// フォント（暫定）
private PFont font;

// 各画面のスーパークラス
private State state;
private Transition transition;
private InputeListner listener;
private PApplet applet;


public void setup() {
    // MacBook Pro 13インチのデフォルトより1段階低い解像度
    size(1280, 800, P3D);
    frameRate(60);
    //smooth(4);
    //fullScreen(P2D);
    pixelDensity(2); //retinaに対応
    //noCursor();
    applet = this;
    state = new SetupState();
    transition = new Transition1();
    listener = new InputListner();
}

public void draw() {
    // 各ステートにおける動作、描画
    state = state.doState();
    transition.drawTransition();
}
