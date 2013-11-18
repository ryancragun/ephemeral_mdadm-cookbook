# ephemeral_mdadm cookbook

This cookbook will identify the ephemeral devices available on the instance based on Ohai data. If no ephemeral devices
are found, it will gracefully exit with a log message. If ephemeral devices are found a RAID will be created, formatted, 
and mounted. If multiple ephemeral devices are found

# Requirements

* Chef 10 or higher
* A cloud that supports ephemeral devices. Currently supported clouds: EC2, Openstack, and Google.

# Attributes

The following are the attributes used by the this cookbook.
<table>
  <tr>
    <th>Name</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>node['ephemeral_mdadm']['filesystem']</tt></td>
    <td>The filesystem to be used on the ephemeral RAID device</td>
    <td><tt>'ext4'</tt></td>
  </tr>
  <tr>
    <td><tt>node['ephemeral_mdadm']['mount_point']</tt></td>
    <td>The mount point for the ephemeral RAID device</td>
    <td><tt>'/mnt/ephemeral'</tt></td>
  </tr>
  <tr>
    <td><tt>node['ephemeral_mdadm']['raid_level']</tt></td>
    <td>The RAID level to be used for the created device</td>
    <td><tt>'1'</tt></td>
  </tr>
  <tr>
    <td><tt>node['ephemeral_mdadm']['raid_device']</tt></td>
    <td>The RAID device that will be created</td>
    <td><tt>'/dev/md0'</tt></td>
  </tr>
  <tr>
    <td><tt>node['ephemeral_mdadm']['metadata']</tt></td>
    <td>The RAID superblock metadata</td>
    <td><tt>'0.90'</tt></td>
  </tr>
</table>

# Usage

Place the `ephemeral_mdadm::default` in the runlist and the ephemeral devices will be setup.

# Recipes

## default

This recipe sets up available ephemeral devices to be a RAID device, formats it, and mounts it.

# Author

Author:: Ryan Cragun. (<ryan@rightscale.com>)
