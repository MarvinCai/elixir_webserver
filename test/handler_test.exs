defmodule HandlerTest do
  use ExUnit.Case

  import Server.Handler, only: [handle: 1]

  test "Get /bears" do
    request = """
      GET /bears HTTP/1.1\r
      Host: example.com\r
      User-Agent: ExampleBrowser/1.0\r
      Accept: */*\r
      \r
      """

    response = Server.Handler.handle(request)

    expected_response = """
    HTTP/1.1 200 OK\r
    Content-Type: text/html\r
    Content-Length: 356\r
    \r
    <h1>All The Bears!</h1>

    <ul>

        <li>Brutus - Grizzly</li>

        <li>Iceman - Polar</li>

        <li>Kenai - Grizzly</li>

        <li>Paddington - Brown</li>

        <li>Roscoe - Panda</li>

        <li>Rosie - Black</li>

        <li>Scarface - Grizzly</li>

        <li>Smokey - Black</li>

        <li>Snow - Polar</li>

        <li>Teddy - Brown</li>

    </ul>
    """
    assert remove_whitespace(response) == remove_whitespace(expected_response)
  end

  test "GET /bears/:id" do
    request = """
    GET /bears/1 HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = Server.Handler.handle(request)
    expected_response = """
    HTTP/1.1 200 OK\r
    Content-Type: text/html\r
    Content-Length: 72\r
    \r
    <h1>Show Bear</h1>
    <p>
    Is Teddy hibernating? <strong>true</strong>
    </p>
    """

    assert remove_whitespace(response) == remove_whitespace(expected_response)
  end

  test "Get /wildthings" do
    request = """
    GET /wildthings HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = Server.Handler.handle(request)

    expected_response = """
    HTTP/1.1 200 OK\r
    Content-Type: text/html\r
    Content-Length: 20\r
    \r
    Bears, Lions, Tigers
    """

    assert remove_whitespace(response) == remove_whitespace(expected_response)
  end

  test "GET /wildlife" do

    request = """
    GET /wildlife HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = Server.Handler.handle(request)

    expected_response = """
    HTTP/1.1 200 OK\r
    Content-Type: text/html\r
    Content-Length: 20\r
    \r
    Bears, Lions, Tigers
    """

    assert remove_whitespace(response) == remove_whitespace(expected_response)
  end

  test "GET /bigfoot" do
    request = """
    GET /bigfoot HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = Server.Handler.handle(request)


    expected_response = """
    HTTP/1.1 404 Not Found\r
    Content-Type: text/html\r
    Content-Length: 21\r
    \r
    No route for /bigfoot
    """

    assert remove_whitespace(response) == remove_whitespace(expected_response)
  end

  test "POST /bears" do
    request = """
    POST /bears HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    Content-Type: application/x-www-form-urlencoded\r
    Content-Length: 21\r
    \r
    name=Baloo&type=Brown
    """

    response = Server.Handler.handle(request)
    expected_response = """
    HTTP/1.1 201 Created\r
    Content-Type: text/html\r
    Content-Length: 31\r
    \r
    Created a Brown bear name Baloo
    """

    assert remove_whitespace(response) == remove_whitespace(expected_response)
  end

  defp remove_whitespace(text) do
    String.replace(text, ~r{\s}, "")
  end
end
