# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'securerandom'

def read_json(file_path = 'data/memo.json')
  JSON.parse(File.read(file_path))
end

def write_json(data, save_location = 'data/memo.json')
  File.write(save_location, JSON.dump(data))
end

get '/' do
  @json_data = read_json
  erb :home
end

get '/new' do
  erb :new
end

# メモの新規作成
post '/memos' do
  @json_data = read_json
  @json_data << { SecureRandom.uuid => { 'title' => params[:title], 'text' => params[:text] } }
  write_json(@json_data)
  redirect '/'
end

get '/:id' do
  @id = params[:id]
  @json_data = read_json

  memo_exists = @json_data.any? { |memo| memo.key?(@id) }

  if memo_exists
    erb :detail
  else
    erb :not_found
  end
end

not_found do
  erb :not_found
end

delete '/:id' do
  @json_data = read_json
  @json_data.delete_if { |memo| memo.key?(params[:id]) }
  write_json(@json_data)
  redirect '/'
end

patch '/:id/edit' do
  @id = params[:id]
  @json_data = read_json
  erb :edit
end

# メモの更新
post '/:id' do
  @json_data = read_json
  edit_memo = @json_data.find { |memo| memo.key?(params[:id]) }
  edit_memo[params[:id]].update({ 'title' => params[:title], 'text' => params[:text] })
  write_json(@json_data)
  redirect '/'
end
