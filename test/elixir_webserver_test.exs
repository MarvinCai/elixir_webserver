defmodule ElixirWebserverTest do
  use ExUnit.Case
  doctest ElixirWebserver

  test "greets the world" do
    assert ElixirWebserver.hello() == :world
  end
end
