#pragma once
/**
 * @file	i_UREPONAME.h
 * @brief	REPO_BRIEF
 * @see     [项目工程](https://github.com/OWNER/RepoName)
 * @see     [版本说明](https://xialgorithm.yuque.com/org-wiki-xialgorithm-dlvfmf/version_update/URL)
 * @see     [下载链接](https://xialgorithm.yuque.com/g/tmarbw/3rdparty/folder/URL)
 * @note    调用示例
 * @code{.cpp}
    #include <i_UREPONAME.h>

	xi::IRepoName* p = xi::CreateIRepoNameObj();

	// do something ...

	xi::ReleaseIRepoNameObj(p);
 * @endcode
 * @author	AUTHOR
 */

// c++
#include <memory>

// local
#include "xi_export_TARGET.h"

class RepoName;

XI_BEGIN_NAMESPACE

class IRepoName {
public:
    XI_EXPORT_TARGET
	IRepoName();
    XI_EXPORT_TARGET
	~IRepoName();

private:
	std::unique_ptr<RepoName> p_;
};

extern "C" {
	XI_EXPORT_TARGET IRepoName* CreateIRepoNameObj();
	XI_EXPORT_TARGET void ReleaseIRepoNameObj(IRepoName* obj);
}

XI_END_NAMESPACE
