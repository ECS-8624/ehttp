ehttp = ehttp or {}
ehttp.version = 1
local github_ver = 0

http.Fetch("https://raw.githubusercontent.com/ECS-8624/gmod-http/main/lua/autorun/http_fix.lua", function(contents, size)
    local Entry = string.match(contents, "ehttp.version%s=%s%d+")

    if Entry then
        github_ver = tonumber(string.match(Entry, "%d+")) or 0
    end

    if github_ver == 0 then
        print("[eHTTP/Version] Version couldn't be fetched. Your version is v " .. version)
    else
        if version >= github_ver then
            print("[eHTTP/Version] is up to date")
        else
            print("[eHTTP] a newer version is available! You may want to update Version: " .. version)

            if CLIENT then
                timer.Simple(18, function()
                    chat.AddText(Color(255, 0, 0), "[eHTTP] a newer version is available!")
                end)
            end
        end
    end
end)

local SERVER_STARTED = false

hook.Add("InitPostEntity", "ehttp", function()
    SERVER_STARTED = true
    hook.Remove("InitPostEntity", "ehttp")
end)

--
--  This is a patch for addons that attempted to fetch put it was made to early.
--  only really effective at startup.
--  Supports HTTP POST & FETCH LOGGER
--
local old_fetch = http.Fetch
local old_post = http.Post
ehttp.Blacklist = {}

local global_http_tbl = {
    ["FETCH"] = {},
    ["POST"] = {},
    ["Logging"] = {}
}

--: Table {["FETCH"], ["POST"]}
function ehttp:GetHTTP()
    return global_http_tbl
end

function ehttp:AddWebsiteToBlacklist(web)
    table.Add(ehttp.Blacklist, {web})
end

local function AddHttpLog(url, type_, trace, headers)
    table.Add(global_http_tbl["Logging"], {
        [type_] = {
            type = type_,
            url = url,
            bTrace = trace,
            headers = headers
        }
    })
end

function http.Fetch(url, onSuccess, onFailure, headers)
    AddHttpLog(url, "FETCH", debug.traceback() .. " --Likely?", headers)

    if not SERVER_STARTED then
        table.Add(global_http_tbl["FETCH"], {
            [url] = {
                url = url,
                run = function()
                    old_fetch(url, onSuccess, onFailure, headers)
                end
            }
        })
        --   PrintTable(global_http_tbl)
    else
        old_fetch(url, onSuccess, onFailure, headers)
    end
end

function http.Post(url, parameters, onSuccess, onFailure, headers)
    AddHttpLog(url, "POST", debug.traceback() .. " --Likely?", headers)

    if not SERVER_STARTED then
        table.Add(global_http_tbl["POST"], {
            [url] = {
                url = url,
                run = function()
                    old_post(url, parameters, onSuccess, onFailure, headers)
                end
            }
        })

        PrintTable(global_http_tbl)
    else
        old_post(url, parameters, onSuccess, onFailure, headers)
    end
end

-----------------------------------------------------------------------------
--  Autorun through table
------------------------------------------------------------------------------
hook.Add("InitPostEntity", "eHttpRUN", function()
    --  RunConsoleCommand("bot")
    timer.Simple(0, function()
        print("[eHTTP] Syncing EARLY HTTP REQUESTS")

        for _, v in pairs(global_http_tbl["FETCH"]) do
            global_http_tbl["FETCH"][_].run()
            print("[eHTTP] Running fetch for " .. global_http_tbl["FETCH"][_].url)
        end

        print("[eHTTP] Completed syncing for fetch.")
        print("[eHTTP] Syncing early posts")

        for _, v in pairs(global_http_tbl["POST"]) do
            print("[eHTTP] Posting to " .. global_http_tbl["POST"][_].url)
            global_http_tbl["POST"][_].run()
        end
    end)
end)