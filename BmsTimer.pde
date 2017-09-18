class BmsTimer {
    int fps = 60;
    int iCount = 0;         // 割り込みカウント数
    long mStart = System.nanoTime();           // 開始時間

    int runTimer() {
        int count = (int)( ( System.nanoTime() - mStart ) / 1000000000.0 * fps );
        if( count != iCount ) {
            int ret = count - iCount;
            iCount = count;
            return ret;
        }
        return 0;
    }
}
