require 'sinatra'
require 'csv'
require 'pry'
require 'pg'

def db_connection
  begin
    connection = PG.connect(dbname: "news_aggregator_development")
    yield(connection)
  ensure
    connection.close
  end
end

get "/news" do


  all_the_news = db_connection do |conn|
    conn.exec("SELECT * FROM articles")
  end
#binding.pry
  erb :index, locals: {all_the_news: all_the_news}

end

post "/item" do
  title = params["news_item"]
  url = params["url"]
  description = params["description"]
  db_connection do |conn|
    conn.exec_params("INSERT INTO articles (title, url, description) VALUES ($1, $2, $3)", [title, url, description])
  end

  redirect "/news"

end

get "/articles/new" do
  erb :new
end
