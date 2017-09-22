public class Inputer {
    // ゲームパッド用パーツ用意
    ControlIO control;
    private ControlDevice device;
    private ControlButton[] button;
    private ControlSlider scratch;
    // キー制御
    private boolean[] onKey;
    private boolean[] press;
    private int scratch_status;
    private ArrayList<Boolean> key_status;     //キーを覚える配列（同時押し用）

    public void keyPressed() {
        if(!controllable) {
            return;
        }
        switch(keyCode) {
        case ESC:
            exit();
        case SHIFT:
            key_status.set(5, true);        //SCRATCH
            break;
        case ENTER:
            case RETURN:
            key_status.set(6, true);        //START
            break;
        case TAB:
            key_status.set(7, true);       //SELECT
            break;
        }

        switch(key) {
        case 'c':
        case 'C':
            key_status.set(0, true);
            break;
        case 'v':
        case 'V':
            key_status.set(1, true);
            break;
        case 'b':
        case 'B':
            key_status.set(2, true);
            break;
        case 'n':
        case 'N':
            key_status.set(3, true);
            break;
        case 'm':
        case 'M':
            key_status.set(4, true);
            break;
        }
    }

    public void keyReleased() {
        if(!controllable) {
            return;
        }
        switch(keyCode) {
        case SHIFT:
            key_status.set(5, false);
            break;
        case ENTER:
        case RETURN:
            key_status.set(6, false);          //START
            break;
        case TAB:
            key_status.set(7, false);          //SELECT
            break;
        }

        switch(key) {
        case 'c':
        case 'C':
            key_status.set(0, false);
            break;
        case 'v':
        case 'V':
            key_status.set(1, false);
            break;
        case 'b':
        case 'B':
            key_status.set(2, false);
            break;
        case 'n':
        case 'N':
            key_status.set(3, false);
            break;
        case 'm':
        case 'M':
            key_status.set(4, false);
            break;
        }
    }

    public void keyControll() {
        if(!controllable) {
            return;
        }
        //キーの処理
        press = new boolean[8];

        // 白黒ボタン & その他キー
        for(int i = 0; i < 8; i++) {
            if(key_status.get(i) || (button[i] != null && button[i].pressed())) {
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
        if(key_status.get(5) || (scratch != null && scratch.getValue() == 1.0)) {
            // 右回転
            if(scratch_status != 1) {
                // 以前が停止か左回りなら回した瞬間とする
                press[5] = true;
                scratch_status = 1;
            }
        }
        else if(key_status.get(5) || (scratch != null && scratch.getValue() == -1.0)) {
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
}

public class ScoreData {
    private boolean clear;
    private boolean fullcombo;
    private double score;
    private int max_combo;
    private int combo;
    private float gauge;
    private int perfect;
    private int great;
    private int good;
    private int bad;
    private int poor;
    private int fast;
    private int slow;

    public boolean isClear() {
        return clear;
    }

    public void setClear(boolean clear) {
        this.clear = clear;
    }

    public boolean isFullcombo() {
        return fullcombo;
    }

    public void setFullcombo(boolean fullcombo) {
        this.fullcombo = fullcombo;
    }

    public double getScore() {
        return score;
    }

    public void addScore(double score) {
        this.score += score;
    }

    public int getMaxCombo() {
        return max_combo;
    }

    public void addMaxCombo() {
        max_combo++;
    }

    public int getCombo() {
        return combo;
    }

    public float getGauge() {
        return gauge;
    }

    public void addGauge(float diff) {
        gauge += diff;
        gauge = constrain(gauge, 0.0f, 100.0f);
        clear = gauge > 70.0f? true : false;
    }

    public int getPerfect() {
        return perfect;
    }

    public void addPerfect(int near) {
        perfect++;
        combo++;
        nearPlus(near);
    }

    public int getGreat() {
        return great;
    }

    public void addGreat(int near) {
        great++;
        combo++;
        nearPlus(near);
    }

    public int getGood() {
        return good;
    }

    public void addGood(int near) {
        good++;
        combo++;
        nearPlus(near);
    }

    public int getBad() {
        return bad;
    }

    public void addBad(int near) {
        bad++;
        combo = 0;
        nearPlus(near);
    }

    public int getPoor() {
        return poor;
    }

    public void addPoor() {
        poor++;
        combo = 0;
    }

    public int getfast() {
        return fast;
    }

    public int getSlow() {
        return slow;
    }

    public void nearPlus(int near) {
        switch(near) {
        case 1:
            fast++;
            break;
        case -1:
            slow++;
            break;
        }
    }
}

public class PlayerData {

}

public class SongData {

}
