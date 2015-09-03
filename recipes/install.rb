#
# Cookbook Name:: docker-mongodb
# Recipe:: install
#
# Copyright (C) 2014 Daniel Ku
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#

directory node["mongodb"]["data_path"] do
	recursive true
	action :create
end

docker_container 'mongod' do
  image "#{node["mongodb"]["docker_image"]}"
	tag "#{node["mongodb"]["docker_image_tag"]}"
  container_name node["mongodb"]["docker_container"]
  entrypoint 'mongod'
	if(node["mongodb"]["smallfiles"]) then
		command '--dbpath /data --smallfiles'
	else
		command '--dbpath /data'
	end
  detach true
  port '27017:27017'
  binds ["#{node["mongodb"]["data_path"]}:/data"]
end
