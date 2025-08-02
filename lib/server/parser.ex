defmodule Server.Parser do
  alias Server.Conv

  def parse(request) do
    [top, params] = String.split(request, "\n\n")

    [rquest_method | headers_lines] = String.split(top, "\n")
    [method, path, _] = String.split(rquest_method, " ")

    headers = parse_headers(headers_lines)# %{})
    params = parse_params(headers["Content-Type"], params)
    IO.inspect(headers, label: "Parsed Headers")
    %Conv{
      method: method,
      path: path,
      params: params
    }
  end

  def parse_params("application/x-www-form-urlencoded", params_str) do
    params_str |> String.trim |> URI.decode_query
  end

  def parse_params(_, _), do: %{}

  # def parse_headers([first | rest], headers) do
  #   [key, value] = String.split(first, ":", parts: 2)
  #   parse_headers(rest, Map.put(headers, String.trim(key), String.trim(value)))
  # end

  # def parse_headers([], headers), do: headers

  def parse_headers(headers) do
    IO.puts("Parsing headers: #{inspect(headers)}")
    for header <- headers,
      [key, value] <- [String.split(header, ": ")],
      into: %{} do
      #[key, value] = String.split(header, ":", part: 2)
      {String.trim(key), String.trim(value)}
    end
  end
end
