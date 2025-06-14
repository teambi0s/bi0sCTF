﻿#ifndef _EVALUATE_MIR_INV_TOOLS_
#define _EVALUATE_MIR_INV_TOOLS_

// BonaPieceのmirror(左右反転)やinverse(盤上の180度回転)させた駒を得るためのツール類。

#include "../config.h"
#if defined(USE_EVAL_LIST)

#include "../evaluate.h"
#include <functional>

namespace Eval
{
	// -------------------------------------------------
	//                  tables
	// -------------------------------------------------

	// 	--- BonaPieceに対してMirrorとInverseを提供する。

	// これらの配列は、init()かinit_mir_inv_tables();を呼び出すと初期化される。
	// このテーブルのみを評価関数のほうから使いたいときは、評価関数の初期化のときに
	// init_mir_inv_tables()を呼び出すと良い。
	// これらの配列は、以下のKK/KKP/KPPクラスから参照される。

	// あるBonaPieceを相手側から見たときの値を返す
	Eval::BonaPiece inv_piece(Eval::BonaPiece p);

	// 盤面上のあるBonaPieceをミラーした位置にあるものを返す。
	Eval::BonaPiece mir_piece(Eval::BonaPiece p);


	// mir_piece/inv_pieceの初期化のときに呼び出されるcallback
	// fe_endをユーザー側で拡張するときに用いる。
	// この初期化のときに必要なのでinv_piece_とinv_piece_を公開している。
	// mir_piece_init_functionが呼び出されたタイミングで、fe_old_endまでは
	// これらのテーブルの初期化が完了していることが保証されている。
	extern std::function<void()> mir_piece_init_function;
	extern s16 mir_piece_[Eval::fe_end];
	extern s16 inv_piece_[Eval::fe_end];

	// この関数を明示的に呼び出すか、init()を呼び出すかしたときに、上のテーブルが初期化される。
	void init_mir_inv_tables();
}

#endif // defined(USE_EVAL_LIST)
#endif // _EVALUATE_MIR_INV_TOOLS_
