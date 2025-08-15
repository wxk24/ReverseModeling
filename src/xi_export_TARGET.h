/**
 * 对外的所有接口:
		1. 都需加上宏 XI_EXPORT_TARGET
		2. 都需包含在命名空间namespace xi 下
			通过宏 XI_BEGIN_NAMESPACE 和 XI_END_NAMESPACE 实现

 * @库作者:
		编绎动态库: 需定义宏 XI_DLL_TARGET
		编绎静态库: 无需任何定义
		编绎exe: 无需任何定义

 * @库使用者:
		使用动态库: 需定义宏 XI_USE_DLL_TARGET
		使用静态库: 无需任何定义
		使用exe: 无需任何定义
 */

#ifndef XI_DECL_EXPORT
#	define XI_DECL_EXPORT __declspec(dllexport)
#endif

#ifndef XI_DECL_IMPORT
#	define XI_DECL_IMPORT __declspec(dllimport)
#endif

#ifdef XI_DLL_TARGET
#	ifndef XI_EXPORT_TARGET
#		define XI_EXPORT_TARGET XI_DECL_EXPORT
#	endif
#else
#	ifdef XI_USE_DLL_TARGET
#		ifndef XI_EXPORT_TARGET
#			define XI_EXPORT_TARGET XI_DECL_IMPORT
#		endif
#	else
#		ifndef XI_EXPORT_TARGET
#			define XI_EXPORT_TARGET
#		endif
#	endif
#endif

#ifndef XI_BEGIN_NAMESPACE
#define XI_BEGIN_NAMESPACE namespace xi {
#endif // !XI_BEGIN_NAMESPACE

#ifndef XI_END_NAMESPACE
#define XI_END_NAMESPACE }
#endif // !XI_END_NAMESPACE
