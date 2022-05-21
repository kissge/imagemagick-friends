# ImageMagick 覚書

## 画像を横に並べて一つの画像にする

```sh
montage -mode Concatenate *.jpg result.jpg
```

## 画像の上下または左右にマージンをつけることで指定の縦横比にする

👉 [scripts/add-margin-to-ratio.sh](scripts/add-margin-to-ratio.sh)

```sh
add-margin-to-ratio.sh input.png output.png 100 33.33
```

## 画像の差分をビフォーアフターのアニメーションで分かりやすく示す

👉 [scripts/diff.sh](scripts/diff.sh)

```sh
diff.sh before.png after.png diff.png
```

関連：Web ページのスクリーンショットを撮る

```sh
firefox --screenshot "$PWD"/output.png https://www.legalscape.jp/
google-chrome --headless --screenshot=output.png https://www.legalscape.jp/
```
