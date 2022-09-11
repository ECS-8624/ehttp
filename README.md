# ehttp
Workshop: https://steamcommunity.com/sharedfiles/filedetails/?id=2860435634

# What is this?

This is a addon/script for the game Garry's Mod. To fix a error on early http calls. 

Overwritting the functions http.Fetch & http.Post (I didn't overwrite HTTP() ). 
This addon includes a logging of http requests & posts which should include where the
fetch has taken place.

# Developers

Functions :
ehttp:GetHTTP() -- Returns the table that contains the fetch & post table. And also the logging table.
ehttp:AddWebsiteToBlacklist(url : string) -- A WIP currently has no effect
[http.Fetch](https://wiki.facepunch.com/gmod/http.Fetch) & [http.Post](https://wiki.facepunch.com/gmod/http.Post)
Note: this runs both on client & server. I'll likely add a function that'll retrieve http data that a player has made and send it to server as table. or remove the entire
script from running on client.
