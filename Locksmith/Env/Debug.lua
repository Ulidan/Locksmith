local addonName, Locksmith = ...

function Locksmith:sPrint(...)
	local a,b = ...
	local out
	if a then
		if b then
			out = format(...)
		else
			out = a
		end
		DEFAULT_CHAT_FRAME:AddMessage("|cFF00FF00Locksmith: |r"..out)
	end
end
