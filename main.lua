local async = require('async')

local base_url = 'http://www.unashamedstudio.com/game-designer/'
local update_status = ''

function love.load(args)
  if args.updated then
    update_status = 'Update complete'
    return
  end

  async.load()
  async.ensure.atLeast(2)
  
  local version = nil
  local version_request = async.define("version_request", function()
    local http = require("socket.http")
    local base_url = 'http://www.unashamedstudio.com/game-designer/'
    return http.request(base_url .. 'version.lua')
  end)
  
  local game_request = async.define("game_request", function(version)
    local http = require("socket.http")
    local base_url = 'http://www.unashamedstudio.com/game-designer/'
    return http.request(base_url .. 'game_' .. version .. '.love')
  end)
  
  update_status = 'Checking for updates...';
  version_request(function(result, status)
    if status == 200 then
      local getVersionMeta = assert(loadstring("return " .. result))
      version = getVersionMeta().version
      if not love.filesystem.isFile('game_' .. version .. '.love') then
        update_status = 'Update found, downloading...'
        game_request(function(result, status)
          if status == 200 then
            love.filesystem.write('game_' .. version .. '.love', result)  
            love.filesystem.mount('game_' .. version .. '.love', '')
            package.loaded.main = nil
            package.loaded.conf = nil
            love.conf = nil
            love.init()
            love.load({updated = true})
          end
        end, version)
      else
        update_status = 'No new updates found, loading game...'
        love.filesystem.mount('game_' .. version .. '.love')
        package.loaded.main = nil
        package.loaded.conf = nil
        love.conf = nil
        love.init()
        love.load({updated = true})
      end
    end
  end)
end

function love.update(dt)
  async.update()
end

function love.draw()
  love.graphics.print(update_status, 400, 300)
end
