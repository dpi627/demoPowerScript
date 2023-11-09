#定義處理模式
enum Mode {
    create #建立虛擬目錄，如已存在會先移除
    remove #移除已存在之虛擬目錄
    update #未使用
}
