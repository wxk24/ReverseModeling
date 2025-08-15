#pragma once
/**
 * @file	i_UREPONAME.h
 * @brief	REPO_BRIEF
 * @see     [项目工程](https://github.com/wxk24/ReverseModeling)
 * @see     [版本说明](https://xialgorithm.yuque.com/org-wiki-xialgorithm-dlvfmf/version_update/URL)
 * @see     [下载链接](https://xialgorithm.yuque.com/g/tmarbw/3rdparty/folder/URL)
 * @note    调用示例
 * @code{.cpp}
    #include <i_UREPONAME.h>

	xi::IReverseModeling* p = xi::CreateIReverseModelingObj();

	// do something ...

	xi::ReleaseIReverseModelingObj(p);
 * @endcode
 * @author	wxk24
 */

// c++
#include <memory>

// local
#include "xi_export_REVERSEMODELING.h"

class ReverseModeling;

XI_BEGIN_NAMESPACE

class IReverseModeling {
public:
    XI_EXPORT_REVERSEMODELING
	IReverseModeling();
    XI_EXPORT_REVERSEMODELING
	~IReverseModeling();

private:
	std::unique_ptr<ReverseModeling> p_;
};

extern "C" {
	XI_EXPORT_REVERSEMODELING IReverseModeling* CreateIReverseModelingObj();
	XI_EXPORT_REVERSEMODELING void ReleaseIReverseModelingObj(IReverseModeling* obj);
}

XI_END_NAMESPACE
