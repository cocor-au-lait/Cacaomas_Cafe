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
private Transition transition;
// ボタン、キーボードの監視クラス
private InputListner listener;
// ###工夫をすればいらない関数かも
private PApplet applet;

public void setup() {
    // MacBook Pro 13インチのデフォルトより1段階低い解像度
    // GPUパワーを使うためP2Dレンダーを使用
    // !!!FX2Dレンダーはフォントが設定できなくなるので断念
    size(1280, 800, P2D);
    frameRate(60);
    //smooth(4);
    //fullScreen(P2D);
    pixelDensity(2);    //retinaに対応
    //noCursor();
    applet = this;
    state = new SetupState();
    transition = new DefaultTransition(-1);
}

public void draw() {
    // 各ステートにおける動作、描画
    state.doState();
    transition.doTransition();
}
