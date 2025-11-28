require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

configure do 
	$db = SQLite3::Database.new 'barbershop.db'
	$db.execute 'CREATE TABLE if not exists Users (
	    id        INTEGER PRIMARY KEY AUTOINCREMENT,
	    name      TEXT,
	    phone     INTEGER,
	    datestamp TEXT,
	    barber    TEXT,
	    color     TEXT
	);'
	
	$db.execute 'CREATE TABLE if not exists Barbers (
		id        INTEGER PRIMARY KEY AUTOINCREMENT,
	    name      TEXT
	    );'
end


get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"			
end

get '/about' do 
		@error = 'something wrong!'
		erb :about
end	

get '/visit' do 
	erb :visit
end	

get '/contacts' do 
	erb :contacts
end

post '/visit' do 
	@username = params[:username]
	@phone = params[:phone]
	@datestamp = params[:datestamp]
	@barber = params[:barber]
	@color = params[:color]
	
	$db.execute 'insert into Users 
	(name, phone, datestamp, barber, color) 
	values (?, ?, ?, ?, ?)', [@username, @phone, @datestamp, @barber, @color]

	
	hh = {:username => 'Введите имя', :phone => 'Введите телефон', :datetime => 'Введите дату и время'}

	@error = hh.select {|k,_| params[k] == ''}.values.join(", ")

	if @error != ''
		erb :visit
	else
		erb 'Вы записаны'
	end	
end

post '/contacts' do 
	@email = params[:email]
	@message = params[:message]
	
	f = File.open './public/contacts.txt', 'a'
	f.write "Email: ##{@email}, Сообщение: #{@message}\n"
	f.close

	erb :contacts
end

get '/showusers' do 
	$db.results_as_hash = true	
	
	@results = $db.execute 'select * from Users order by id desc'
	
	erb :showusers		
end