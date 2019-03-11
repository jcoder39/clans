defmodule Invitation.Service do

  require Invitation

  def init() do
    :ets.new(:invitations,[:set, :protected, :named_table, {:keypos, Invitation.invitation(:id) + 1}])
  end

  def send(id, member_id, player_id, clan_name) do
    if Clan.Service.participant?(member_id) do
      invitation = Invitation.invitation(id: id, to: player_id, from: member_id, clan_name: clan_name)
      update(invitation)
    else false end
  end

  def accept(id) do
    invitation = get(id)
    player_id = Invitation.invitation(invitation, :to)
    clan_name = Invitation.invitation(invitation, :clan_name)

    Clan.Service.quit(player_id)
    Clan.Service.add(clan_name, player_id)

    delete(id)
  end

  def refuse(id) do
    delete(id)
  end

  def get(id) do
    hd(:ets.lookup(:invitations, id))
  end

  def get_all_by_player_id(id) do
    get_objects({:_, id, :_, :_})
  end

  def get_objects(condition) do
    :ets.match_object(:invitations, condition)
  end

  defp delete(id) do
    :ets.delete(:invitations, id)
  end

  defp update(invitation = Invitation.invitation()) do
    :ets.insert(:invitations, invitation)
  end

end
