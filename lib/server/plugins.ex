defmodule Server.Plugins do
  alias Server.Conv

  def track(%Conv{status: 404, path: path} = conv) do
    IO.puts "#{path} is not available"
    conv
  end

  def track(%Conv{} = conv), do: conv

  def rewrite_path(%Conv{path: "/wildlife"} = conv) do
    %{conv | path: "/wildthings"}
  end

  def rewrite_path(%Conv{} = conv), do: conv

  def log(%Conv{} = conv), do: IO.inspect conv

end
