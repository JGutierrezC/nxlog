#
# Cookbook Name:: nxlog
# Recipe:: default
#
# Copyright (C) 2014 Simon Detheridge
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

if node['nxlog']['installation_type'] == 'remote_file'
  # Using remote_file for installation (nxlog official link)
  include_recipe 'nxlog::remote_file_installation'
else
  # Previously adding the repository file
  package node['nxlog']['repo_package_name']
end

service 'nxlog' do
  action [:enable, :start]
end

template "#{node['nxlog']['conf_dir']}/nxlog.conf" do
  source 'nxlog.conf.erb'

  notifies :restart, 'service[nxlog]', :delayed
end

directory "#{node['nxlog']['conf_dir']}/nxlog.conf.d"

# delete logging components that aren't converged as part of this chef run
zap_directory "#{node['nxlog']['conf_dir']}/nxlog.conf.d" do
  pattern '*.conf'
end

include_recipe 'nxlog::resources_from_attributes'
