# hubot-scfes

[![NPM](https://nodei.co/npm/hubot-scfes.png)](https://nodei.co/npm/hubot-scfes/)  
[![Travis CI](https://travis-ci.org/ota42y/hubot-scfes.svg?branch=master)](https://travis-ci.org/ota42y/hubot-scfes)
==========

Hubotにラブライブ！スクールアイドルフェスティバル用のいくつかの機能を提供します。

# Usage

```
#スタミナの現在値が10、最大値が50として、Maxになる時刻に通知
hubot scfes remind stamina 10 50

# スタミナの現在値が10、最大値が50として、25の倍数の時に通知
hubot scfes remind stamina 10 50 25


# 全ての通知を停止する
hubot scfes remind stop


# 次のレベルアップまで何回曲をプレイすればいいか
hubot scfes levelup count 830 ex
=> 10

# 次のレベルアップはいつか
hubot scfes levelup time 830 ex
=> 10時間後のDateオブジェクト
```

# future task
- イベント終了までのスタミナ値の取得
- イベント終了までに特定のLP曲が何回できるか
