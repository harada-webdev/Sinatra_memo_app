# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'

FILE_PATH = 'data/memo.json'

helpers do
  def h(input)
    Rack::Utils.escape_html(input)
  end
end

def read_json
  JSON.parse(File.read(FILE_PATH))
end

def write_json(data)
  File.write(FILE_PATH, JSON.dump(data))
end

get '/' do
  redirect '/memos'
end

get '/memos' do
  @json_data = read_json
  erb :home
end

get '/new' do
  erb :new
end

# メモの新規作成
post '/memos' do
  json_data = read_json

  json_data << { SecureRandom.uuid => { 'title' => h(params[:title]), 'text' => h(params[:text]) } }
  write_json(json_data)

  redirect '/memos'
end

get '/memos/:id' do
  @id = params[:id]
  @json_data = read_json
  @subject_to_memo = @json_data.find { |memo| memo.key?(@id) }

  if @subject_to_memo
    erb :detail
  else
    erb :not_found
  end
end

delete '/memos/:id' do
  json_data = read_json

  json_data.delete_if { |memo| memo.key?(params[:id]) }
  write_json(json_data)

  redirect '/memos'
end

get '/memos/:id/edit' do
  @id = params[:id]
  @json_data = read_json
  @subject_to_memo = @json_data.find { |memo| memo.key?(@id) }

  erb :edit
end

# メモの更新
patch '/memos/:id' do
  id = params[:id]
  json_data = read_json
  subject_to_memo = json_data.find { |memo| memo.key?(id) }

  subject_to_memo[id]['title'] = h(params[:title])
  subject_to_memo[id]['text'] = h(params[:text])
  write_json(json_data)

  redirect '/memos'
end
