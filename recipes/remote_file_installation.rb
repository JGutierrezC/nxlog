#
# Cookbook Name:: nxlog
# Recipe:: remote_file_installation
#
# Copyright (C) 2016 Acxiom Corporation
#
# All rights reserved - Do Not Redistribute
#
################################################################################
# Installation to be made when remote_file is provided
################################################################################

Chef::Log.info('{nxlog->remote_file_installation} - start')

case node['platform_family']
when 'debian'
  if node['platform'] == 'ubuntu'
    include_recipe 'nxlog::ubuntu'
  else
    include_recipe 'nxlog::debian'
  end
when 'rhel'
  include_recipe 'nxlog::redhat'
when 'windows'
  include_recipe 'nxlog::windows'
else
  Chef::Application.fatal!('Attempted to install on an unsupported platform')
end

package_name = node['nxlog']['installer_package']

if node['nxlog']['checksums'][package_name]
  remote_file 'nxlog' do
    path "#{Chef::Config[:file_cache_path]}/#{package_name}"
    source "#{node['nxlog']['package_source']}/#{package_name}"
    mode 0644
    checksum node['nxlog']['checksums'][package_name]
  end
else
  remote_file 'nxlog' do
    path "#{Chef::Config[:file_cache_path]}/#{package_name}"
    source "#{node['nxlog']['package_source']}/#{package_name}"
    mode 0644
  end
end

if platform?('ubuntu', 'debian')
  dpkg_package 'nxlog' do
    source "#{Chef::Config[:file_cache_path]}/#{package_name}"
    options '--force-confold'
  end
else
  package 'nxlog' do
    source "#{Chef::Config[:file_cache_path]}/#{package_name}"
  end
end

Chef::Log.info('{nxlog->remote_file_installation} - end')
