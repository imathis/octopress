---
layout: post
title: "Signing Srun3000 iOS Client"
date: 2012-05-14 21:28
comments: true
categories:
- iOS
- Codesign

---

学校的 Srun3000 客户端又是那种不越狱就不能装的……有 Apple 给发的证书，就自己签下名呗，谁知道一直不成功……

尝试了很多，比如说给可执行文件加上可执行权限，改这改那之类的，终于找到问题所在了：

把下载来的 .ipa 解压缩（zip 格式的哦），删掉 Payload/srun3\_client\_iphone.app 文件夹下面的 CodeResources 文件，重新压缩成 zip，改名成 .ipa 然后正常签名（比如 [iModSign](http://iMZDL.com/) 之类）就可以了。

原因大概是因为，srun3000 自带的 CodeResources 是错误的，然后 iOS 会按固定顺序寻找签名信息（CodeResources），于是就在找到 iModSign 的签名（\_CodeSignature/CodeResources）之前找到了错误的 CodeResources。所以估计 App Store 里的软件都不会有这个问题，只有这种必须越狱才能装的破 app 才可能有吧。
