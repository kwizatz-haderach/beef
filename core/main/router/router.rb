#
# Copyright (c) 2006-2025 Wade Alcorn - wade@bindshell.net
# Browser Exploitation Framework (BeEF) - https://beefproject.com
# See the file 'doc/COPYING' for copying permission
#

module BeEF
  module Core
    module Router
      # @note This is the main Router parent class.
      # @note All the HTTP handlers registered on BeEF will extend this class.
      class Router < Sinatra::Base
        config = BeEF::Core::Configuration.instance

        configure do
          set :show_exceptions, false
        end

        # @note Override default 404 HTTP response
        not_found do
          error_page_404
        end

        before do
          # @note Override Server HTTP response header
          headers response_headers

          # @note If CORS is enabled, expose the appropriate headers
          if config.get('beef.http.restful_api.allow_cors')
            allowed_origins = config.get('beef.http.restful_api.cors_allowed_origins')
            if allowed_origins
              headers 'Access-Control-Allow-Origin' => allowed_origins
            end
            headers 'Access-Control-Allow-Methods' => 'POST, GET'

            # Responses to preflight OPTIONS requests need to respond with HTTP 200
            # and be able to handle requests with a JSON content-type
            if request.request_method == 'OPTIONS'
              headers 'Access-Control-Allow-Headers' => 'Content-Type'
              halt 200
            end
          end
        end

        # @note Default root page
        get '/' do
          index_page
        end

        private

        def response_headers
          config = BeEF::Core::Configuration.instance

          default_headers = {
            'Server' => '',
            'Content-Type' => 'text/html'
          }

          return default_headers unless config.get('beef.http.web_server_imitation.enable')

          case config.get('beef.http.web_server_imitation.type')
          when 'apache'
            {
              'Server' => 'Apache/2.2.3 (CentOS)',
              'Content-Type' => 'text/html; charset=UTF-8'
            }
          when 'iis'
            {
              'Server' => 'Microsoft-IIS/6.0',
              'X-Powered-By' => 'ASP.NET',
              'Content-Type' => 'text/html; charset=UTF-8'
            }
          when 'nginx'
            {
              'Server' => 'nginx',
              'Content-Type' => 'text/html'
            }
          else
            print_error 'Configuration error in beef.http.web_server_imitation.type!'
            print_more 'Supported values are: apache, iis, nginx.'
            default_headers
          end
        end

        def index_page
          config = BeEF::Core::Configuration.instance

          return '' unless config.get('beef.http.web_server_imitation.enable')

          bp = config.get 'beef.extension.admin_ui.base_path'
          case config.get('beef.http.web_server_imitation.type')
          when 'apache'
            '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">' \
            '<head>' \
            '<title>Apache HTTP Server Test Page powered by CentOS</title>' \
            '<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />' \
            '<style type="text/css">' \
            'body {' \
            'background-color: #fff; ' \
            'color: #000;' \
            'font-size: 0.9em;' \
            'font-family: sans-serif,helvetica;' \
            'margin: 0;' \
            'padding: 0; ' \
            '}          ' \
            ':link {        ' \
            'color: #0000FF;    ' \
            '}                     ' \
            ':visited {               ' \
            'color: #0000FF;             ' \
            '}                              ' \
            'a:hover {                         ' \
            'color: #3399FF;                      ' \
            '}                                       ' \
            'h1 {                                       ' \
            "\ttext-align: center;                          " \
            "\tmargin: 0;                                      " \
            "\tpadding: 0.6em 2em 0.4em;                          " \
            "\tbackground-color: #3399FF;" \
            "\tcolor: #ffffff;       " \
            "\tfont-weight: normal; " \
            "\tfont-size: 1.75em; " \
            "\tborder-bottom: 2px solid #000; " \
            '}        ' \
            'h1 strong {' \
            'font-weight: bold;  ' \
            '}          ' \
            'h2 {          ' \
            "\tfont-size: 1.1em;" \
            'font-weight: bold;    ' \
            '}                                      ' \
            '.content {                       ' \
            "\tpadding: 1em 5em;                             " \
            '}                                        ' \
            '.content-columns {                                     ' \
            "\t/* Setting relative positioning allows for    " \
            "\tabsolute positioning for sub-classes */                       " \
            "\tposition: relative;                                               " \
            "\tpadding-top: 1em;                                                     " \
            '}                         ' \
            '.content-column-left { ' \
            "\t/* Value for IE/Win; will be overwritten for other browsers */" \
            "\twidth: 47%; " \
            "\tpadding-right: 3%; " \
            "\tfloat: left;          " \
            "\tpadding-bottom: 2em;     " \
            '}                            ' \
            '.content-column-right {         ' \
            "\t/* Values for IE/Win; will be overwritten for other browsers */" \
            "\twidth: 47%;     " \
            "\tpadding-left: 3%;  " \
            "\tfloat: left;        " \
            "\tpadding-bottom: 2em;   " \
            '}                           ' \
            '.content-columns>.content-column-left, .content-columns>.content-column-right {' \
            "\t/* Non-IE/Win */" \
            '}                  ' \
            'img {                 ' \
            "\tborder: 2px solid #fff; " \
            "\tpadding: 2px;              " \
            "\tmargin: 2px;               " \
            '}                           ' \
            'a:hover img {               ' \
            "\tborder: 2px solid #3399FF;    " \
            '}                                 ' \
            '</style>                             ' \
            '</head>                                 ' \
            '<body>                                     ' \
            '<h1>Apache 2 Test Page<br><font size="-1"><strong>powered by</font> CentOS</strong></h1>' \
            '<div class="content"><div class="content-middle">' \
            '<p>This page is used to test the proper operation of the Apache HTTP server after it has been installed. If you can read this page it means that the Apache HTTP server installed at this site is working properly.</p>' \
            '</div>' \
            '<hr />' \
            '<div class="content-columns">' \
            '<div class="content-column-left"> ' \
            '<h2>If you are a member of the general public:</h2>' \
            '<p>The fact that you are seeing this page indicates that the website you just visited is either experiencing problems or is undergoing routine maintenance.</p>' \
            "<p>If you would like to let the administrators of this website know that you've seen this page instead of the page you expected, you should send them e-mail. In general, mail sent to the name \"webmaster\" and directed to the website's domain should reach the appropriate person.</p> " \
            '<p>For example, if you experienced problems while visiting www.example.com, you should send e-mail to "webmaster@example.com".</p>' \
            '</div>' \
            '<div class="content-column-right">' \
            '<h2>If you are the website administrator:</h2>' \
            '<p>You may now add content to the directory <tt>/var/www/html/</tt>. Note that until you do so, people visiting your website will see this page and not your content. To prevent this page from ever being used, follow the instructions in the file <tt>/etc/httpd/conf.d/welcome.conf</tt>.</p>' \
            '<p>You are free to use the images below on Apache and CentOS Linux powered HTTP servers.  Thanks for using Apache and CentOS!</p>' \
            "<p><a href=\"http://httpd.apache.org/\"><img src=\"#{bp}/media/images/icons/apache_pb.gif\" alt=\"[ Powered by Apache ]\"/></a> <a href=\"http://www.centos.org/\"><img src=\"#{bp}/media/images/icons/powered_by_rh.png\" alt=\"[ Powered by CentOS Linux ]\" width=\"88\" height=\"31\" /></a></p>" \
            '</div>' \
            '</div>' \
            '</div>' \
            ' <div class="content">' \
            '<div class="content-middle"><h2>About CentOS:</h2><b>The Community ENTerprise Operating System</b> (CentOS) is an Enterprise-class Linux Distribution derived from sources freely provided to the public by a prominent North American Enterprise Linux vendor.  CentOS conforms fully with the upstream vendors redistribution policy and aims to be 100% binary compatible. (CentOS mainly changes packages to remove upstream vendor branding and artwork.)  The CentOS Project is the organization that builds CentOS.</p>' \
            '<p>For information on CentOS please visit the <a href="http://www.centos.org/">CentOS website</a>.</p>' \
            '<p><h2>Note:</h2><p>CentOS is an Operating System and it is used to power this website; however, the webserver is owned by the domain owner and not the CentOS Project.  <b>If you have issues with the content of this site, contact the owner of the domain, not the CentOS project.</b>' \
            "<p>Unless this server is on the CentOS.org domain, the CentOS Project doesn't have anything to do with the content on this webserver or any e-mails that directed you to this site.</p> " \
            '<p>For example, if this website is www.example.com, you would find the owner of the example.com domain at the following WHOIS server:</p>' \
            '<p><a href="http://www.internic.net/whois.html">http://www.internic.net/whois.html</a></p>' \
            '</div>' \
            '</div>' +
              ("<script src='#{config.get('beef.http.hook_file')}'></script>" if config.get('beef.http.web_server_imitation.hook_root')).to_s +
              '</body>' \
              '</html>'
          when 'iis'
            '<html>' \
            '<head>' \
            '<meta HTTP-EQUIV="Content-Type" Content="text/html; charset=Windows-1252">' \
            '<title ID=titletext>Under Construction</title>' \
            '</head>' \
            '<body bgcolor=white>' \
            '<table>' \
            '<tr>' \
            '<td ID=tableProps width=70 valign=top align=center>' \
            "<img ID=pagerrorImg src=\"#{bp}/media/images/icons/pagerror.gif\" width=36 height=48>" \
            '<td ID=tablePropsWidth width=400>' \
            '<h1 ID=errortype style="font:14pt/16pt verdana; color:#4e4e4e">' \
            '<P ID=Comment1><!--Problem--><P ID="errorText">Under Construction</h1>' \
            '<P ID=Comment2><!--Probable causes:<--><P ID="errordesc"><font style="font:9pt/12pt verdana; color:black">' \
            'The site you are trying to view does not currently have a default page. It may be in the process of being upgraded and configured.' \
            '<P ID=term1>Please try this site again later. If you still experience the problem, try contacting the Web site administrator.' \
            '<hr size=1 color="blue">' \
            '<P ID=message1>If you are the Web site administrator and feel you have received this message in error, please see &quot;Enabling and Disabling Dynamic Content&quot; in IIS Help.' \
            '<h5 ID=head1>To access IIS Help</h5>' \
            '<ol>' \
            '<li ID=bullet1>Click <b>Start</b>, and then click <b>Run</b>.' \
            '<li ID=bullet2>In the <b>Open</b> text box, type <b>inetmgr</b>. IIS Manager appears.' \
            '<li ID=bullet3>From the <b>Help</b> menu, click <b>Help Topics</b>.' \
            '<li ID=bullet4>Click <b>Internet Information Services</b>.</ol>' \
            '</td>' \
            '</tr>' \
            '</table>' +
              ("<script src='#{config.get('beef.http.hook_file')}'></script>" if config.get('beef.http.web_server_imitation.hook_root')).to_s +
              '</body>' \
              '</html>'
          when 'nginx'
            "<!DOCTYPE html>\n" \
            "<html>\n" \
            "<head>\n" \
            "<title>Welcome to nginx!</title>\n" \
            "<style>\n" \
            "    body {\n" \
            "        width: 35em;\n" \
            "        margin: 0 auto;\n" \
            "        font-family: Tahoma, Verdana, Arial, sans-serif;\n" \
            "    }\n" \
            "</style>\n" \
            "</head>\n" \
            "<body>\n" \
            "<h1>Welcome to nginx!</h1>\n" \
            "<p>If you see this page, the nginx web server is successfully installed and\n" \
            "working. Further configuration is required.</p>\n\n" \
            "<p>For online documentation and support please refer to\n" \
            "<a href=\"http://nginx.org/\">nginx.org</a>.<br/>\n" \
            "Commercial support is available at\n" \
            "<a href=\"http://nginx.com/\">nginx.com</a>.</p>\n\n" \
            "<p><em>Thank you for using nginx.</em></p>\n" +
              ("<script src='#{config.get('beef.http.hook_file')}'></script>" if config.get('beef.http.web_server_imitation.hook_root')).to_s +
              "</body>\n" \
              "</html>\n"
          else
            print_error 'Configuration error in beef.http.web_server_imitation.type!'
            print_more 'Supported values are: apache, iis, nginx.'
            ''
          end
        end

        def error_page_404
          config = BeEF::Core::Configuration.instance

          return 'Not Found.' unless config.get('beef.http.web_server_imitation.enable')

          case config.get('beef.http.web_server_imitation.type')
          when 'apache'
            return <<-EOF
