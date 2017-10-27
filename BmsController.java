import java.io.*;

public class BmsController {
    //定義
    private static final double BMS_RESOLUTION = 9600.0;     // 1小節のカウント値
    private static final int BMS_MAXBUFFER = (16*16);   // 00～FFまでのバッファ数
    private static final int BMS_BACKMUSIC = 0x01;      // その位置にきたら、自動的に再生されるWAVを指定します
    private static final int BMS_STRETCH = 0x02;        // その小節の長さを定義したデータ倍します（10進数、小数ともに使用可）
    private static final int BMS_TEMPO = 0x03;          // 再生テンポ（BPM / 1分間の四分音符数）の途中変更（16進数）
    private static final int BMS_BACKANIME = 0x04;      // バックグラウンドアニメーション機能
    private static final int BMS_EXTENEDOBJ = 0x05;     // 落下してくるオブジェを別のキャラクターナンバーのものにすり替える機能
    private static final int BMS_CHGPOORANI = 0x06;     // POORを出したときに表示される画像を変更
    private static final int BMS_LAYERANIME = 0x07 ;    // Ch.04で指定したBGAの上にかぶせるBMPを指定できます

    private BmsHeader bms_header;
    private BmsBar[] bms_bar;
    private BmsData[][] bms_data;          // 実データ[ch][data]
    private int[] num_bms_data;            // 実データのそれぞれの数

    private String[] wav_file;            // WAVのファイル名
    private String[] bmp_file;            // BMPのファイル名

    private class BmsHeader {
        private long player;
        private String genre;
        private String title;          // データのタイトル
        private String artist;         // データの製作者
        private float bpm;             // 初期テンポ(初期値は130)
        private String midifile;
        private long playerlevel;      // データの難易度
        private long rank;
        private long volwav;           // 音量を元の何％にするか
        private long total;
        private String stagefile;
        private float[] bpmindex;
        private long end_bar;          //終了小節
        private long max_count;        // 最大のカウント数

        /*public String getTitle() {
            return title;
        }

        public String getArtist() {
            return artist;
        }

        public float getBpm() {
            return bpm;
        }*/
    }

    private class BmsBar {
        private float b_scale;         // この小節の長さ倍率
        private long b_time;           // この小節の開始位置(BMSカウント値)
        private long b_length;         // この小節の長さ(BMSカウント値)
    }

    private class BmsData {
        private long data_time;        // このデータの開始位置(BMSカウント値)
        private long sound_data;       // 鳴らすデータ(36進数 00~ZZ)
        private float tempo_data;      // 小数値データ(テンポ用)
        private boolean judge_flag;    // アプリが使用出来る任意の変数(ここでは判定に利用)
    }


    public BmsController() {
        // 変数の初期化
        bms_header = new BmsHeader();
        bms_header.bpmindex = new float[1001];
        bms_data = new BmsData[256][1296];
        for(int i = 0; i < bms_data.length; i++) {
            for(int j = 0; j < bms_data[0].length; j++) {
                bms_data[i][j] = new BmsData();
            }
        }
        num_bms_data = new int[1296];
        bms_bar = new BmsBar[1001];
        for(int i = 0; i < bms_bar.length; i++) {
            bms_bar[i] = new BmsBar();
            bms_bar[i].b_scale = 1.0f;
        }
        wav_file = new String[1296];    //36進数
        bmp_file = new String[1296];    //36進数
    }

    // ゲーム必須メソッド//////////////////////////////////////////////////////////

    // ゲーム内の最大のカウント値
    public long getMaxCount() {
        return bms_header.max_count;
    }
    // 小節バーの個数(最後の小節も含むため+1する)
    public int getBarNum() {
        return (int)bms_header.end_bar + 1;
    }
    // 小節バーのデータ
    public BmsBar getBar(final int num) {
        return bms_bar[num];
    }
    // 指定チャネルのデータ数を返す
    public int getObjeNum(final int ch) {
        return num_bms_data[ch];
    }
    // チャネルと配列番号でデータを取得する
    public BmsData getObje(final int ch, final int num) {
        return bms_data[ch][num];
    }
    // ヘッダ情報を返す
    public BmsHeader getHeader() {
        return bms_header;
    }
    // 使用しているBMPファイル名
    public String getBmpFile(final int num) {
        return bmp_file[num];
    }
    // 使用しているWAVファイル名
    public String getWavFile(final int num) {
        return wav_file[num];
    }

