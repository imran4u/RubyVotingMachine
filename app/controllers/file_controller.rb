get '/files/:filename/download' do |filename|
  send_file "./files/#{filename}", :filename => filename, :type => 'Application/octet-stream'
end

get '/files/:filename' do |filename|
  send_file "./files/#{filename}"
end
