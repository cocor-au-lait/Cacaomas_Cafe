public class SetupState extends State {
    int text_alpha;

    public SetupState() {
        textFont(createFont("PrestigeEliteStd-Bd",70,true));
        textAlign(CENTER);
    }

    public void drawState() {
        listener = new InputListner();
        text_alpha = (int)constrain(elapsed_time / 5.0 - 100, 0, 255);
        background(0);
        fill(255, text_alpha);
        textSize(70);
        text("Project\nCacaomas_Cafe", width / 2, (height / 5) * 2);
        textSize(40);
        text("UNDER DEVELOPMENT", width / 2, (height / 5) * 3.4);
        textSize(20);
        text("©️2017 Jun Koyama", width / 2, (height / 5) * 4);
        if(elapsed_time > 2000 && !initializing && !doTransition()) {
            //一度だけ呼び出されるように設定する必要がある。
            runTransition("SIMPLE");
        }
    }

    public State nextState() {
        return new TitleState();
    }

    // バックグラウンド処理はこちら側に書く
    public void run() {
        listener = new InputListner();
        bms = new BmsController();
        minim = new Minim(applet);
        font = createFont("Georgia", 100);
        //ゲームパッドの設定/////////////////////////////////////////////////////////////////////
        button = new ControlButton[8];
        control = ControlIO.getInstance(applet);
        device = control.getMatchedDeviceSilent("beatmania_gamepad");
        if(device != null) {
            button[0] = device.getButton("bt1");
            button[1] = device.getButton("bt2");
            button[2] = device.getButton("bt3");
            button[3] = device.getButton("bt4");
            button[4] = device.getButton("bt5");
            button[5] = null;                       //本来はscratchが来る場所
            button[6] = device.getButton("sta");
            button[7] = device.getButton("sel");
            scratch = device.getSlider("scr");
        }
        ////////////////////////////////////////////////////////////////////////////////////
        // データベースの設定
        db = new SQLite(applet, "database.db");
        state.initializing = false;
    }
}
