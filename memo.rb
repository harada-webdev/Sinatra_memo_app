# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'

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
  JSON.parse(File.read(FILE_PATH))
end

def write_memos(data)
  File.write(FILE_PATH, JSON.dump(data))
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
  memos = read_memos

  memos[SecureRandom.uuid] = { 'title' => params[:title], 'text' => params[:text] }
  write_memos(memos)

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
  memos = read_memos

  if memos[id]
    memos.delete(id)
    write_memos(memos)
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
  memos = read_memos
  memo = memos[params[:id]]

  if memo
    memo.update('title' => params[:title], 'text' => params[:text])
    write_memos(memos)
    redirect '/memos'
  else
    erb :not_found
  end
end
