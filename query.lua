local http = require("socket.http")
local ltn12 = require("ltn12")

-- Define the request body
local request_body = "host=<hostname>&username=<username>&password=<password>&query=<query>"

-- Define the request options
local request_options = {
  method = "POST",
  headers = {
    ["Content-Type"] = "application/x-www-form-urlencoded",
    ["Content-Length"] = #request_body
  },
  source = ltn12.source.string(request_body),
  sink = ltn12.sink.table(response)
}

-- Send the request and receive the response
local response_code, response_headers, response = http.request("http://<php_file_url>", request_options)

-- If the request is successful, parse the JSON object
if response_code == 200 then
  local json = require("cjson")
  local response_data = json.decode(table.concat(response))
  -- Do something with the response data
else
  -- If the request fails, handle the error
  error("Request failed with code " .. response_code)
end
