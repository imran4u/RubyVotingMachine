require 'bundler'
Bundler.require

$: << File.expand_path('../', __FILE__)
Dir['./app/**/*.rb'].sort.each {|file| require file }

#Configure sinatra
set :root, Dir['./app']
set :public_foler, Proc.new { File.join(root, 'assets')}
set :erb, :layout => :'layouts/application'


