public class PlayerData {
    private int player_id;
    private String name;
    private int icon;
    private String highspeed;
    private int rank;
    private int point;

    public int getPlayerId() {
        return player_id;
    }

    public String getName() {
        return name;
    }

    public int getIcon() {
        return icon;
    }

    public String getHighspeed() {
        return highspeed;
    }

    public int getRank() {
        return rank;
    }

    public int getPoint() {
        return point;
    }

    public void setPlayerId(int player_id) {
        this.player_id = player_id;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setIcon(int icon) {
        this.icon = icon;
    }

    public void setHighspeed(String highspeed) {
        this.highspeed = highspeed;
    }

    public void setRank(int rank) {
        this.rank = rank;
    }

    public void setPoint(int point) {
        this.point = point;
    }
}
