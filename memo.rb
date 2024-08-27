# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'

FILE_PATH = 'data/memo.json'

helpers do
  def h(input)
    Rack::Utils.escape_html(input)
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

get '/new' do
  erb :new
end

# メモの新規作成
post '/memos' do
  memos = read_memos

  memos << { SecureRandom.uuid => { 'title' => h(params[:title]), 'text' => h(params[:text]) } }
  write_memos(memos)

  redirect '/memos'
end

get '/memos/:id' do
  @id = params[:id]
  @memos = read_memos
  @memo = @memos.find { |memo| memo.key?(@id) }

  if @memo
    erb :detail
  else
    erb :not_found
  end
end

delete '/memos/:id' do
  memos = read_memos

  memos.delete_if { |memo| memo.key?(params[:id]) }
  write_memos(memos)

  redirect '/memos'
end

get '/memos/:id/edit' do
  @id = params[:id]
  @memos = read_memos
  @memo = @memos.find { |memo| memo.key?(@id) }

  erb :edit
end

# メモの更新
patch '/memos/:id' do
  id = params[:id]
  memos = read_memos
  memo = memos.find { |memo| memo.key?(id) }

  memo[id]['title'] = h(params[:title])
  memo[id]['text'] = h(params[:text])
  write_memos(memos)

  redirect '/memos'
end
