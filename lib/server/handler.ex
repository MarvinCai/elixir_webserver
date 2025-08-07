defmodule Server.Handler do
  alias Server.Conv
  alias Server.BearController

  import Server.Plugins, only: [track: 1, rewrite_path: 1, log: 1]
  import Server.Parser, only: [parse: 1]

  @pages_path Path.expand("../../pages", __DIR__)

  @spec handle(binary()) :: <<_::64, _::_*8>>
  @doc "Trandforms request into a response"
  def handle(request) do
    request
    |> parse
    |> rewrite_path
    |> log
    |> route
    |> track
    |> format_response
  end

  def handle_file({:ok, content}, %Conv{} = conv) do
    %{ conv | resp_body: content , status: 200}
  end

  def handle_file({:error, :enoent}, %Conv{} = conv) do
    %{ conv | resp_body: "About page not found" , status: 404}
  end

  def handle_file({:error, reason}, %Conv{} = conv) do
    %{ conv | resp_body: "Error reading file #{reason}" , status: 500}
  end

  def route(%Conv{method: "GET", path: "/about"} = conv) do
    @pages_path
      |> Path.join("about.html")
      |> File.read
      |> handle_file(conv)
  end

  def route(%Conv{method: "GET", path: "/api/bears"} = conv) do
    Server.Api.BearController.index(conv)
  end

  def route(%Conv{method: "GET", path: "/bears"} = conv) do
    BearController.index(conv)
  end

  def route(%Conv{method: "GET", path: "/bears/" <> id} = conv) do
    params = Map.put(conv.params, "id", id)
    BearController.show(%Conv{conv | params: params})
  end

  def route(%Conv{method: "GET", path: "/wildthings"} = conv) do
    %{ conv | resp_body: "Bears, Lions, Tigers" , status: 200}
  end

  def route(%Conv{method: "POST", path: "/bears"} = conv) do
    BearController.create(conv)
  end

  def route(%Conv{} = conv) do
    %{ conv | resp_body: "No route for #{conv.path}" , status: 404}
  end

  def format_response(%Conv{} = conv) do
    """
    HTTP/1.1 #{Conv.full_status(conv)}\r
    Content-Type: #{conv.resp_content_type}\r
    Content-Length: #{String.length(conv.resp_body)}\r
    \r
    #{conv.resp_body}
    """
  end
end
