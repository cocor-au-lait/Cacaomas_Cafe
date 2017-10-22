import java.io.*;                   // ファイルの読み書き
import java.math.BigDecimal;
import java.util.*;
import java.util.Map.Entry;

import processing.video.*;
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
private PFont font0, appleChancery, bickham, ayuthaya, athelas, baoli, yuGothic, yuMincho;
// 音楽ファイルコア（画面遷移の際にも音が再生できるようにグローバル変数として設定）
private Minim minim;
// ポリモーフィズムを利用して各画面を構成
private Scene mainScene, subScene, bgScene;
// ボタン、キーボードの監視クラス
private InputListner keyListener;
private PApplet applet = this;
// キーを覚える配列（同時押し用）
private List<Boolean> keyStatus;
private static float DISPLAY_SCALE, DISPLAY_MAX_SCALE, WIDTH_MARGIN, HEIGHT_MARGIN;

private static final int FRAME_RATE = 60;
private static final int BASE_FRAME_RATE = 60;
private static final int BASE_WIDTH = 1280;
private static final int BASE_HEIGHT = 800;
// フレーム単位の処理を補助するタイマー
private FrameTimer frameTimer;
private int overFrame;
// デバッグ用平均FPS表示関数
private FrameRate debugFramerate = new FrameRate(FRAME_RATE);
private enum NumType {RELATIVE, ABSOLUTE}
private enum LoopType {RESTART, YOYO, RETURN}
private enum ParameterType {ALPHA, SCALE, POSITION, SIZE, ROTATION, COLOR}

private boolean hasLoadedMainScene, hasLoadedBackgroundScene;

private List<PlayerData> playerDate = new ArrayList<PlayerData>();

public void setup() {
    // MacBook Pro 13インチのデフォルトより1段階低い解像度
    // GPUパワーを使うためP2Dレンダーを使用
    // !!!FX2Dレンダーはフォントが設定できなくなるので断念
    size(1280, 800, P2D);
    //frame.setResizable(true);
    //fullScreen(P2D);
    pixelDensity(displayDensity());    //retina解像度に対応
    // 画面サイズの調節
    float widthScale = (float)width / (float)BASE_WIDTH;
    float heightScale = (float)height / (float)BASE_HEIGHT;
    // 拡大倍率が低い方を全体スケーリングにすることで部品のはみ出しを防ぐ
    if(widthScale < heightScale) {
        DISPLAY_SCALE = widthScale;
        DISPLAY_MAX_SCALE = heightScale;
        WIDTH_MARGIN = 0.0f;
        HEIGHT_MARGIN = (height - BASE_HEIGHT * DISPLAY_SCALE) / 2.0f;
    } else {
        DISPLAY_SCALE = heightScale;
        DISPLAY_MAX_SCALE = widthScale;
        WIDTH_MARGIN = (width - BASE_WIDTH * DISPLAY_SCALE) / 2.0f;
        HEIGHT_MARGIN = 0.0f;
    }

    //noCursor();
    frameRate(FRAME_RATE);
    //smooth(4);
    colorMode(HSB, 100.0f, 100.0f, 100.0f, 1.0f);
    font0 = createFont("PrestigeEliteStd-Bd", 70, true);
    frameTimer = new FrameTimer();
    bgScene = new BackgroundScene();
    subScene = new SetupScene();
}

public void draw() {
    if(!hasLoadedMainScene || !hasLoadedBackgroundScene) {
        return;
    }
    // デバッグ用FPS表示措置 ////////////////////////////////////////
    debugFramerate.Update();
    surface.setTitle(debugFramerate.fps + "fps");
    //////////////////////////////////////////////////////////////
    // 入力されたキーの処理を行う
    keyListener.manageInput();
    // 各画面の管理、描画
    int diffFrame = frameTimer.getDiffFrame();
    overFrame = 0;
    for(int i = 0; i < diffFrame; i++) {
        bgScene.processScene();
        mainScene.processScene();
        subScene.processScene();
        overFrame++;
    }
    bgScene.drawScene();
    mainScene.drawScene();
    subScene.drawScene();
    fill(0);
    rectMode(CORNER);
    rect(0, 0, WIDTH_MARGIN, height);
    rect(0, 0, width, HEIGHT_MARGIN);
    rect(width - WIDTH_MARGIN, 0, WIDTH_MARGIN, height);
    rect(0, height - HEIGHT_MARGIN, width, HEIGHT_MARGIN);
}

void movieEvent(Movie m) {
  m.read();
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
    case RIGHT:
        keyStatus.set(8, true);
        break;
    case LEFT:
        keyStatus.set(9, true);
        break;
    case UP:
        keyStatus.set(10, true);
        break;
    case DOWN:
        keyStatus.set(11, true);
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
    case RIGHT:
        keyStatus.set(8, false);
        break;
    case LEFT:
        keyStatus.set(9, false);
        break;
    case UP:
        keyStatus.set(10, false);
        break;
    case DOWN:
        keyStatus.set(11, false);
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