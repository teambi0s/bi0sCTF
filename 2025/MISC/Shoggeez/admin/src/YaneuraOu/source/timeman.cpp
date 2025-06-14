﻿#include "config.h"

#if defined(USE_TIME_MANAGEMENT)

#include "misc.h"
#include "search.h"
#include "thread.h"
#include "usi.h"

namespace {

	// これぐらい自分が指すと終局すると考えて計画を練る。
	// 近年、将棋ソフトは終局までの平均手数が伸びているので160に設定しておく。
	const int MoveHorizon = 160;

	// 思考時間のrtimeが指定されたときに用いる乱数
	PRNG prng;

} // namespace


void Timer::init(const Search::LimitsType& limits, Color us, int ply)
{
	// reinit()が呼び出された時のために呼び出し条件を保存しておく。
	lastcall_Limits = const_cast<Search::LimitsType*>(&limits);
	lastcall_Us     = us;
	lastcall_Ply    = ply;

	init_(limits, us, ply);
}

// 今回の思考時間を計算して、optimum(),maximum()が値をきちんと返せるようにする。
// これは探索の開始時に呼び出されて、今回の指し手のための思考時間を計算する。
// limitsで指定された条件に基いてうまく計算する。
// ply : ここまでの手数。平手の初期局面なら1。(0ではない)
void Timer::init_(const Search::LimitsType& limits, Color us, int ply)
{
#if 0
	// nodes as timeモード
	TimePoint npmsec = Options["nodestime"];

	// npmsecがUSI optionで指定されていれば、時間の代わりに、ここで指定されたnode数をベースに思考を行なう。
	// nodes per millisecondの意味。
	// nodes as timeモードで対局しなければならないなら、時間をノード数に変換して、
	// 持ち時間制御の計算式では、この結果の値を用いる。
	if (npmsec)
	{
		// ゲーム開始時に1回だけ
		if (!availableNodes)
			availableNodes = npmsec * limits.time[us];
		
		// ミリ秒をnode数に変換する
		limits.time[us] = TimePoint(availableNodes);
		for (auto c : COLOR)
		{
			limits.inc[c] *= npmsec;
			limits.byoyomi[c] *= npmsec;
		}
		limits.rtime *= npmsec;
		limits.npmsec = npmsec;

		// NetworkDelay , MinimumThinkingTimeなどもすべてnpmsecを掛け算しないといけないな…。
		// 1000で繰り上げる必要もあるしなー。これtime managementと極めて相性が悪いのでは。
	}
#endif

	// ネットワークのDelayを考慮して少し減らすべき。
	// かつ、minimumとmaximumは端数をなくすべき
	network_delay = (int)Options["NetworkDelay"];

	// 探索終了予定時刻。このタイミングで初期化しておく。
	search_end = 0;

	// 今回の最大残り時間(これを超えてはならない)
	// byoyomiとincの指定は残り時間にこの時点で加算して考える。
	remain_time = limits.time[us] + limits.byoyomi[us] + limits.inc[us] - (TimePoint)Options["NetworkDelay2"];
	// ここを0にすると時間切れのあと自爆するのでとりあえず100にしておく。
	remain_time = std::max(remain_time, (TimePoint)100);

	// 最小思考時間
	minimum_thinking_time = (int)Options["MinimumThinkingTime"];

	// 序盤重視率
	// 　これはこんなパラメーターとして手で調整するべきではなく、探索パラメーターの一種として
	//   別の方法で調整すべき。ただ、対人でソフトに早指ししたいときには意味があるような…。
	int slowMover = (int)Options["SlowMover"];

	if (limits.rtime)
	{
		// これが指定されているときは最小思考時間をランダム化する。
		// 連続自己対戦時に同じ進行になるのを回避するためのもの。
		// 終盤で大きく持ち時間を変えると、勝率が5割に寄ってしまうのでそれには注意。

		auto r = limits.rtime;
#if 1
		// 指し手が進むごとに減衰していく曲線にする。
		if (ply)
			r += (int)prng.rand((int)std::min(r * 0.5f, r * 10.0f / (ply)));
#endif

		remain_time = minimumTime = optimumTime = maximumTime = r;
		return;
	}

	// 時間固定モード
	// "go movetime 100"のようにして思考をさせた場合。
	if (limits.movetime)
	{
		remain_time = minimumTime = optimumTime = maximumTime = limits.movetime;
		return;
	}

	// 切れ負けであるか？
	bool time_forfeit = limits.inc[us] == 0 && limits.byoyomi[us] == 0;

	// 1. 切れ負けルールの時は、MoveHorizonを + 40して考える。
	// 2. ゲーム開始直後～40手目ぐらいまでは定跡で進むし、そこまで進まなかったとしても勝負どころはそこではないので
	// 　ゲーム開始直後～40手目付近のMoveHorizonは少し大きめに考える必要がある。逆に40手目以降、MoveHorizonは40ぐらい減らして考えていいと思う。
	// 3. 切れ負けでないなら、100手時点で残り60手ぐらいのつもりで指していいと思う。(これくらいしないと勝負どころすぎてからの持ち時間が余ってしまう..)
	// (現在の大会のフィッシャールールは15分+inctime5秒とか5分+inctime10秒そんな感じなので、160手目ぐらいで持ち時間使い切って問題ない)
	int move_horizon;
	if (time_forfeit)
		move_horizon = MoveHorizon + 40 - std::min(ply , 40);
	else
		// + 20は調整項
		move_horizon = MoveHorizon + 20 - std::min(ply , 80);


	// 残りの自分の手番の回数
	// ⇨　plyは平手の初期局面が1。256手ルールとして、max_game_ply == 256だから、256手目の局面においてply == 256
	// 　その1手前の局面においてply == 255。ply == 255 or 256のときにMTGが1にならないといけない。だから2足しておくのが正解。
	const int MTG = std::min(limits.max_game_ply - ply + 2, move_horizon ) / 2;

	if (MTG <= 0)
	{
		// 本来、終局までの最大手数が指定されているわけだから、この条件で呼び出されるはずはないのだが…。
		sync_cout << "info string Error! : max_game_ply is too small." << sync_endl;
		return;
	}
	if (MTG == 1)
	{
		// この手番で終了なので使いきれば良い。
		minimumTime = optimumTime = maximumTime = remain_time;
		return;
	}

	// minimumとoptimumな時間を適当に計算する。

	{
		// 最小思考時間(これが1000より短く設定されることはないはず..)
		minimumTime = std::max(minimum_thinking_time - network_delay, (TimePoint)1000);

		// 最適思考時間と、最大思考時間には、まずは上限値を設定しておく。
		optimumTime = maximumTime = remain_time;

		// optimumTime = min ( minimumTime + α     , remain_time)
		// maximumTime = min ( minimumTime + α * 5 , remain_time)
		// みたいな感じで考える

		// 残り手数において残り時間はあとどれくらいあるのか。
		TimePoint remain_estimate = limits.time[us]
			+ limits.inc[us] * MTG
			// 秒読み時間も残り手数に付随しているものとみなす。
			+ limits.byoyomi[us] * MTG;

		// 1秒ずつは絶対消費していくねんで！
		remain_estimate -= (MTG + 1) * 1000;
		remain_estimate = std::max(remain_estimate, TimePoint(0));

		// -- optimumTime
		TimePoint t1 = minimumTime + remain_estimate / MTG;

		// -- maximumTime
		//float max_ratio = 5.0f;
#if !defined(YANEURAOU_ENGINE_DEEP)
		float max_ratio = 3.0f;
		// 5.0f、やりすぎな気がする。時間使いすぎて他のところで足りなくなる。
#else
		// ふかうら王、5.0fでもうまくマネージメントできるんじゃないか？(根拠なし。計測すべき)
		float max_ratio = 5.0f;
#endif


		// 切れ負けルールにおいては、5分を切っていたら、このratioを抑制する。
		if (time_forfeit)
		{
			// 3分     : ratio = 3.0
			// 2分     : ratio = 2.0
			// 1分以下 : ratio = 1.0固定
			max_ratio = std::min(max_ratio, std::max(float(limits.time[us]) / (60 * 1000), 1.0f));
		}
		TimePoint t2 = minimumTime + (int)(remain_estimate * max_ratio / MTG);

		// ただしmaximumは残り時間の30%以上は使わないものとする。
		// optimumが超える分にはいい。それは残り手数が少ないときとかなので構わない。
		t2 = std::min(t2, (TimePoint)(remain_estimate * 0.3));

		// slowMoverは100分率で与えられていて、optimumTimeの係数として作用するものとする。
		optimumTime = std::min(t1, optimumTime) * slowMover / 100;
		maximumTime = std::min(t2, maximumTime);

#if !defined(YANEURAOU_ENGINE_DEEP)
		// Ponderが有効になっている場合、ponderhitすると時間が本来の予測より余っていくので思考時間を心持ち多めにとっておく。
		// これ本当はゲーム開始時にUSIコマンドで送られてくるべきだと思う。→　将棋所では、送られてきてた。"USI_Ponder"  [2019/04/29]
		// ふかうら王の場合、Ponder当たったからと言って探索量減らさないし、Stochastic Ponderがあるから、まあこれはいいや…。
		if (/* Threads.main()->received_go_ponder*/ Options["USI_Ponder"])
			optimumTime += optimumTime / 4;
#endif
	}

	// 秒読みモードでかつ、持ち時間がないなら、最小思考時間も最大思考時間もその時間にしたほうが得
	if (limits.byoyomi[us])
	{
		// 持ち時間が少ないなら(秒読み時間の1.2倍未満なら)、思考時間を使いきったほうが得
		// これには持ち時間がゼロのケースも含まれる。
		if (limits.time[us] < (int)(limits.byoyomi[us] * 1.2))
			minimumTime = optimumTime = maximumTime = limits.byoyomi[us] + limits.time[us];
	}

	// 残り時間 - network_delay2よりは短くしないと切れ負けになる可能性が出てくる。
	minimumTime = std::min(round_up(minimumTime), remain_time);
	optimumTime = std::min(         optimumTime , remain_time);
	maximumTime = std::min(round_up(maximumTime), remain_time);

}

#endif
