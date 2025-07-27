defmodule Server.Handler do
  def handle(request) do
    request
    |> parse
    |> log
    |> route
    |> format_response
  end

  def parse(request) do
    [method, path, _] =
      request
      |> String.split("\n")
      |> List.first()
      |> String.split()
    %{ method: method, path: path, resp_body: ""}
  end

  def log(conv), do: IO.inspect conv

  @spec route(%{:resp_body => any(), optional(any()) => any()}) :: %{
          :resp_body => <<_::160, _::_*40>>,
          optional(any()) => any()
        }
  def route(%{method: "GET", path: "/bear"} = conv) do
    %{ conv | resp_body: "Teddy, Smokey, Paddington" }
  end

  def route(%{method: "GET"} = conv) do
    %{ conv | resp_body: "Bears, Lions, Tigers" }
  end

  @spec format_response(any()) :: <<_::64, _::_*8>>
  def format_response(conv) do
    """
    HTTP/1.1 200 OK
    Content-Type: text/html
    Content-Length: #{String.length(conv.resp_body)}

    #{conv.resp_body}
    """
  end
end

request = """
GET /bear HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Server.Handler.handle(request)

IO.puts(response)

request = """
GET /wildthings HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Server.Handler.handle(request)

IO.puts(response)
