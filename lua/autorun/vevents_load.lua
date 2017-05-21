if (CLIENT) then

	include("sh_vevents.lua")

end

if (SERVER) then

	include("sh_vevents.lua")
	AddCSLuaFile("sh_vevents.lua")

end