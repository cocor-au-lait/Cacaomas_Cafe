public class DecideState extends State {
    private boolean flag;
    private float fade_ratio;
    private int state_time;
    private PImage bg;
    private AudioSample decide;
    private int t_start;

    public DecideState() {
        t_start = millis();
        flag = false;
        state_time = millis();
        bg = loadImage("image/background/decide.png");
        decide = minim.loadSample("sound/se/decide.mp3");
        decide.trigger();
    }
    
    public void loadingState() {
    }

    public void drawState() {
        imageMode(CORNER);
        image(bg, 0 , 0, width, height);
        fill(0);
        textFont(font);
        textSize(80);
        text("banane au lait", width / 2, height / 2 - 40);
        textSize(40);
        text("chocolat au lait", width / 2, height / 2 + 40);
        if(millis() - t_start > 3000 && !flag) {
            stateMove = new StateMove();
            phase = 2;
            flag = true;
        }
    }

    public void openState() {
        phase = 1;
    }

    public void closeState() {
        stateMove.fadeIn(1000);
    }

    public State nextState() {
        decide.close();
        minim.stop();
        return new PlayState();
    }
}