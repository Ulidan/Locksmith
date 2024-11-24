local addonName, Locksmith = ...
local _,_,_,interface = GetBuildInfo()

Locksmith.constants = {
	addonLoaded = "ADDON_LOADED",
	enteringWorld = "PLAYER_ENTERING_WORLD",
	icons = {
		[132594]=true,
		[132595]=true,
		[132596]=true,
		[132597]=true,
		[134344]=true,
	},
	red = {255,32,32,255},
	version = {
		era = (interface>10000 and interface<12000),
		tbc = (interface>20000 and interface<30000),
		wrath = (interface>30000 and interface<40000),
		cata = (interface>40000 and interface<50000),
	},
	practiceLock = 6712,
}