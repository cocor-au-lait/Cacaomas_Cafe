public class Transition1 extends Transition {
    private int deg;
    private String dot = "...";

    // 各ステート間のつなぎの描画
    public void drawTransition() {
        if(status <= 0) {
            return;
        }
        elapsed_time = millis() - start_time;
        switch(mode) {
        case "SIMPLE":
        default:
            simpleTransition();
            break;
        }
    }

    public void simpleTransition() {
        float ratio = 0.0f;
        switch(status) {
        case 1:
            ratio = elapsed_time / 1200.0f;
            if(ratio > 1.0f) {
                start_time = millis();
                trans_phase = 2;
            }
            break;
        case 2:
        case 3:
            ratio = 1.0f;
            if(!isInitializing()) {
                start_time = millis();
                status = 4;
            }
            break;
        case 4:
            ratio = 1.0f - (elapsed_time / 1200.0f);
            if(ratio > 1.0f) {
                start_time = millis();
                status = 0;
            }
            break;
        }
        rectMode(CORNER);
        fill(255, 255 * ratio);
        rect(0, 0, width, height);
        pushMatrix();
        translate(width/2, height/2);
        rotate(radians(deg));
        rectMode(CENTER);
        deg ++;
        if(deg > 360) deg = 0;
        noStroke();
        fill(0, 255 * ratio);
        rect(0, 0, 200, 200);
        popMatrix();
        for(int i = 0; i < (int)(deg / 90); i++) {
            if(i==0){dot="";}
            else if(i==1){dot=".";}
            else if(i==2){dot="..";}
            else if(i==3){dot="...";}
        }
        textSize(30);
        text("now loading" + dot, width/2, (height / 5 ) * 4);
    }
}