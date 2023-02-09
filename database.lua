function QueryDatabase(host,username,password,dbname,query)

  local request_options = {
    method = "POST",
    url = "localhost:90",
    body = "host="..host.."&username="..username.."&password="..password.."&query="..query .. "&dbname=" .. dbname,
    headers = {["Content-Type"] = "application/json"}
  }
  local ping = http.request(request_options)
  local response = ping.readAll()
  ping.close()
  print(response)
end --Returns the rows of your query
  --EXAMPLE:
  --[[
  SELECT * FROM users WHERE username="user"
  
  If you have a database setup like that,
  it would return all the rows in the entry
  that has a matching username, as variables. 
  Basically if a password was in a column named 
  password,it would return 
  {password="whatever it was"}.
  So you can access it by [query].password.
  
  Overcomplicated (in my opinion) ;P
  --]]

  local query = [[
    drop table if exists station;
    create table station(
    ID int primary key auto_increment,
    Name varchar(60) not null
    );
  ]]

  local result = QueryDatabase("localhost", "labor", "asdf1234", "mc", query)