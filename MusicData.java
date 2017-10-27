import java.util.*;

public class MusicData {
    private String title;
    private String artist;
    private String jacket;
    private float bpm;
    private List<Integer> level = new ArrayList<Integer>();
    private List<Integer> clearType = new ArrayList<Integer>();
    private List<Integer> score = new ArrayList<Integer>();

    // ###ハリボテ
    public MusicData(String title, String artist, String jacket, int levelB, int levelA, int levelM, float bpm, int clearType0, int clearType1, int clearType2, int score0, int score1, int score2) {
        this.title = title;
        this.artist = artist;
        this.jacket = jacket;
        level.add(levelB);
        level.add(levelA);
        level.add(levelM);
        this.bpm = bpm;
        clearType.add(clearType0);
        clearType.add(clearType1);
        clearType.add(clearType2);
        score.add(score0);
        score.add(score1);
        score.add(score2);
    }

    public String getTitle() {
        return title;
    }

    public String getArtist() {
        return artist;
    }

    public float getBpm() {
        return bpm;
    }

    public List<Integer> getLevel() {
        return level;
    }

    public List<Integer> getClearType() {
        return clearType;
    }

    public List<Integer> getScore() {
        return score;
    }
}
