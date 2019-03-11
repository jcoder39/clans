defmodule Clan.Service do

  require Clan
  require Player

  def init() do
    :ets.new(:clans, [:set, :protected, :named_table, {:keypos, Clan.clan(:name) + 1}])
  end

  @doc """
    create clan
  """
  def create(leader_id, clan_name, clan_tag) do
    clan = Clan.clan(name: clan_name, tag: clan_tag, leader_id: leader_id)
    update(clan)
    add(clan_name, leader_id)
    clan
  end

  def get(clan_name) do
    if clan_name == "" do
      {:error}
    else
      case :ets.lookup(:clans, clan_name) do
        [] -> {:error}
        result -> {:ok, hd(result)}
      end
    end
  end

  @doc """
    add a player to a clan
  """
  def add(clan_name, player_id) do
    result = get(clan_name)
    case result do
      {:error} -> false
      {:ok, clan} ->
        participants_new = Clan.clan(clan, :participants) ++ [player_id]
        clan_new = Clan.clan(clan, participants: participants_new)
        update(clan_new)

        player = Player.Service.get(player_id)
        player = Player.player(player, clan_name: clan_name)
        Player.Service.update(player)
    end
  end

  @doc """
    quit from a clan
  """
  def quit(player_id) do
    player = Player.Service.get(player_id)
    clan_name = Player.player(player, :clan_name)

    result = get(clan_name)
    case result do
      {:error} -> false
      {:ok, clan} ->
        participants_new = Clan.clan(clan, :participants) -- [player_id]
        clan_new = Clan.clan(clan, participants: participants_new)
        update(clan_new)

        player = Player.player(player, clan_name: "")
        Player.Service.update(player)
    end
  end

  def grant(from = Player.player(), to = Player.player()) do
    with true <- leader?(from),
         {:ok, clan} <- get(Player.player(from, :clan_name)),
         true <- participant?(clan, to) do
      clan_new = Clan.clan(clan, leader_id: Player.player(to, :id))
      update(clan_new)
    else
      _ -> false
    end
  end

  def dismiss(leader = Player.player(id: leader_id, clan_name: clan_name), aim = Player.player(id: player_id)) do
    with true <- leader_id != player_id,
         true <- leader?(leader),
         {:ok, clan} <- get(clan_name),
         true <- participant?(clan, aim) do
      quit(player_id)
    else
      _ -> false
    end
  end

  def participant?(player_id) do
    player = Player.Service.get(player_id)
    clan_name = Player.player(player, :clan_name)

    case get(clan_name) do
      {:error} -> false
      {:ok, clan} -> participant?(clan, player)
    end
  end

  defp participant?(Clan.clan(participants: participants), Player.player(id: player_id)) do
    Enum.member?(participants, player_id)
  end

  defp leader?(Player.player(id: player_id, clan_name: clan_name)) do
    result = get(clan_name)
    case result do
      {:error} -> false
      {:ok, clan} ->
        leader_id = Clan.clan(clan, :leader_id)
        leader_id === player_id
    end
  end

  defp update(clan = Clan.clan()) do
    :ets.insert(:clans, clan)
  end

end
