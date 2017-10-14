 import java.io.*;                   // ファイルの読み書き
import java.math.BigDecimal;
import java.util.Map;
import java.util.Map.Entry;
import java.util.LinkedHashMap;
import java.util.LinkedList;

import ddf.minim.*;
import processing.sound.*;
import org.gamecontrolplus.*;       // ゲームパッド用
import de.bezier.data.sql.*;        // データベース用

// 以下の変数は一度インスタンスするだけでいいためこちらに記述
// 譜面ファイル制御クラス
//private BmsController bms;
// データベース管理
private SQLite db;
// ###加えて各ステートで使うフォントを読み込ませる
private PFont font0, font1, font2, font3;
// 音楽ファイルコア（画面遷移の際にも音が再生できるようにグローバル変数として設定）
private Minim minim;
// ポリモーフィズムを利用して各画面を構成
private Scene mainScene, subScene;
// ボタン、キーボードの監視クラス
private InputListner inputListener;
private PApplet applet = this;
// キーを覚える配列（同時押し用）
private ArrayList<Boolean> keyStatus;
private float displayScale, marginScale, widthMargin, heightMargin;

private static final int FRAME_RATE = 60;
private static final int BASE_FRAME_RATE = 60;
private static final int BASE_WIDTH = 1280;
private static final int BASE_HEIGHT = 800;
// フレーム単位の処理を補助するタイマー
private FrameTimer frameTimer = new FrameTimer();
// デバッグ用平均FPS表示関数
private FrameRate debugFramerate = new FrameRate(FRAME_RATE);
private enum LoopType {RESTART, YOYO, RETURN}
private enum ParameterType {ALPHA, SCALE, POSITION}

public void setup() {
    // MacBook Pro 13インチのデフォルトより1段階低い解像度
    // GPUパワーを使うためP2Dレンダーを使用
    // !!!FX2Dレンダーはフォントが設定できなくなるので断念
    size(1280, 800, P2D);
    //frame.setResizable(true);
    // 画面サイズの調節
    float widthScale = (float)width / (float)BASE_WIDTH;
    float heightScale = (float)height / (float)BASE_HEIGHT;
    // 拡大倍率が低い方を全体スケーリングにすることで部品のはみ出しを防ぐ
    if(widthScale < heightScale) {
        displayScale = widthScale;
        marginScale = heightScale;
        widthMargin = 0.0f;
        heightMargin = (height - BASE_HEIGHT * displayScale) / 2.0f;
    } else {
        displayScale = heightScale;
        marginScale = widthScale;
        widthMargin = (width - BASE_WIDTH * displayScale) / 2.0f;
        heightMargin = 0.0f;
    }
    //fullScreen(P2D);
    pixelDensity(displayDensity());    //retina解像度に対応

    //noCursor();
    frameRate(FRAME_RATE);
    //smooth(4);
    colorMode(HSB, 255.0f, 255.0f, 255.0f, 1.0f);
    font0 = createFont("PrestigeEliteStd-Bd", 70, true);
    subScene = new SetupScene();
}

public void draw() {

    // デバッグ用FPS表示措置 ////////////////////////////////////////
    debugFramerate.Update();
    surface.setTitle(debugFramerate.fps + "fps");
    //////////////////////////////////////////////////////////////
    // 入力されたキーの処理を行う
    inputListener.manageInput();
    // 各画面の管理、描画
    if(mainScene != null) {
        mainScene.process();
    }
    // 画面切り替えの際にオーバーレイする画面の管理、描画
    // メイン画面切り替えの際のつなぎ目として動作する
    // 普段は描画を行わない
    if(subScene != null) {
        subScene.process();
    }
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