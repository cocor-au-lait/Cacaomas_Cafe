class PlayState extends State {

    static final long PERFECT_RANGE = 9600 / 48;      // PERFECTと判定する中心からの範囲(前後合わせて24分音符内)
    static final long GREAT_RANGE = 9600 / 32;      // GREATと判定する中心からの範囲(前後合わせて16分音符内)
    static final long GOOD_RANGE = 9600 / 8;       // GOODと判定する中心からの範囲(前後合わせて4分音符内)
    static final long BAD_RANGE = 9600 / 4;       // BADと判定する中心からの範囲(前後合わせて2分音符内)
    static final long POOR_RANGE = 9600 / 2;       // POOR判定する中心からの範囲(前後合わせて1小節内)
    static final int BASE_SPEED = 400;

    FrameTimer tm = new FrameTimer();

    float scr_multi;        // 小節間の幅の倍率
    long game_start_time;   // ゲーム開始時の時間(高解像度タイマー)
    double elapsed_time;    // 開始からの経過時間(秒)
    int image_id;           // 現在表示されているアニメーションインデックス番号
    int start_num[];        // BMS演奏で計算開始する配列番号(処理を軽くするため)

    // 演出など
    int flash_index[];      // 次に使用されるフラッシュカウンタのインデックス
    int flash_count[][];    // フラッシュ６ｘ３個分のカウンタ
    int back_key_count[];   // キーを離した時の後ろのバックライトの演出用カウンタ
    int judge_count;        // 判定画像用演出カウンタ
    int near_judge_count;   // fast,slow演出カウンタ

    BigDecimal highspeed = new BigDecimal("2.5");    // 譜面のスクロールスピード
    long adjust = -170;    // 判定調節用（+に行くほど判定が早めになる）

    PImage img;        // 全体画像
    PImage parts[];    // 部品画像

    ScoreData score_data;    // スコア情報関連

    // 暫定要素/////////////////////////////
    boolean isFinish;
    PImage test[];
    int test_judge;
    int near;
    int obj_num;
    double obj_score, display_score, pre_score;
    float obj_gauge, display_gauge, pre_gauge;
    PImage jacket;
    ////////////////////////////////////////

    boolean isAutoplay = false;
    long bgm_adjust = 200;  //BGM再生のタイミング調節

    final int index[]= {0, 1, 2, 3, 4, 5};                     // インデックスリスト
    final int obj_kind[] = {0, 1, 0, 1, 0 ,2};                 // オブジェの種類（0：白鍵盤  1：黒鍵盤  2：スクラッチ）
    final float obj_x[] = {451 , 526, 601, 676, 751, 827};       // オブジェ表示X座標
    final float obj_fx[] = {451 , 526, 601, 676, 751, 819};       // フラッシュ表示X座標

    SoundFile music[];

    PlayState() {
        // BMSファイルのロード
        if(!bms.load("data/song/banana_ore/banana_ore.bms")) {
            println("BMSファイル読み込みエラー");
            exit();
        }

        music = new SoundFile[50];

        for(int i = 0; i < music.length; i++) {
            String wav_name = bms.getWavFile(i);
            // WAVファイル名が存在するなら
            if(wav_name != null) {
                music[i] = new SoundFile(applet, "song/banana_ore/" + wav_name);
                // 再生してキャッシングが必要？
                music[i].amp(0.0);
                println("song/banana_ore/" + wav_name);
                music[i].play();
                music[i].stop();
                music[i].amp(1.0);
            }
        }

        // ゲーム用変数の初期化
        scr_multi = 1.0f;
        /*
        elapsed_time = 0;
        game_start_time = 0;
        elapsed_time = 0;
        image_id = 0;
        */
        start_num = new int[1296];
        flash_index = new int[6];
        flash_count = new int[6][3];
        back_key_count = new int[6];

        score_data = new ScoreData();

        // 画像の読み込み
        img = loadImage("image/parts/play_texture.png");
        parts = new PImage[255];
        parts[0] = img.get( 0, 0, 455, 719 );    //レーン
        parts[1] = img.get( 455, 521, 73, 52 );  //ノーツ1
        parts[2] = img.get( 528, 521, 73, 52 );  //ノーツ2
        parts[3] = img.get( 601, 521, 77, 83 );  //ノーツ3
        parts[4] = img.get( 455, 0, 73, 521 );   //キービーム1
        parts[5] = img.get( 528, 0, 73, 521 );   //キービーム2
        parts[6] = img.get( 601, 0, 73, 521 );   //キービーム3
        parts[7] = img.get( 455, 573, 73, 73 );  //爆発1
        parts[8] = img.get( 528, 573, 73, 73 );  //爆発2
        parts[9] = img.get( 601, 604, 77, 77 );  //爆発3

        // 暫定処理////////////////////////////////////////////////////////////////
        test = new PImage[5];
        test[0] = loadImage("image/poor.png");
        test[1] = loadImage("image/bad.png");
        test[2] = loadImage("image/good.png");
        test[3] = loadImage("image/great.png");
        test[4] = loadImage("image/perfect.png");
        jacket = loadImage("image/jacket.png");
        for(int i = 0; i < index.length; i++) {
            obj_num += bms.getObjeNum(0x11 + i);
        }
        obj_score = 10000000.0 / obj_num;
        obj_gauge = 300.0f / (float)obj_num;
        ////////////////////////////////////////////////////////////////////

        // 現在の時間を開始時間とする
        game_start_time = System.nanoTime();
    }

    public void loadingState() {
    }

    void drawState() {
        noStroke();
        rectMode(CENTER);
        noTint();
        blendMode(BLEND);
        //背景とパーツ
        background(255, 204, 102);
        imageMode(CENTER);
        image(parts[0], width / 2, height / 2);

        // 開始時から経過した時間を算出
        elapsed_time = (System.nanoTime() - game_start_time) / 1000000000.0;
        // 経過した時間から進んだBMSカウント値を算出
        long now_count = bms.getCountFromTime(elapsed_time);

        // BMSカウンタが曲の最大カウント+1小節を超えたら終了
        if(bms.getMaxCount() + bms.BMS_RESOLUTION <= now_count) {
            //プレイが終了
            if(!isFinish) {
                stateMove = new StateMove();
                phase = 2;
                isFinish = true;
            }
        }

        // BGMをタイミングにあわせて再生する
        for(int i = start_num[bms.BMS_BACKMUSIC]; i < bms.getObjeNum(bms.BMS_BACKMUSIC); i++) {
            BmsData bms_data = bms.getObje(bms.BMS_BACKMUSIC, i);
            if(now_count < bms_data.data_time - bgm_adjust)
                break;
            if(bms_data.judge_flag) {
                if(now_count >= bms_data.data_time - bgm_adjust) {
                    bms_data.judge_flag = false;
                    music[(int)bms_data.sound_data].play();
                    start_num[bms.BMS_BACKMUSIC]++;
                }
            }
        }

        // スクリーン座標上でのスクロール量を算出
        int scr_y = (int)((double)(now_count) / (bms.BMS_RESOLUTION / (BASE_SPEED * highspeed.doubleValue())));

        // 小節線の描画
        for(int i = start_num[0]; i < bms.getBarNum(); i++) {
            BmsBar bar = bms.getBar(i);
            // スクロールを考慮しないスクリーン座標上での原点からの座標値を算出
            int obj_y = (int)((double)(bar.b_time) / (bms.BMS_RESOLUTION / (scr_multi * BASE_SPEED * highspeed.doubleValue())));
            // スクロールを考慮した現在のY座標を算出
            int off_y = obj_y - scr_y;
            // 判定ラインより下ならもう表示はせず、次回からその次の小節から参照する
            if(off_y < 0) {
                start_num[0] = i + 1;
                continue;
            }
            // 画面の上より外ならばその先は全て描画スキップ
            if(off_y > 600 + 10) {
                break;
            }
            fill(200);
            rect(width / 2, 647 - off_y, 451, 10);
        }

        // ノーツの描画
        for(int i = 0; i < index.length; i++) {
            for(int j = start_num[0x11 + index[i]]; j < bms.getObjeNum(0x11 + index[i]); j++) {
                BmsData bms_data = bms.getObje(0x11 + index[i], j);
                int obj_y = (int)((double)bms_data.data_time / (bms.BMS_RESOLUTION / (BASE_SPEED * highspeed.doubleValue())));
                int off_y = obj_y - scr_y;
                if(off_y < 0) {
                    start_num[0x11 + index[i]] = j + 1;
                    continue;
                }
                if(off_y > 650) {
                    break;
                }
                if(obj_kind[i] != 2) {
                    image(parts[1 + obj_kind[i]], obj_x[index[i]], 647 - off_y);
                }
                else {
                    image(parts[1 + obj_kind[i]], obj_x[index[i]], 647 - off_y);
                }
            }
        }

        // 全チャンネル分を処理
        for(int j = 0; j < index.length; j++) {
            // 判定対象のチャンネルのオブジェをチェック
            for(int i = start_num[j + 0x11 + 0x20]; i < bms.getObjeNum(0x11 + j); i++) {
                BmsData bms_data = bms.getObje(0x11 + j, i);
                if(bms_data.judge_flag) {
                    // まだ未判定のオブジェなら
                    if(bms_data.data_time < (now_count - GOOD_RANGE)) {
                        // 良判定を過ぎたら全て見逃し扱いとする
                        bms_data.judge_flag = false;                       // オブジェを消す
                        // 見逃しpoor判定
                        test_judge = 0;
                        score_data.addPoor();
                        score_data.addGauge(-2.0);
                        judge_count = 30;
                        // 判定オブジェをその次からに変更
                        start_num[j + 0x11 + 0x20] = i + 1;
                        // 次のオブジェをチェック
                        continue;
                    }

                    // オブジェが判定外なら抜ける
                    if((now_count + POOR_RANGE) <= bms_data.data_time) {
                        break;
                    }

                    // オブジェが判定内ならキーが押された瞬間かをチェック
                    if(press[j]) {
                        // キーを押した瞬間なら精度判定
                        long sub = now_count - bms_data.data_time + adjust;       // オブジェとの差を絶対値で取得
                        near = sub < 0? 1 : -1;         //sub < 0でfast
                        sub = (long)abs(sub);

                        int press_judge = 0;
                        if(sub <= PERFECT_RANGE) {      // 判定値(0=POOR、1=BAD、2=GOOD、3=GREAT)
                            press_judge = 4;
                            test_judge= 4;
                            score_data.addPerfect(near);
                            score_data.addScore(obj_score * 1.0);
                            score_data.addGauge(obj_gauge);
                        }
                        else if(sub <= GREAT_RANGE) {
                            press_judge = 3;
                            test_judge= 3;
                            score_data.addGreat(near);
                            score_data.addScore(obj_score * 0.7);
                            score_data.addGauge(obj_gauge * 0.7);
                        }
                        else if(sub <= GOOD_RANGE) {
                            press_judge = 2;
                            test_judge= 2;
                            score_data.addGood(near);
                            score_data.addScore(obj_score * 0.4);
                            score_data.addGauge(obj_gauge * 0.4);
                        }
                        else if(sub <= BAD_RANGE) {
                            press_judge = 1;
                            test_judge= 1;
                            score_data.addBad(near);
                            score_data.addGauge(-2.0);
                        }
                        // もしMaxコンボよりコンボ数が大きければMaxコンボを更新
                        if(score_data.getCombo() > score_data.getMaxCombo()) {
                            score_data.addMaxCombo();
                        }

                        if(press_judge >= 1) {
                            // BAD以上ならオブジェを処理
                            bms_data.judge_flag = false;                       // オブジェを消す
                            // そのオブジェの音を再生
                            if(music[(int)bms_data.sound_data] != null) {
                                music[(int)bms_data.sound_data].play();
                            }
                            // 判定オブジェをその次からに変更
                            start_num[index[j] + 0x11 + 0x20]++;
                            // フラッシュ開始
                            flash_count[index[j]][ flash_index[index[j]] ] = 45;
                            // 判定描画開始
                            judge_count = 30;
                            // 次のインデックスへ
                            flash_index[index[j]]++;
                            if( flash_index[index[j]] > 2 ) {
                                flash_index[index[j]] = 0;
                            }
                            // 判定オブジェをその次からに変更
                            start_num[j + 0x11 + 0x20] = i + 1;
                            break;
                        }
                    }
                }
            }
        }

        // ノーツをタイミングにあわせて再生する（オートプレイ）
        if(isAutoplay) {
            for(int j = 0; j < index.length; j++) {
                for(int i = start_num[index[j] + 0x11 + 0x20]; i < bms.getObjeNum(0x11 + index[j]); i++) {
                    BmsData bms_data = bms.getObje(0x11 + index[j], i);
                    if(now_count < bms_data.data_time) {
                        break;
                    }
                    if(bms_data.judge_flag) {
                        if(now_count >= bms_data.data_time) {
                            bms_data.judge_flag = false;
                            if(music[(int)bms_data.sound_data] != null) {
                                music[(int)bms_data.sound_data].play();
                            }
                            start_num[index[j] + 0x11 + 0x20]++;

                            // フラッシュ開始
                            flash_count[index[j]][ flash_index[index[j]] ] = 45;
                            // 次のインデックスへ
                            flash_index[index[j]]++;
                            if( flash_index[index[j]] > 2 ) {
                                flash_index[index[j]] = 0;
                            }
                        }
                    }
                }
            }
        }

        // リアルタイムハイスピード（暫定）
        if(keyPressed && keyCode == UP && highspeed.doubleValue() < 5.0) {
            highspeed = highspeed.add(new BigDecimal("0.1"));
        }
        else if(keyPressed && keyCode == DOWN && highspeed.doubleValue() > 0.5) {
            highspeed = highspeed.subtract(new BigDecimal("0.1"));
        }

        // スコア
        if(score_data.getScore() != display_score) {
            display_score += lerp(0, (float)(score_data.getScore() - display_score), 0.5);
        }
        textAlign(LEFT);
        textSize(40);
        fill(0);
        text("SCORE", 20, 50);
        text(nf((int)(ceil((float)display_score)), 8), 20, 90);

        // 情報
        fill(0);
        textSize(25);
        text("maxcombo:" + score_data.getMaxCombo(), 20, 120);
        text("bpm:" + (int)bms.bms_header.bpm, 20, 150);
        text("highspeed:x" + highspeed, 20, 180);

        // リアルタイムジャッジ
        textAlign(RIGHT);
        text("combo:" + score_data.getCombo(), 150, 220);
        text("perfect:" + score_data.getPerfect(), 150, 250);
        text("great:" + score_data.getGreat(), 150, 280);
        text("good:" + score_data.getGood(), 150, 310);
        text("bad:" + score_data.getBad(), 150, 340);
        text("poor:" + score_data.getPoor(), 150, 370);
        text("fast:" + score_data.getfast(), 150, 420);
        text("slow:" + score_data.getSlow(), 150, 450);
        text("gauge:" + (int)score_data.getGauge() + "%", 150, 500);

        // ゲージの描画
        rectMode(CORNERS);
        fill(20);
        rect(1000, 100, 1100, 700);
        pre_gauge = (600f * constrain((score_data.getGauge() / 100.0f), 0.0f, 1.0f));
        if(display_gauge != pre_gauge) {
            display_gauge += lerp(0, (float)(pre_gauge - display_gauge), 0.5);
        }
        fill(255, 220, 30);
        rect(1000, 700 - (int)display_gauge, 1100, 700);
        fill(240, 120, 120);
        rect(1000, 700 - (int)display_gauge, 1100, 700);
        text("clear:" + score_data.isClear(), 1000, 720);

        // ジャケット描画（暫定）
        rectMode(CORNER);
        fill(0);
        rect(38, 538, 254, 254);
        imageMode(CORNER);
        image(jacket, 40, 540, 250, 250);


        // 鍵盤のバックライト
        for(int i = 0; i < 5; i++) {
            if(onKey[i]) {
                // キーが押された状態ならカウンタをリセット
                back_key_count[i] = 10;
            }
        }
        // スクラッチのバックライト
        if(scratch_status != 0) {
            // 右か左に回している状態ならカウンタをリセット
            back_key_count[5] = 10;
        }
        // キーのバックライト演出
        blendMode(ADD);         // 加算合成
        imageMode(CENTER);
        for(int i = 0; i < back_key_count.length; i++) {
            if(back_key_count[i] > 0) {
                tint( #FFFFFF, 255 * (float)back_key_count[i] /   10.0f);     // 徐々にフェードアウト
                image(parts[4 + obj_kind[i]], obj_x[i], 395);                                        // レーンの種類ごとにバックライト画像を表示
            }
        }


        // フラッシュ表示
        for(int i = 0; i < flash_count.length; i++) {
            for(int j = 0; j < flash_count[i].length; j++) {
                if(flash_count[i][j] > 0) {
                    // 演出が存在する場合のみ表示
                    float alpha = cos( flash_count[i][j] * 2 * PI / 180);
                    float rate = 1 + (float)cos( flash_count[i][j] * 2 * PI / 180);
                    PImage fximg = parts[7 + obj_kind[i]];
                    tint(#FFFFFF, 255 * alpha);
                    image(fximg, obj_fx[i], 647, fximg.width * rate, fximg.height * rate);
                }
            }
        }

        // 判定画像（暫定）
        if(judge_count > 0) {
            blendMode(BLEND);
            noTint();
            textAlign(CENTER);
            textSize(30);
            String message;
            if(near > 0) {
                message = new String("fast");
                fill(50, 50, 230);
            } else {
                message = new String("slow");
                fill(230, 50, 50);
            }

            switch(test_judge) {
                case 0:     //poor
                    image(test[0], width/2, height/2);
                    break;
                case 1:     //bad
                    image(test[1], width/2, height/2);
                    text(message, width / 2, 600);
                    break;
                case 2:     //good
                    image(test[2], width/2, height/2);
                    text(message, width / 2, 600);
                    break;
                case 3:     //great
                    image(test[3], width/2, height/2);
                    text(message, width / 2, 600);
                    break;
                case 4:     //perfect
                    image(test[4], width/2, height/2);
                    break;
            }
        }

        // 60FPSでのデータ操作
        int diff_frame = tm.runTimer();         //前回runTimerで呼び出してから何フレーム分進んだか
        //進んだフレーム文処理を行う
        for(int h = 0; h < diff_frame; h++) {
            // 後ろのバックライト演出
            for(int i = 0; i < back_key_count.length; i++) {
                if(back_key_count[i] > 0) {
                    back_key_count[i]--;
                }
            }
            // フラッシュ部
            for( int i = 0; i < flash_count.length; i++ ) {
                for( int j = 0; j < flash_count[i].length; j++ ) {
                    if( flash_count[i][j] > 0 ) {
                        flash_count[i][j] -= 3;
                    }
                }
            }
            // 判定画像
            if(judge_count > 0) {
                judge_count--;
            }
        }
    }

    void openState() {
        stateMove.fadeOut(1000);
    }

    void closeState() {
        stateMove.fadeIn(1000);
    }

    State nextState() {
        for(int i = 0; i < music.length; i++) {
            if(music[i] == null) {
                continue;
            }
            music[i].stop();
            music[i].dispose();
        }
        return new ResultState(score_data, bms.getHeader());
    }
}
