#
# Cookbook Name:: ephemeral_mdadm
# Recipe:: default
#
# Copyright (C) 2013 Ryan Cragun
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

if !node.attribute?('cloud') || !node['cloud'].attribute?('provider')
  log "Not running on a known cloud, not setting up ephemeral mdadm"
else
  
  cloud = node['cloud']['provider']
  ephemeral_devices = EphemeralMdadm::Helper.get_ephemeral_devices(cloud, node)

  if ephemeral_devices.empty?
    log "No ephemeral disks found. Skipping setup."
  else
    log "Ephemeral disks found for cloud '#{cloud}': #{ephemeral_devices.inspect}"

    mounted_devices = EphemeralMdadm::Helper.get_mounted_ephemeral_devices(ephemeral_devices, node)
    mounted_devices.each do |dev|
      
      mount dev do
        device      dev
        fstype      node['filesystem'][dev]['fs_type']
        mount_point node['filesystem'][dev]['mount']
        action      [:umount, :disable]
      end

      execute "Reformatting Ephemeral Device" do
        command "mkfs.#{node['ephemeral_mdadm']['filesystem']} #{dev}"
        not_if { node['ephemeral_mdadm']['filesystem'] == node['filesystem'][dev]['fs_type'] }
      end
    end    

    mdadm node['ephemeral_mdadm']['raid_device'] do
      devices   ephemeral_devices
      level     node['ephemeral_mdadm']['raid_level'].to_i
      metadata  node['ephemeral_mdadm']['metadata']
      action    [:create, :assemble]
    end

    execute "Formatting Raid Array" do
      command "mkfs.#{node['ephemeral_mdadm']['filesystem']} #{node['ephemeral_mdadm']['raid_device']}"
      not_if { `file -sL #{node['ephemeral_mdadm']['raid_device']}` =~ /#{node['ephemeral_mdadm']['filesystem']}/ }
    end

    directory node['ephemeral_mdadm']['mount_point'] do
      recursive true
    end

    mount node['ephemeral_mdadm']['mount_point'] do
      device  node['ephemeral_mdadm']['raid_device']
      options node['ephemeral_mdadm']['mount_options']
      fstype  node['ephemeral_mdadm']['filesystem']
      action  [:enable, :mount]
    end
  end
end
