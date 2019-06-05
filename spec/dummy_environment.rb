# frozen_string_literal: true

class DummyEnv
  attr_accessor :env, :headers

  def initialize
    @headers = [
      'Version', 'Host', 'Connection',
      'Content-Length', 'Cache-Control',
      'Origin', 'Upgrade-Insecure-Requests',
      'Content-Type', 'User-Agent', 'Accept',
      'Referer', 'Accept-Encoding', 'Accept-Language'
    ]
    @env = {
      'rack.version' => [1, 3],
      'rack.multithread' => true,
      'rack.multiprocess' => false,
      'rack.run_once' => false,
      'rack.url_scheme' => 'http',
      'SCRIPT_NAME' => '',
      'QUERY_STRING' => '',
      'SERVER_PROTOCOL' => 'HTTP/1.1',
      'SERVER_SOFTWARE' => 'puma 3.12.1 Llamas in Pajamas',
      'GATEWAY_INTERFACE' => 'CGI/1.2',
      'REQUEST_METHOD' => 'POST',
      'REQUEST_PATH' => '/posts',
      'REQUEST_URI' => '/posts',
      'HTTP_VERSION' => 'HTTP/1.1',
      'HTTP_HOST' => 'localhost:3000',
      'HTTP_CONNECTION' => 'keep-alive',
      'CONTENT_LENGTH' => '216',
      'HTTP_CACHE_CONTROL' => 'max-age=0',
      'HTTP_ORIGIN' => 'http://localhost:3000',
      'HTTP_UPGRADE_INSECURE_REQUESTS' => '1',
      'CONTENT_TYPE' => 'application/x-www-form-urlencoded',
      'HTTP_USER_AGENT' => 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.86 Safari/537.36',
      'HTTP_ACCEPT' => 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3',
      'HTTP_REFERER' => 'http://localhost:3000/posts/new',
      'HTTP_ACCEPT_ENCODING' => 'gzip, deflate, br',
      'HTTP_ACCEPT_LANGUAGE' => 'ru,en-US;q=0.9,en;q=0.8,uk;q=0.7,la;q=0.6',
      'HTTP_COOKIE' =>
      '_buggy_session=4cy6IeLwNauIDuSulvKwThztbfk62QUFlLs2QaTinMnNBM5BoaauF5XUpGgA0y67aOyzO19%2Fj4QCIOhuB1itwktCBurILZIacWPH4%2BlR50F3Z7ut%2FGKn4eAhjpzWOZvAVNrGSIYVY3q8b5Ubi9o%3D--shB6e1WnBy7sqDIZ--N4rdNhyJ%2B%2FhXArc0SYvXbw%3D%3D',
      'SERVER_NAME' => 'localhost',
      'SERVER_PORT' => '3000',
      'PATH_INFO' => '/posts',
      'REMOTE_ADDR' => '::1'
    }
  end

  class NameError < StandardError
  end

  def dummy_exception
    raise NameError
  rescue StandardError => e
    e
  end
end
