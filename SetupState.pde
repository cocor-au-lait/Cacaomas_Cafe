public class SetupState extends State {
    int text_alpha;

    public SetupState(PApplet p) {
        textFont(createFont("PrestigeEliteStd-Bd",70,true));
        textAlign(CENTER);

        applet = p;
        bms = new BmsController();
        minim = new Minim(applet);
        font = createFont("Georgia", 100);
        bl_key_stat = new ArrayList<Boolean>();
        for(int i = 0; i < 8; i++) {
            bl_key_stat.add(false);
        }
        onKey = new boolean[8];
        press = new boolean[8];

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
        initializing = false;
    }

    public void drawState() {
        text_alpha = (int)constrain(elapsed_time / 5.0 - 50, 0, 255);
        background(0);
        fill(255, text_alpha);
        text("Jun Koyama Presents", width / 2, height / 2);
        if(elapsed_time > 3000 && !initializing && !doTransition()) {
            //一度だけ呼び出されるように設定する必要がある。
            runTransition("SIMPLE");
        }
    }

    public State nextState() {
        return new TitleState();
    }
}

/*
// バックグラウンド処理はこちら側に書く
public class SetupThread extends Thread {
    PApplet applet;
    public SetupThread(PApplet p) {
        applet = p;
    }
    public void run() {
        stateMove = new StateMove();
        bms = new BmsController();
        minim = new Minim(applet);
        font = createFont("Georgia", 100);
        bl_key_stat = new ArrayList<Boolean>();
        for(int i = 0; i < 8; i++) {
            bl_key_stat.add(false);
        }
        onKey = new boolean[8];

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

        is_loading = false;
    }
}
*/
