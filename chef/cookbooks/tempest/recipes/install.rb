#
# Cookbook Name:: tempest
# Recipe:: install
#
# Copyright 2011, Dell, Inc.
# Copyright 2012, Dell, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

package "python-httplib2"
package "python-nose"
package "python-unittest2"

# Download and unpack tempest tarball

tarball_url = node[:tempest][:tempest_tarball]
filename = tarball_url.split('/').last
dst_dir = "/opt"

remote_file tarball_url do
  source tarball_url
  path "#{dst_dir}/#{filename}"
  action :create_if_missing
end

execute "tar" do
  cwd dst_dir
  command "tar -xf #{dst_dir}/#{filename}"
  action :run
end

bash "remove_commit-hash_from_path" do
  cwd dst_dir
  code <<-EOH
mv openstack-tempest-* tempest
EOH
  # TODO: use proposal attribute
  not_if { ::File.exists?("#{dst_dir}/tempest") }
end
