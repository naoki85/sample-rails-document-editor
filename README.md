# sample-rails-document-editor

## 準備

### AWS での作業

[Amazon WorkDocs](https://aws.amazon.com/jp/workdocs/) を利用しています。  
まずはコンソールから WorkDocs のサイトを作成してください。  
また、 `AmazonWorkDocsFullAccess` ポリシーをアタッチした IAM ユーザーを作成してください。  

### 設定値の作成

IAM ユーザーのアクセストークンを、 `~/.aws/workdocs` というファイル名で保存してください。  
Docker 利用時にそのファイルをマウントします。  
  
また、 `.env` ファイルを作成し、以下の情報を入力してください。

```
AWS_WORKDOCS_ORGANIZATION_ID=<組織ID。AWS のディレクトリサービスにアクセスすると確認可能>
AWS_WORKDOCS_WORKSPACE_NAME=<WorkDocs で作成したサイトの識別子>
AWS_WORKDOCS_USER_EMAIL=<WorkDocs の管理ユーザーのメールアドレス>
AWS_WORKDOCS_SHARED_USER=<WorkDocs の一般ユーザーの名前>
AWS_WORKDOCS_SHARED_USER_EMAIL=<WorkDocs の一般ユーザーのメールアドレス>
AWS_WORKDOCS_SHARED_USER_PASSWORD=<WorkDocs の一般ユーザーのパスワード>
AWS_WORKDOCS_SHARED_USER_ID=<WorkDocs の一般ユーザーの ID>
```

### ビルド

```
$ docker-compose build
$ docker-compose run --rm web /bin/rails db:migrate
```

## 開始

```
$ docker-compose up -d
```
[http://localhost:3000](http://localhost:3000) にアクセスしてください。

## 終了

```
$ docker-compose down
```

## 本番用のビルド

```
$ docker-compose -f docker-compose.production.yml build
```