    ////////////////////////////////////////////////////////////////////////////////////////
    // コマンド番号を返す
    // 戻り値
    //        0以上 : コマンド番号
    //        -1    : オブジェ配置データ
    //        -2    : 不明なコマンド
    ////////////////////////////////////////////////////////////////////////////////////////
    public int getCommand(final String str) {
        //static finalも必要？
        final String command[] = {
            "PLAYER",
            "GENRE",
            "TITLE",
            "ARTIST",
            "BPM",
            "MIDIFILE",
            "PLAYLEVEL",
            "RANK",
            "VOLWAV",
            "TOTAL",
            "StageFile",
            "WAV",
            "BMP",
        };
        // コマンドの検索ルーチン
        for(int i = 0; i < command.length ;i++) {
            int num = Math.min(str.length(), command[i].length() + 1);
            //str = 「#ヘッダー」の1である「ヘ」とcommand = 「ヘッダー」の長さ = 4 + 「＃」を省略した分の1の範囲が同じであるかどうか
            if(str.substring(1, num).equals(command[i].substring(0, num - 1))) {
                return i;   // コマンドならその番号を返す
            }
        }
        // 先頭が'#nnncc'形式か
        // オブジェ配置なら -1s
        for(int i = 0; i < 5; i++) {
            if(str.charAt(i + 1) >= '0' && str.charAt(i + 1) <= '9') {
                return -1;
            }
        }
        // 処理不可能文字列なら
        return -2;
    }
    ////////////////////////////////////////////////////////////////////////////////////////
    // パラメータ文字列を取得
    ////////////////////////////////////////////////////////////////////////////////////////
    public String getCommandString(final String str) {
        int i = 0;
        while(true) {
            if(i == str.length() - 1) {
                return "";
            }
            else if(str.charAt(i) == ' ' || str.charAt(i) == 0x09 || str.charAt(i) == ':') {
                i++;
                break;
            }
            i++;
        }
        return str.substring(i);
    }
    ////////////////////////////////////////////////////////////////////////////////////////
    // ヘッダ情報だけを取り出す
    ////////////////////////////////////////////////////////////////////////////////////////
    public boolean loadHeader(final String file_name) {  // final
        try {
            File file = new File(file_name);
            BufferedReader reader = new BufferedReader(new FileReader(file));
            //BufferedReader reader = createReader(file_name);
            String str;
            while(true) {
                str = null;
                str = reader.readLine();
                if (str == null) {
                    break;
                }
                // 空白を削除して読み込みの整合性を高める
                str = str.trim();
                // 改行のみ（文字数0）もしくは先頭文字が＃出ない行は無視
                if(str.length() == 0 || str.charAt(0) != '#') {
                    continue;
                }
                int cmd = getCommand(str);
                // 不明なコマンド出た場合
                if(cmd == -2) {
                    continue;
                }
                String content = getCommandString(str);  // 項目内容、項目名はcmd(int)が保有している
                // 項目名だけで内容がない場合、または空白やタブスペースだけだったりの場合
                if(content.equals("")) {
                    continue;
                }
                System.out.println(content);
                // パラメータの代入
                switch(cmd) {
                case 0:    // PLAYER
                    bms_header.player = Long.parseLong(content);
                    break;
                case 1:    //GENRE
                    bms_header.genre = content;
                    break;
                case 2:    // TITLE
                    bms_header.title = content;
                    break;
                case 3:    // ARTIST
                    bms_header.artist = content;
                    break;
                case 4:    // BPM
                    if(str.charAt(4) == ' ' || str.charAt(4) == 0x09) {
                        // 基本コマンドなら
                        bms_header.bpm = Float.parseFloat(content);
                        addData(BMS_TEMPO, 0, (long)bms_header.bpm);
                    } else {
                        // 拡張コマンドなら
                        bms_header.bpmindex[Integer.parseInt((str.substring(4, 6)), 36)] = Float.parseFloat(content);
                    }
                    break;
                case 5:    // MIDIFILE
                    bms_header.midifile = content;
                    break;
                case 6:    // PLAYLEVEL
                    bms_header.playerlevel = Long.parseLong(content);
                    break;
                case 7:    // RANK
                    bms_header.rank = Long.parseLong(content);
                    break;
                case 8:    // VOLWAV
                    bms_header.volwav = Long.parseLong(content);
                    break;
                case 9:    // TOTAL
                    bms_header.total = Long.parseLong(content);
                    break;
                case 10:   // StageFile
                    bms_header.stagefile = content;
                    break;
                case 11:   // WAV（36進数）
                    wav_file[Integer.parseInt((str.substring(4, 6)), 36)] = content;
                    break;
                case 12:   // BMP（36進数）
                    bmp_file[Integer.parseInt((str.substring(4, 6)), 36)] = content;
                    break;
                default:
                    // 小節番号の取得（10進数）
                    int line = Integer.parseInt(str.substring(1, 4));
                    // チャンネル番号の取得（16進数）
                    int ch = Integer.parseInt(Integer.toHexString(Integer.parseInt(str.substring(4, 6))));
                    if(ch == BMS_STRETCH) {
                        // 小節の倍率変更命令の場合
                        bms_bar[line].b_scale = Float.parseFloat(content);
                    }
                    // 小節番号の最大値を記憶する
                    if(bms_header.end_bar < line) {
                        bms_header.end_bar = line;
                    }
                    break;
                }
            }
        } catch(FileNotFoundException e){
            e.printStackTrace();
            System.out.println("読み取りエラー");
        } catch (IOException e) {
            e.printStackTrace();
            System.out.println("読み取りエラー");
        }

        // 最後の小節内にもデータが存在するため、その次の小節を終端小節とする
        bms_header.end_bar += 2;
        // 小節倍率データを元に全ての小節情報を算出
        long cnt = 0;   // 現在の小節の開始カウント値
        for(int i = 0; i <= bms_header.end_bar; i++) {
            // 小節リストを加算
            bms_bar[i].b_time = cnt;                                              // 現在の小節の開始カウントを記録
            bms_bar[i].b_length = (long)(BMS_RESOLUTION * bms_bar[i].b_scale);    // 倍率からこの小節の長さカウント値を算出

            // この小節のカウント数を加算して次の小節の開始カウントとする
            cnt += bms_bar[i].b_length;
        }
        // 最大カウントを保存
        bms_header.max_count = cnt;


        return true;
    }

