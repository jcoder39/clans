defmodule Player.Service do

  require Player

  def init() do
    :ets.new(:players,[:set, :protected, :named_table, {:keypos, Player.player(:id) + 1}])
  end

  def register(name) do
    id = UUID.uuid1()
    player = Player.player(id: id, name: name)
    update(player)
    player
  end

  def get(id) do
    hd(:ets.lookup(:players, id))
  end

  def get_by_name(name) do
    get_objects({:_, :_, name, :_})
  end

  @doc """
    get objects from :players by pattern.
    Example: @condition = {:_, :_, name, :_}
  """
  def get_objects(condition) do
    :ets.match_object(:players, condition)
  end

  def update(player = Player.player()) do
    :ets.insert(:players, player)
  end

end
