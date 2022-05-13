local Ask = {}

if game.Players.LocalPlayer then
	warn("You're attempting to require the "..script.Name.." module on the server, currently this is unavailable.")
	return Ask
end

Ask.RemoteFunction = Instance.new("RemoteFunction", game.ReplicatedStorage)
Ask.RemoteFunction.Name = "AskFunction"
Ask.CustomEvents = require(game.ReplicatedStorage.CustomEvents)

Ask.RequestAdded = Ask.CustomEvents.new()
Ask.RequestResolved = Ask.CustomEvents.new()

Ask.Requests = {}

function Ask:Ask(Player: Player, Options)
	if not Player or not Options then return end
	
	local Key = Player.UserId
	
	if self.Requests[Key] then
		repeat Key += 1
		until not self.Requests[Key]	
	end
	
	self.Requests[Key] = {
		self.RemoteFunction:InvokeClient(Player, Options),
		Options
	}
	
	Ask.RequestAdded:Fire(Key)
end

Ask.RequestAdded:Connect(function(Key: number)
	if Key and Ask.Requests[Key] then
		local Request = Ask.Requests[Key]
		
		repeat wait() until Request[1] ~= nil
		
		local Selected = Request[2][Request[1]]
		
		if Selected then
			Selected.Init()
			Ask.RequestResolved:Fire(Key)
		else
			warn("ASK: No valid option was selected during request "..Key)			
		end
	end
end)

Ask.RequestResolved:Connect(function(Key: number)
	if Key and Ask.Requests[Key] then
		Ask.Requests[Key] = nil
	end
end)

return Ask
