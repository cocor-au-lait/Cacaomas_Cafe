public class Utility {
    public void setText(int size, int col, int align) {
        textFont(font);  //設定したフォントを使用
        textSize(size);
        //textFont(createFont("Arial", 50));
        textAlign(align);
        fill(col);
    }
}
