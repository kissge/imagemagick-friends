# ImageMagick 覚書

## 画像を横に並べて一つの画像にする

```sh
montage -mode Concatenate *.jpg result.jpg
```

## SVG を透過 PNG に変換する

```sh
magick -background none [-density xxx] input.svg output.png

# どの色の透明にしたいか細かく指定したい場合
magick -background 'rgba(255, 255, 255, 0)' [-density xxx] input.svg output.png
```

## 画像の上下左右にある白色のマージンを自動で削除する

```sh
magick input.png -trim output.png
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

## 画像を円に切り抜く

👉 [scripts/crop-to-circle.sh](scripts/crop-to-circle.sh)

```sh
crop-to-circle.sh input.png [output.png]
```

入力が正方形でない場合、出力は楕円形になる
