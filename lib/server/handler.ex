defmodule Server.Handler do
  def handle(request) do
    request
    |> parse
    |> rewrite_path
    |> log
    |> route
    |> track
    |> format_response
  end

  def parse(request) do
    [method, path, _] =
      request
      |> String.split("\n")
      |> List.first()
      |> String.split()
    %{
      method: method,
      path: path,
      resp_body: "",
      status: nil
    }
  end

  def track(%{status: 404, path: path} = conv) do
    IO.puts "#{path} is not available"
    conv
  end

  def track(conv), do: conv

  def rewrite_path(%{path: "/wildlife"} = conv) do
    %{conv | path: "/wildthings"}
  end

  def rewrite_path(conv), do: conv

  def log(conv), do: IO.inspect conv

  def handle_file({:ok, content}, conv) do
    %{ conv | resp_body: content , status: 200}
  end

  def handle_file({:error, :enoent}, conv) do
    %{ conv | resp_body: "About page not found" , status: 404}
  end

  def handle_file({:error, reason}, conv) do
    %{ conv | resp_body: "Error reading file #{reason}" , status: 500}
  end

  def route(%{method: "GET", path: "/about"} = conv) do
      Path.expand("../../pages", __DIR__)
      |> Path.join("about.html")
      |> File.read
      |> handle_file(conv)
  end

  def route(%{method: "GET", path: "/bear"} = conv) do
    %{ conv | resp_body: "Teddy, Smokey, Paddington" , status: 200}
  end

  def route(%{method: "GET", path: "/bear/" <> id} = conv) do
    %{ conv | resp_body: "Bear #{id}" , status: 200}
  end

  def route(%{method: "GET", path: "/wildthings"} = conv) do
    %{ conv | resp_body: "Bears, Lions, Tigers" , status: 200}
  end

  def route(conv) do
    %{ conv | resp_body: "No route for #{conv.path}" , status: 404}
  end

  def format_response(conv) do
    """
    HTTP/1.1 #{conv[:status]} #{status_reason(conv[:status])}
    Content-Type: text/html
    Content-Length: #{String.length(conv.resp_body)}

    #{conv.resp_body}
    """
  end

    defp status_reason(code) do
    %{
      200 => "OK",
      201 => "Created",
      401 => "Unauthorized",
      403 => "Forbidden",
      404 => "Not Found",
      500 => "Internal Server Error"
    }[code]
  end
end

request = """
GET /bear/1 HTTP/1.1
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

request = """
GET /wildlife HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Server.Handler.handle(request)

IO.puts(response)

request = """
GET /bigfoot HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Server.Handler.handle(request)

IO.puts(response)

request = """
GET /about HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Server.Handler.handle(request)

IO.puts(response)
