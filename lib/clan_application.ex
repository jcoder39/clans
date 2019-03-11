defmodule Clan.Application do
  use Application

#  alias MinimalServer.Endpoint
#
#  def start(_type, _args),
#      do: Supervisor.start_link(children(), opts())
#
#  defp children do
#    [
#      Endpoint
#    ]
#  end
#
#  defp opts do
#    [
#      strategy: :one_for_one,
#      name: MinimalServer.Supervisor
#    ]
#  end

  def start(_type, _args) do

    {:ok, self()}
  end
end
