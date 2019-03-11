defmodule Clan.Supervisor do

  use Supervisor

  def start_link() do
    Supervisor.start_link(__MODULE__, [], [{:name, __MODULE__}])
  end

  def init([]) do
    children = [
#      worker(Clan.Service, [], restart: :transient),
#      worker(Player.Service, [], restart: :transient)
    ]

    supervise(children, strategy: :rest_for_one)
  end
end