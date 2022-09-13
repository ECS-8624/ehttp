# Early HTTP
Workshop: [Click Here](https://steamcommunity.com/sharedfiles/filedetails/?id=2860984839)

# What is this?

This is a addon/script for the game Garry's Mod. To fix a error on early http calls. 

Overwritting the functions http.Fetch & http.Post (I didn't overwrite HTTP() ). 
This addon includes a logging of http requests & posts which should include where the
fetch has taken place.

# LUA/DEV 

| *Functions* | *Arguments* | *Description*
|  :--- | :--- | :--- |
| ehttp:GetHTTP() | none | Returns the table that contains the fetch & post table. And also the logging table.                    
| ehttp:AddWebsiteToBlacklist() | Url : String | A work in progress feature                        
| [http.Fetch](https://wiki.facepunch.com/gmod/http.Fetch) & [http.Post](https://wiki.facepunch.com/gmod/http.Post)                                   
