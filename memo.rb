# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'pg'
require 'dotenv/load'

def conn
  @conn ||= PG.connect(dbname: ENV['DB_NAME'])
end

FILE_PATH = 'data/memo.json'

helpers do
  def h(input)
    Rack::Utils.escape_html(input)
  end

  def hattr(text)
    Rack::Utils.escape_path(text)
  end
end

def read_memos
  conn.exec('SELECT * FROM memos').each_with_object({}) do |row, hash|
    hash[row['id']] = { 'title' => row['title'], 'text' => row['text'] }
  end
end

def add_memo(id, title, text)
  conn.exec_params('INSERT INTO memos (id, title, text) VALUES ($1, $2, $3)', [id, title, text])
end

def delete_memo(id)
  conn.exec_params('DELETE FROM memos WHERE id = $1', [id])
end

def update_memo(id, title, text)
  conn.exec_params('UPDATE memos SET title = $1, text = $2 WHERE id = $3', [title, text, id])
end

get '/' do
  redirect '/memos'
end

get '/memos' do
  @memos = read_memos

  erb :home
end

get '/memos/new' do
  erb :new
end

# メモの新規作成
post '/memos' do
  id = SecureRandom.uuid
  title = params[:title]
  text = params[:text]

  add_memo(id, title, text)

  redirect '/memos'
end

get '/memos/:id' do
  @id = params[:id]
  @memo = read_memos[@id]

  if @memo
    erb :detail
  else
    erb :not_found
  end
end

delete '/memos/:id' do
  id = params[:id]

  if read_memos[id]
    delete_memo(id)
    redirect '/memos'
  else
    erb :not_found
  end
end

get '/memos/:id/edit' do
  @id = params[:id]
  @memo = read_memos[@id]

  if @memo
    erb :edit
  else
    erb :not_found
  end
end

# メモの更新
patch '/memos/:id' do
  id = params[:id]
  title = params[:title]
  text = params[:text]

  if read_memos[id]
    update_memo(id, title, text)
    redirect '/memos'
  else
    erb :not_found
  end
end
