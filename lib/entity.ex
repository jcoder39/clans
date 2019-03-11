defmodule Player do
  require Record
  Record.defrecord :player, Player, [id: "", name: "", clan_name: ""]
end

defmodule Clan do
  require Record
  Record.defrecord :clan, Clan, [name: "", leader_id: "", participants: [], tag: ""]
end

defmodule Invitation do
  require Record
  Record.defrecord :invitation, Invitation, [id: "", to: "", from: "", clan_name: ""]
end