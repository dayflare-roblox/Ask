# Ask
A Client Ask system, acting similar to invoke client but with a more complex waiting system.
This Module is only callable from the server, calling from the client will result in an error.

Simple Usge:
```
local Ask = require(Module)

Ask:Ask(Player: Player, Options)
```

Connecting Events:
```
local Ask = require(Module)

Ask.RequestAdded:Connect(function(Key: number)
  if Key and Ask.Requests[Key] then
      print("do stuff")
  end
end)

Ask.RequestResolved:Connect(function(Key: number)
	if Key and Ask.Requests[Key] then
	end
end)
```
