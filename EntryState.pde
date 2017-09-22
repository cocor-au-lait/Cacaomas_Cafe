public class EntryState extends State {
    public EntryState() {
        if(!db.connect()) {
            println("データベース接続エラー");
            exit();
        }
        db.query("select * from PlayerTable where player_id = 1");
        println("\"name\":" + db.getString("name"));
        println("\"icon\":" + db.getInt("icon"));
        println("\"highspeed\":" + db.getString("highspeed"));
        println("\"point\":" + db.getInt("point"));
        println("\"rank\":" + db.getInt("rank"));
    }
    
    public void beforeState() {
    }

    public void drawState() {
        clear();
    }

    public void openState() {
        //stateMove.riseScene();
    }

    public void closeState() {
        //stateMove.fallScene();
    }

    public State disposeState() {
        return new SelectState();
    }
    
    public void run() {
    }
}