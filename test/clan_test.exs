defmodule ClanTest do
  use ExUnit.Case
  doctest Clan

  test "greets the world" do
    assert Clan.hello() == :world
  end
end
