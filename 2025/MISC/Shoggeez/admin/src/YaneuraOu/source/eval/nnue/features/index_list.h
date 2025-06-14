﻿// Definition of index list of input features
// 入力特徴量のインデックスリストの定義

#ifndef NNUE_FEATURES_INDEX_LIST_H_INCLUDED
#define NNUE_FEATURES_INDEX_LIST_H_INCLUDED

#include "../../../config.h"

#if defined(EVAL_NNUE)

#include "../../../position.h"
#include "../nnue_architecture.h"

namespace Eval::NNUE::Features {

	// Class template used for feature index list
	// 特徴量のインデックスリストに使うクラステンプレート
	template <typename T, std::size_t MaxSize>
	class ValueList {
	
	public:
	    std::size_t size() const { return size_; }
	    void resize(std::size_t size) { size_ = size; }
	    void push_back(const T& value) { values_[size_++] = value; }
	    T& operator[](std::size_t index) { return values_[index]; }
	    T* begin() { return values_; }
	    T* end() { return values_ + size_; }
	    const T& operator[](std::size_t index) const { return values_[index]; }
	    const T* begin() const { return values_; }
	    const T* end() const { return values_ + size_; }
	
	    void swap(ValueList& other) {
	        const std::size_t max_size = std::max(size_, other.size_);
	        for (std::size_t i = 0; i < max_size; ++i) {
	            std::swap(values_[i], other.values_[i]);
	        }
	        std::swap(size_, other.size_);
	    }
	
	private:
	    T values_[MaxSize];
	    std::size_t size_ = 0;
	};

	//Type of feature index list
	// 特徴量のインデックスリストの型
	class IndexList
	    : public ValueList<IndexType, RawFeatures::kMaxActiveDimensions> {
	};

}  // namespace Eval::NNUE::Features

#endif  // defined(EVAL_NNUE)

#endif // NNUE_FEATURES_INDEX_LIST_H_INCLUDED
