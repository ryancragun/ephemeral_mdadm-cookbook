name             'ephemeral_mdadm'
maintainer       'Ryan Cragun'
maintainer_email 'ryan@rightscale.com'
license          'Apache 2.0'
description      'Installs/Configures ephemeral_mdadm'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

%w(ubuntu debian fedora centos scientific arch).each { |distro| supports distro }

recipe "ephemeral_mdadm::default", "Sets up a RAID array with ephemeral devices on a cloud server"

attribute "ephemeral_mdadm/filesystem",
  :display_name => "Ephemeral Raid Filesystem",
  :description => "The filesystem to be used on the ephemeral RAID device",
  :default => "ext4",
  :recipes => ["ephemeral_mdadm::default"],
  :required => "recommended"

attribute "ephemeral_mdadm/mount_point",
  :display_name => "Ephemeral RAID Mount Point",
  :description => "The mount point for the ephemeral RAID device",
  :default => "/mnt/ephemeral",
  :recipes => ["ephemeral_mdadm::default"],
  :required => "recommended"

attribute "ephemeral_mdadm/raid_device",
  :display_name => "Ephemeral RAID device name",
  :description => "The device name for the ephemeral RAID device",
  :default => "/dev/md0",
  :recipes => ["ephemeral_mdadm::default"],
  :required => "recommended"

attribute "ephemeral_mdadm/metadata",
  :display_name => "Ephemeral RAID Superblock Metadata",
  :description => "The superblock type for the ephemeral RAID device",
  :default => "0.90",
  :recipes => ["ephemeral_mdadm::default"],
  :required => "recommended"

attribute "ephemeral_mdadm/raid_level",
  :display_name => "Ephemeral RAID Level",
  :description => "The raid level for the ephemeral RAID device",
  :default => "1",
  :recipes => ["ephemeral_mdadm::default"],
  :required => "recommended"
