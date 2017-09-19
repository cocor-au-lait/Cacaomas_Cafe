public class ResultState extends State {
    private ScoreData score_data;
    private BmsHeader bms_header;

    public ResultState(ScoreData score_data, BmsHeader bms_header) {
        this.score_data = score_data;
        this.bms_header = bms_header;
    }
    
    public void loadingState() {
    }

    public void drawState() {
        clear();
        fill(255);
        textAlign(LEFT);
        textSize(40);
        text("TITLE:" + bms_header.getTitle(), 20, 520);
        text("ARTIST:" + bms_header.getArtist(), 20, 560);
        text("SCORE", 20, 50);
        text(nf((int)score_data.getScore(), 8), 20, 90);

        // 情報（暫定）
        textSize(25);
        text("maxcombo:" + score_data.getMaxCombo(), 20, 120);
        text("bpm:" + (int)bms_header.getBpm(), 20, 150);
        //text("highspeed:x" + bms_header.getBpm(), 20, 180);

        // リアルタイムジャッジ（暫定）
        text("combo:" + score_data.getCombo(), 20, 220);
        text("perfect:" + score_data.getPerfect(), 20, 250);
        text("great:" + score_data.getGreat(), 20, 280);
        text("good:" + score_data.getGood(), 20, 310);
        text("bad:" + score_data.getBad(), 20, 340);
        text("poor:" + score_data.getPoor(), 20, 370);
        text("fast:" + score_data.getfast(), 20, 420);
        text("slow:" + score_data.getSlow(), 20, 450);
    }

    public State nextState() {
        return new SelectState();
    }
}