# template-CompositeProject

> README.md: 当前项目或目录的说明文档, 必要目录下都应有此文档

用于有其他三方库依赖的复合项目

## Contents

1. [Steps](#steps)
2. [Notes](#notes)
3. [Release](#release)

### Steps

[:top:](#contents)

1. 点击 `Use this template`  => `Create a new repository`

2. 在`Repository name`处填入新建的仓库名称

   > 仓库名称由 英文大小写字母 和 下划线 组成, 不要有特殊字符, 如空格, `-` ;

   填写 `Description` (可选), 点击 `Create repository from template`

   等待新仓库中的工作流执行完成即可.

### Notes

[:top:](#contents)

1. 开发时按要求将各文件放在对应目录, 如源码放在 `src` 文件夹中, 测试源码放在 `tests` 文件夹中, 对外接口文件放在 `include` 文件夹中.

   详情请查看 [三方库格式编绎规范](https://xialgorithm.yuque.com/tmarbw/share/dh9agapom70k3dgl)

2. 文件夹 `scripts/` , `.github/workflows/` 下<u>已有的文件无需修改</u>

   可添加自己需要的文件

3. 提交代码必须按照 [commit 规范](https://xialgorithm.yuque.com/tmarbw/share/uufsmw82ykisqups)

### Release

[:top:](#contents)

点击 `scripts/Git_Tag.bat` , 输入 new tag

格式必须为 `v[0-9]+.[0-9]+.[0-9]+`

如 `v1.0.0`    `v2.3.4`    `v12.345.6789`

> 每次输入的版本必须大于之前的版本
