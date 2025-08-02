defmodule Server.BearController do
  alias Server.Conv
  alias Server.WildThings
  alias Server.Bear
  def index(conv) do
    items =
      WildThings.list_bears()
      |> Enum.sort(&Bear.order_asc_by_name/2)
      |> Enum.map(&bear_item/1)
      |> Enum.join("\n")

    %{ conv | resp_body: "<ul>#{items}</ul>" , status: 200}
  end

  def show(%Conv{params: %{"id" => id}} = conv) do
    bear = WildThings.get_bear(id)
    %{ conv | resp_body: "<h1>Bear #{bear.id}: #{bear.name}  </h1>" , status: 200}
  end

  def create(%Conv{params: %{"type" => type, "name" => name}} = conv) do
    %{ conv | resp_body: "Created a #{type} bear name #{name}" , status: 201}
  end

  defp bear_item(bear) do
    "<li>#{bear.name} - #{bear.type}</li>"
  end
end