    // BMSデータの読み込み
    public boolean loadBmsData(final String file_name) {
        try {
            // ファイルをロード
            File file = new File(file_name);
            BufferedReader reader = new BufferedReader(new FileReader(file));
            String str;

            while(true) {
                str = null;
                str = reader.readLine();
                if (str == null) {
                    break;
                }
                // 空白を削除して読み込みの整合性を高める
                str = str.trim();
                if(str.length() == 0 || str.charAt(0) != '#') {
                    continue;
                }
                int cmd = getCommand(str);
                // データではない場合は次の行へ
                if(cmd != -1) {
                    continue;
                }
                String content = getCommandString(str);  // 項目内容、項目名はcmd(int)が保有している
                // 項目名だけで内容がない場合、または空白やタブスペースだけだったりの場合
                if(content.equals("")) {
                    return false;
                }
                // チャンネル番号の取得（16進数）
                int ch = Integer.parseInt(Integer.toHexString(Integer.parseInt(str.substring(4, 6))));
                // 小節の倍率変更命令の場合はキャンセル
                if(ch == 2) {
                    continue;
                }
                // 小節番号の取得（10進数）
                int line = Integer.parseInt(str.substring(1, 4));
                // データが偶数かチェック
                if(content.length() % 2 == 1) {
                    return false;
                }
                // データ数
                int len = content.length() / 2;
                // 現在の小節のカウント値から1音符分のカウント値を算出
                long tick = bms_bar[line].b_length / len;
                // 実データを追加
                for(int i = 0; i < len; i++) {
                    int data = Integer.parseInt(content.substring(i * 2, i * 2 + 2), 36);         // 36進数
                    if(data > 0) {
                        // データが存在する場合
                        addData(ch, bms_bar[line].b_time + (tick * i), data);
                    }
                }
            }
        } catch(FileNotFoundException e){
            e.printStackTrace();
            System.out.println("読み取りエラー");
        } catch (IOException e) {
            e.printStackTrace();
            System.out.println("読み取りエラー");
        }

        // ソート
        for(int i = 0; i < 256; i++) {
            dataSort(i);
        }
        return true;
    }

