local async = require('async')

local base_url = 'http://www.unashamedstudio.com/game-designer/'
local update_status = ''
local is_loading = true
local num_load_steps = 2
local curr_load_step = 0
local ver = '0.10'
local load_time

function hex(hex_str)
  _,_,r,g,b = hex_str:find('(%x%x)(%x%x)(%x%x)')
  return { tonumber(r, 16), tonumber(g, 16), tonumber(b, 16) }
end

function love.load(args)
  love.window.setTitle('GameDesigner ' .. ver)
  love.graphics.setBackgroundColor(hex('ffffff'))
  font = love.graphics.newFont("OpenSans-Bold.ttf", 15)
  love.graphics.setFont(font)
  logo = love.graphics.newImage('logo.png')
  logo_w = logo:getWidth()
  logo_h = logo:getHeight()

  if args.updated then
    update_status = 'Update complete'
    is_loading = false
    load_time = love.timer.getTime()
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
      curr_load_step = curr_load_step + 1
      local getVersionMeta = assert(loadstring("return " .. result))
      version = getVersionMeta().version
      if not love.filesystem.isFile('game_' .. version .. '.love') then
        update_status = 'Update found, downloading...'
        game_request(function(result, status)
          if status == 200 then
            curr_load_step = curr_load_step + 1
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
        curr_load_step = curr_load_step + 1
        update_status = 'No updates found, loading app...'

        love.filesystem.mount('game_' .. version .. '.love', '')
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
  local curr_time = love.timer.getTime()
  local width, height = love.graphics.getDimensions()

  if is_loading or curr_time - load_time < 1 then
    love.graphics.setColor(hex('ffffff'));
    love.graphics.draw(logo, width / 2 - logo_w / 2, height / 2 - logo_h / 2)

    local bar_w = width / 2
    love.graphics.setColor(hex('e0f4fc'))
    love.graphics.rectangle('fill', width / 4, height / 2 + 75, bar_w, 20)

    local load_pct = curr_load_step / num_load_steps
    love.graphics.setColor(hex('29AAE2'))
    love.graphics.rectangle('fill', width / 4, height / 2 + 75, bar_w * load_pct, 20)

    love.graphics.setColor(hex('29aae2'))
    local text_w = font:getWidth(update_status)
    love.graphics.print(update_status, width / 2 - text_w / 2, height / 2 + 50)
  else
    local blank_slate = 'Drag and drop your Tiled export file here to begin.'
    
    love.graphics.setColor(hex('29aae2'))
    local text_w = font:getWidth(blank_slate)
    love.graphics.print(blank_slate, width / 2 - text_w / 2, height / 2)
  end
end
