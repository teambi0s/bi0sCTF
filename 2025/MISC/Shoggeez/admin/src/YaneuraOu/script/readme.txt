
ここのフォルダにあるのはpython用のスクリプトです。
python2.7系で動作を確認しています。
そのうちpython3系に移行するかも知れません。

engine_invoker1.py
engine_invoker5.py

	新自己対戦フレームワーク
	将棋エンジンを複数起動して並列的に連続対局できます。

calc_rating.py

	レーティング計算用

analyze_result_log.py

	探索パラメーターをランダムに変更したものを使って
	基準ソフトと対局させたときのログを集計するためのスクリプト。

analyze_learning_log.py
	やねうら王の学習部を用いて学習させたときのログを
	グラフ化するためのスクリプト。たぬきチームより提供を受けました。
	このスクリプトのライセンスはGPLに従います。

msys2_build
	msys2環境で各CPU用の思考エンジンの実行ファイルを一括生成するためのバッチファイル。(サンプル)

build.sh
	GitHub actionsで使っているbuild用の補助スクリプト

eval_bin_to_cpp_literal.py
	評価関数パラメーターを.cppのソースコードに変換する

source/eval/nnue/architectures/nnue_arch_gen.py
	NNUE評価関数のアーキテクチャを定義するC++ headerファイルを動的に生成するPython製のスクリプト。