<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML 2.0//EN">
<html><head>
<title>404 Not Found</title>
</head><body>
<h1>Not Found</h1>
<p>The requested URL was not found on this server.</p>
<hr>
<address>Apache/2.2.3 (CentOS)</address>
#{("<script src='#{config.get('beef.http.hook_file')}'></script>" if config.get('beef.http.web_server_imitation.hook_404'))}
</body></html>
EOF
          when 'iis'
            return <<-EOF
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<HTML><HEAD><TITLE>The page cannot be found</TITLE>
<META HTTP-EQUIV="Content-Type" Content="text/html; charset=Windows-1252">
<STYLE type="text/css">
  BODY { font: 8pt/12pt verdana }
  H1 { font: 13pt/15pt verdana }
  H2 { font: 8pt/12pt verdana }
  A:link { color: red }
  A:visited { color: maroon }
</STYLE></HEAD><BODY><TABLE width=500 border=0 cellspacing=10><TR><TD>
<h1>The page cannot be found</h1>
The page you are looking for might have been removed, had its name changed, or is temporarily unavailable.
<hr>
<p>Please try the following:</p>
<ul>
<li>Make sure that the Web site address displayed in the address bar of your browser is spelled and formatted correctly.</li>
<li>If you reached this page by clicking a link, contact the Web site administrator to alert them that the link is incorrectly formatted.</li>
<li>Click the <a href="javascript:history.back(1)">Back</a> button to try another link.</li>
</ul>
<h2>HTTP Error 404 - File or directory not found.<br>Internet Information Services (IIS)</h2>
<hr>
<p>Technical Information (for support personnel)</p>
<ul>
<li>Go to <a href="http://go.microsoft.com/fwlink/?linkid=8180">Microsoft Product Support Services</a> and perform a title search for the words <b>HTTP</b> and <b>404</b>.</li>
<li>Open <b>IIS Help</b>, which is accessible in IIS Manager (inetmgr),and search for topics titled <b>Web Site Setup</b>, <b>Common Administrative Tasks</b>, and <b>About Custom Error Messa
</ul>
</TD></TR></TABLE>
#{("<script src='#{config.get('beef.http.hook_file')}'></script>" if config.get('beef.http.web_server_imitation.hook_404'))}
</BODY></HTML>
EOF
          when 'nginx'
            return <<-EOF
<html>
<head><title>404 Not Found</title></head>
<body bgcolor="white">
<center><h1>404 Not Found</h1></center>
<hr><center>nginx</center>
#{("<script src='#{config.get('beef.http.hook_file')}'></script>" if config.get('beef.http.web_server_imitation.hook_404'))}
</body>
</html>
EOF
          else
            print_error 'Configuration error in beef.http.web_server_imitation.type!'
            print_more 'Supported values are: apache, iis, nginx.'
            'Not Found.'
          end
        end
      end
    end
  end
end
