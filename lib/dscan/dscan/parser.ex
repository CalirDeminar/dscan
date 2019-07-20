defmodule Dscan.Parser do
  def parse(text) do
    text
    |> String.replace("\r", "")
    |> String.split("\n")
    |> Enum.map(fn element -> String.split(element, "\t") end)
    |> Enum.map(fn element ->
      %{
        icon: Enum.at(element, 0),
        name: Enum.at(element, 1),
        type: Enum.at(element, 2),
        range: Enum.at(element, 3)
      }
    end)
  end

  def test() do
    path = "./test_dscan.txt"
    file = File.read!(path)
    parse(file)
  end
end
