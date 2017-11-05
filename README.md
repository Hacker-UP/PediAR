# PediAR

Tap the screen, Know the world.

## Instruction

生活中有许多我们不曾发现的事物，我们对这些细小的东西一无所知。PediAR 是基于 iOS 平台的 AR App，它利用 IBM Waston 的认知 API，对所指向的物体进行识别。并通过 QingCloud 云服务器的聚合作用，在 Wikipedia 上搜索出准确的介绍信息，来帮助用户准确的了解那些生活中未知的事物。PediAR 就好比是一个现实识物的 Wikipedia 全书。并且其准确的 Web link 功能还可以扩展到其他的行业，例如电商中某某明星的同款衣物销售等。

## Prerequisities

* Xcode 9.0+
* iOS 11.0+
* Swift 4.0+


## Idea Source

在 20 多年前，无互联网时代，人们获取知识最方便的方式就是通过阅读百科全书。百科全书有很大的弊端就是书本太多，读者都是漫无目的获取知识，无法及时有效的获取自己刚兴趣的方面。而当 WikiPedia 问世之后，我们对于知识的获取效率大大提升，但是仍旧有一个弊端就是当我们获取内容的时候，必须准确的知道相关事物的一些关键字进行检索。而 PediAR iOS App 恰恰是因为这个弊端而诞生。PediAR 利用 AR 和 IBM 提供的识别 API，精准的获取到镜头前物体的相关关键字，并使用 QingCloud 云服务器对 WikiPedia 进行数据聚合，从而快速的提升了知识的获取效率。这是一个可以对现实世界中物体识别，并快速检索的百科全书，是利用 AR 与现实世界交互的百科全书。

## Solve

加速对知识的获取效率；寓教于乐，在显示世界的视觉中，增加识物标签。

## Missiones

打开 App 后，点击按钮进入 AR 界面。然后把你想要识别的物体放在蓝色方框内，轻点屏幕。稍等片刻后，如果解析成功，会在物体位置出现一个气泡，显示该物体的名称。下面会出现维基百科的跳转链接，以及与该物体相近的图片供参考。还有根据维基百科的 Summary 部分生成的可能相关概念跳转链接。如果不想看到当前物体的介绍了，就把手机中心对准这个气泡并点击，就会让这个气泡“爆炸”，以便进行下一次识别。

## Acknowledgement

Thanks to...

## Projects 

* [SnapKit](https://github.com/SnapKit/SnapKit)
* [lottie-ios](https://github.com/airbnb/lottie-ios)
* [Kingfisher](https://github.com/onevcat/Kingfisher)
* [Agrume](https://github.com/JanGorman/Agrume)
* [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON)
* [TagListView](https://github.com/ElaWorkshop/TagListView)
* [Toast-Swift](https://github.com/scalessec/Toast-Swift)

## APIs and SDKs

* [IBM Watson](https://console.bluemix.net/catalog/?category=watson)
* [Wikipedia API](https://www.mediawiki.org/wiki/API:Main_page)
* QingCloud API
* Microsoft Bing Search API


## Organizers

* [Hackx](https://www.hackx.org)

## Last but not the least

[Desgard_Duan](https://github.com/Desgard) and [Kuixi Song](https://github.com/songkuixi)

## GNU General Public License v3.0

 Copyright (C) 2007 Free Software Foundation, Inc. <http://fsf.org/>
 Everyone is permitted to copy and distribute verbatim copies
 of this license document, but changing it is not allowed.
