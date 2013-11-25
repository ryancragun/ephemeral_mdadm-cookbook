class MdadmPatch
  def action_create
    unless @current_resource.exists
      command = "yes | mdadm --create #{@new_resource.raid_device} --level #{@new_resource.level}"
      command << " --chunk=#{@new_resource.chunk}" unless @new_resource.level == 1
      command << " --metadata=#{@new_resource.metadata}"
      command << " --bitmap=#{@new_resource.bitmap}" if @new_resource.bitmap
      command << " --raid-devices #{@new_resource.devices.length} #{@new_resource.devices.join(" ")}"
      Chef::Log.debug("#{@new_resource} mdadm command: #{command}")
      shell_out!(command)
      Chef::Log.info("#{@new_resource} created raid device (#{@new_resource.raid_device})")
      @new_resource.updated_by_last_action(true)
    else
      Chef::Log.debug("#{@new_resource} raid device already exists, skipping create (#{@new_resource.raid_device})")
    end
  end
end

if Chef::VERSION.split('.').size == 4
  _, major, minor, _ = Chef::VERSION.split('.')
  if major.to_i == 10 && minor.to_i <= 10
    class Chef; class Provider; class Mdadmn < MdadmPatch; end; end; end
  end
end
