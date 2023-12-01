# Sinatraメモアプリ
Sinatraで作ったメモアプリです。
Web上にタイトルとメモを書いて、簡単なメモを作成できます。

## 開発環境
### OS
- Debian 12
- Windows 11

## インストール方法
1. `https://github.com/harada-webdev/Sinatra_memo_app.git`で、リポジトリをローカルの任意の場所にコピーします。
2. sinatra_memo_appディレクトリに移動します。
3. `git checkout dev`で、mainブランチからdevブランチに移動します。
4. ローカルに、アプリケーションに必要なGemがインストールされていないので、`bundle install`で必要なGemをインストールします。
5. `bundle exec ruby memo.rb`で、アプリケーションを起動させます。
6. ブラウザに自動で遷移されない場合、ブラウザのurlバーに`http://localhost:4567/`で検索してください。
7. メモアプリが表記されれば成功です。
