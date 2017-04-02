#API to get Ideas 
=begin
	%w(/ /api.ideas).each do |path|
		get path do
		content_type :json
		ideas = Idea.all
		ideas.to_json
		end
	end
=end
get '/api.ideas' do
	content_type :json
	ideas = Idea.all
	ideas.to_json
end

#API to get idea by Id

get '/api.ideas/:id' do 
   idea = Idea.find( params[:id] )
   idea.to_json
end

#API Post Idea
post '/api.ideas' do
    idea = Idea.new(params[:idea])
    if idea.save
      status 201
      "Save success fully"
    else
      status 500
     "Error to save"
    end
end
#API to update ideas buy Id
put '/api.ideas/:id' do
 idea = Idea.find(params[:id])

  	if idea.update_attributes(params[:idea])
  	status 202
  	idea.to_json
	else
	status 400
	"fail to update"
	end
end

#API to delete item by Id
delete '/api.ideas/:id' do
idea = Idea.find ( params[:id])
if idea.destroy
status 200
"Success fully deleted #{idea.inspect}"
else
"fail to delete"
end


end


%w(/ /ideas).each do |path|
get path do
@ideas = Idea.all
erb :'ideas/index'
end
end

%w(new/ /ideas/new).each do |path|
get path do
@title = 'New ideas'
@idea = Idea.new
 erb :'ideas/new'
end
end
 
post '/ideas' do
  if params[:idea]
    @idea           = Idea.new(params[:idea])
    if params[:idea][:picture] && params[:idea][:picture][:filename] && params[:idea][:picture][:tempfile]
      filename      = params[:idea][:picture][:filename]
      @idea.picture = filename
      file          = params[:idea][:picture][:tempfile]
      FileUtils.copy_file(file.path,"files/#{@idea.picture}")
    end
    if @idea.save
      redirect '/ideas'
    else
      erb :'ideas/new'
    end
  else
    erb :'ideas/new'
  end
end

get '/ideas/:id' do
  @idea = Idea.find(params[:id])
  erb :'ideas/show'
end

helpers do
  def delete_idea_button(idea_id)
    erb :'ideas/_delete_idea_button', locals: { idea_id: idea_id }
  end
end

delete '/ideas/:id' do
  Idea.find(params[:id]).destroy
  redirect '/ideas'
end

get '/ideas/:id/edit' do
  @idea = Idea.find(params[:id])
  erb :'ideas/edit'
end

put '/ideas/:id' do
  if params[:idea].try(:[], :picture)
    file      = params[:idea][:picture][:tempfile]
    @filename = params[:idea][:picture][:filename]
  end

  @idea = Idea.find(params[:id])

  if @idea.update_attributes(params[:idea])
    if @filename
      @idea.picture = @filename
      @idea.save
      File.open("./files/#{@filename}", 'wb') do |f|
        f.write(file.read)
      end
    end
    redirect "/ideas/#{@idea.id}"
  else
    erb :'ideas/edit'
  end
end
