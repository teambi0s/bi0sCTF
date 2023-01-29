package x.y.z

class h {
    companion object {
        init {
            System.loadLibrary("o")
        }
    }
    external fun s(packageName: String): String
    external fun ss(packageName: String): String
}