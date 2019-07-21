defmodule Dscan.Lookup do
  @ship_cat_path "ship_categories.json"
  @ship_lookup_path "ship_lookup.json"

  def lookup_group(id) do
    HTTPoison.get!(
      "https://esi.evetech.net/latest/universe/groups/#{id}/?datasource=tranquility&language=en-us"
    ).body
    |> Poison.decode!()
  end

  def lookup_types(ids) do
    HTTPoison.post!(
      "https://esi.evetech.net/latest/universe/names/?datasource=tranquility",
      ids |> inspect(limit: 500),
      [{"Content-Type", "application/json"}]
    ).body
    |> Poison.decode!()
  end

  def get_ships() do
    ship_types = %{
      frigates: 25,
      cruiser: 26,
      battleship: 27,
      industrial: 28,
      titan: 30,
      shuttle: 31,
      assault_ship: 324,
      heavy_assault_ship: 358,
      transport_ship: 380,
      battlecruiser: 419,
      destroyer: 420,
      mining_barge: 463,
      dreadnought: 485,
      freighter: 513,
      command_ship: 540,
      interdictor: 541,
      exhumer: 543,
      carrier: 547,
      supercarrier: 659,
      covert_ops: 830,
      interceptor: 831,
      logistics: 832,
      force_recon: 833,
      stealth_bomber: 834,
      capital_industrial: 883,
      electronic_attack_ship: 893,
      heavy_interdictor: 894,
      black_ops: 898,
      marauder: 900,
      jump_freighter: 902,
      combat_recon: 906,
      industrial_command_ship: 941,
      strategic_cruiser: 963,
      logistics_frigates: 1527,
      tactical_destroyer: 1305,
      citadel: 1657,
      engineering_complex: 1404,
      refinery: 1406,
      command_destroyer: 1534,
      expedition_frigate: 1283,
      force_aux: 1538,
      flag_cruiser: 1972
    }

    ship_types
    |> Enum.map(fn element ->
      result =
        element
        |> elem(1)
        |> lookup_group()

      %{name: result["name"], ships: lookup_types(result["types"])}
    end)
  end

  def create_lookup_table() do
    categories = File.read!(@ship_cat_path) |> Poison.decode!()

    categories
    |> Enum.reduce(%{}, fn category, acc ->
      Enum.reduce(category["ships"], acc, fn ship, acc_two ->
        IO.inspect(ship)
        IO.inspect(category)

        if ship["name"] && category["name"] do
          acc_two
          |> Map.put_new(ship["name"], category["name"])
        else
          acc_two
        end
      end)
    end)
  end
end
