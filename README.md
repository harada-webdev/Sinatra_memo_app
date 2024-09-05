# Sinatraメモアプリ
Sinatraで作ったメモアプリです。
Web上にタイトルとメモを書いて、簡単なメモを作成できます。

## 開発環境
### 使用するソフトウェア
- Debian 12
- Windows 11
- PostgreSQL 16

## セットアップ方法
1. `git clone https://github.com/harada-webdev/Sinatra_memo_app.git`で、リポジトリをローカルの任意の場所にコピーします。
2. Sinatra_memo_appディレクトリに移動します。
3. `git checkout feature/json-to-db`で、mainブランチからfeature/json-to-dbブランチに移動します。
4. ローカルにアプリケーションに必要なGemがインストールされていないので、`bundle install`で必要なGemをインストールします。
5. `.env`ファイルを作成し、以下の内容を追加します。DB_NAMEには、使用するデータベースの名前を指定してください。

```
DB_NAME=my_database
```

6. アプリを起動させるために必要なテーブルを、使用するデータベースに作成します。以下のDDL文を追加してください。
```
CREATE TABLE memos (
  id UUID PRIMARY KEY,
  title TEXT NOT NULL,
  text TEXT NOT NULL
);
```

7. `bundle exec ruby memo.rb`で、アプリケーションを起動させます。
8. ブラウザに自動で遷移されない場合、ブラウザのurlバーに`http://localhost:4567/`で検索してください。
9. ブラウザ上で 「メモアプリ」が表記されれば成功です。
