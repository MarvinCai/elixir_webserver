defmodule Server.BearController do
  alias Server.Conv
  alias Server.WildThings
  alias Server.Bear

  @template_path Path.expand("../../templates", __DIR__)

  defp render(conv, template, bindings \\ []) do
    content =
      @template_path
      |> Path.join(template)
      |>EEx.eval_file(bindings)

    %{ conv | resp_body: content , status: 200}
  end
  def index(conv) do
    items =
      WildThings.list_bears()
      |> Enum.sort(&Bear.order_asc_by_name/2)


    render(conv, "index.eex", [bears: items])
  end

  def show(%Conv{params: %{"id" => id}} = conv) do
    bear = WildThings.get_bear(id)

    render(conv, "show.eex", [bear: bear])
  end

  def create(%Conv{params: %{"type" => type, "name" => name}} = conv) do
    %{ conv | resp_body: "Created a #{type} bear name #{name}" , status: 201}
  end
end