    public boolean addData(final int ch, final long cnt, final long data) {
        // チャンネル番号をチェック
        if(ch < 0 || ch > 255) {
            return false;
        }
        // 小節長変更コマンドなら何もしない
        if(ch == BMS_STRETCH) {
            return false;
        }
        // データが無ければ何もしない
        if(data == 0) {
            return true;
        }
        switch(ch) {
        case 0x08:
            //////
            //謎//
            //////
            // BPMのインデックス指定(新)
            num_bms_data[BMS_TEMPO]++;
            bms_data[BMS_TEMPO][num_bms_data[BMS_TEMPO] - 1].judge_flag = true;
            bms_data[BMS_TEMPO][num_bms_data[BMS_TEMPO] - 1].data_time = cnt;
            bms_data[BMS_TEMPO][num_bms_data[BMS_TEMPO] - 1].sound_data = (long)bms_header.bpmindex[(int)data];     // テンポ値をLONG型にも保存(デバッグ用)
            bms_data[BMS_TEMPO][num_bms_data[BMS_TEMPO] - 1].tempo_data = bms_header.bpmindex[(int)data];           // テンポリストに入っているテンポ値を登録
            break;
        default:
            // データを追加
            num_bms_data[ch]++;
            bms_data[ch][num_bms_data[ch] - 1].judge_flag = true;
            bms_data[ch][num_bms_data[ch] - 1].data_time = cnt;
            bms_data[ch][num_bms_data[ch] - 1].sound_data = data;                              // 鳴らすデータを保存
            bms_data[ch][num_bms_data[ch] - 1].tempo_data = (float)data;                       // float型にも保存(デバッグ用)
            break;
        }
        return true;
    }

    ////////////////////////////////////////////////////////////////////////////////////////
    // 指定チャンネルのデータを昇順に並び替える
    ////////////////////////////////////////////////////////////////////////////////////////
    public boolean dataSort(final int ch) {
        if(ch < 0 || ch > 255) {
            return false;
        }

        // 昇順に並び替える
        for(int i = 0; i < num_bms_data[ch] - 1; i++) {
            for(int j = i + 1; j < num_bms_data[ch]; j++) {
                if(bms_data[ch][i].data_time > bms_data[ch][j].data_time ) {
                    // 構造体を入れ替える
                    BmsData dmy     = bms_data[ch][i];      // ダミーに保存
                    bms_data[ch][i] = bms_data[ch][j];      // iにjを入れる
                    bms_data[ch][j] = dmy;                  // jにダミーを入れる
                }
            }
        }
        return true;
    }

    ////////////////////////////////////////////
    // データロード
    ////////////////////////////////////////////
    public boolean load(final String file_name) {
        // ヘッダ＆小節倍率の読み込み
        if(!loadHeader(file_name)) {
            System.out.println("ヘッダ読み取りエラー");
            return false;
        }
        System.out.println("HEADER OK");
        // 実データの読み込み
        if(!loadBmsData(file_name)) {
            System.out.println("データ読み込みエラー");
            return false;
        }
        System.out.println("DATA OK");

        return true;
    }

    ////////////////////////////////////////////////////////////////////////////////////////
    // 時間からBMSカウント値を計算
    ////////////////////////////////////////////////////////////////////////////////////////
    public long getCountFromTime(final double sec) {
        long cnt = 0;           // BMSカウント
        double t = 0;           // BMS上の時間
        double bpm = 130;

        if(num_bms_data[BMS_TEMPO] > 0) {
            bpm = bms_data[BMS_TEMPO][0].tempo_data;     // 初期BPM
        }
        if(sec < 0) {
            return 0;
        }
        // 指定時間を越えるまでタイムを加算
        for(int i = 0; i < num_bms_data[BMS_TEMPO]; i++) {

            // １つ前の時間と新しい時間との経過時間から秒を算出
            double add = (double)(bms_data[BMS_TEMPO][i].data_time - cnt) / (bpm / 60) / (BMS_RESOLUTION / 4);

            // 現在のテンポ値で時間が過ぎたら抜ける
            if(t + add > sec) {
                break;
            }

            t += add;                                       // 経過時間を加算
            bpm = (double)bms_data[BMS_TEMPO][i].tempo_data;     // 次のBPMをセット
            cnt = bms_data[BMS_TEMPO][i].data_time;             // 計算済みのカウントをセット
        }
        // 指定時間と1つ前までの時間の差分
        double sub = sec - t;
        // 差分からBMSカウント数を算出
        long cnt2 = (long)(sub * (BMS_RESOLUTION / 4) * ( bpm / 60 ));
        // BMSカウント値に加算
        cnt += cnt2;

        return cnt;
    }
}
