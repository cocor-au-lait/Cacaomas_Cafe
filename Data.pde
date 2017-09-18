public class Data {

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
