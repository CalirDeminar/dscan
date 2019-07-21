defmodule Dscan.Parser do
  def parse(text) do
    text
    |> String.replace("\r", "")
    |> String.split("\n")
    |> Enum.map(fn element -> String.split(element, "\t") end)
    |> Enum.map(fn element ->
      %{
        name: Enum.at(element, 1),
        type: Enum.at(element, 2),
        range: Enum.at(element, 3)
      }
    end)
  end

  def freq_count_type(input) do
    input
    |> Enum.reduce(%{}, fn element, acc ->
      name = element.type

      cond do
        Map.has_key?(acc, name) ->
          acc
          |> Map.replace!(name, Map.fetch!(acc, name) + 1)

        !Map.has_key?(acc, name) ->
          acc
          |> Map.put_new(name, 1)

        true ->
          acc
      end
    end)
  end

  def type_count_to_tags(input) do
    input
    |> Enum.reduce(%{}, fn element, acc ->
      name = elem(element, 0)
      count = elem(element, 1)
      lookup_table = File.read!("lookup_table.json") |> Poison.decode!()

      cond do
        Map.has_key?(lookup_table, name) && Map.has_key?(acc, name) ->
          tag = Map.fetch!(lookup_table, name)
          current = Map.fetch!(acc, name)
          Map.replace!(acc, tag, current + count)

        Map.has_key?(lookup_table, name) ->
          tag = Map.fetch!(lookup_table, name)
          Map.put_new(acc, tag, count)

        true ->
          acc
      end
    end)
  end

  def test() do
    path = "./test_dscan.txt"
    file = File.read!(path)

    type_count =
      parse(file)
      |> freq_count_type()

    tag_count = type_count |> type_count_to_tags()
    %{types: type_count, tags: tag_count}
  end
end
