public class EntryState extends State {
    private PlayerData[] player_data;
    private PImage card, icon;

    public void drawState() {
        background(#FDD491);

        imageMode(CENTER);
        image(card, width / 2, 415);
        image(icon, 301, 445);
        textMode(CORNER);

        textAlign(LEFT);
        textSize(30);
        fill(0);
        text("PlayerName : " + player_data[0].getName(), 50, 100);
        text("Point : " + player_data[0].getPoint(), 50, 150);
        text("Rank : " + player_data[0].getRank(), 50, 200);
    }

    public void popManage() {

    }

    public State disposeState() {
        return new SelectState();
    }

    public void run() {
        if(!db.connect()) {
            println("データベース接続エラー");
            exit();
        }
        // ###プレーヤーデータの数を決める処理を書く
        player_data = new PlayerData[1];
        // ###プレーヤーごとにデータを抽出（for文？）
        player_data[0] = new PlayerData();
        db.query("select * from PlayerTable where player_id = 1");
        player_data[0].setPlayerId(db.getInt("player_id"));
        player_data[0].setName(db.getString("name"));
        player_data[0].setIcon(db.getInt("icon"));
        player_data[0].setHighspeed(db.getString("highspeed"));
        player_data[0].setPoint(db.getInt("point"));
        player_data[0].setRank(db.getInt("rank"));
        db.close();

        card = loadImage("image/parts/card1.png");
        icon = loadImage("image/parts/icon1.png");
    }
}