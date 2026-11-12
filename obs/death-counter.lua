--[[
  Death Counter — OBS script (keyboard hotkeys)

  Install:  OBS → Tools → Scripts → "+" → pick this file.
  Setup:    1. Add a Text source (e.g. "Death Counter") to your scene and style it.
            2. In the script's settings, choose that Text source.
            3. Settings → Hotkeys → search "Death Counter" → bind keys
               for +1, -1 and Reset.
  The count is saved with OBS (and optionally to a text file), so it
  survives restarts. Hotkeys work while a game is focused.
]]

obs = obslua

local source_name = ""
local prefix      = "Deaths: "
local count       = 0
local file_path   = ""
local settings_ref = nil

local HOTKEYS = {
  { id = "deathcount_plus",  desc = "Death Counter: +1",   delta =  1 },
  { id = "deathcount_minus", desc = "Death Counter: -1",   delta = -1 },
  { id = "deathcount_reset", desc = "Death Counter: Reset", reset = true },
}
local hotkey_ids = {}

-- ---------- core ----------
local function update_text()
  if source_name == "" then return end
  local src = obs.obs_get_source_by_name(source_name)
  if src == nil then return end
  local s = obs.obs_data_create()
  obs.obs_data_set_string(s, "text", prefix .. tostring(count))
  obs.obs_source_update(src, s)
  obs.obs_data_release(s)
  obs.obs_source_release(src)
end

local function persist()
  -- Kept in the script's settings (saved by OBS with the scene collection).
  if settings_ref ~= nil then obs.obs_data_set_int(settings_ref, "count", count) end
  -- Optional: also write the plain number to a file (survives crashes, usable elsewhere).
  if file_path ~= "" then
    local f = io.open(file_path, "w")
    if f then f:write(tostring(count)); f:close() end
  end
end

local function set_count(n)
  n = math.floor(n)
  if n < 0 then n = 0 end
  if n > 999999 then n = 999999 end
  count = n
  persist()
  update_text()
end

-- ---------- script UI ----------
function script_description()
  return "<b>Death Counter</b><br>Shows a death count in a Text source and changes it with hotkeys " ..
         "(set them in Settings → Hotkeys → \"Death Counter\").<br>The count is saved automatically."
end

function script_properties()
  local props = obs.obs_properties_create()

  local list = obs.obs_properties_add_list(props, "source", "Text source",
    obs.OBS_COMBO_TYPE_EDITABLE, obs.OBS_COMBO_FORMAT_STRING)
  local sources = obs.obs_enum_sources()
  if sources ~= nil then
    for _, src in ipairs(sources) do
      local id = obs.obs_source_get_id(src)   -- e.g. text_gdiplus, text_gdiplus_v2, text_ft2_source_v2
      if string.find(id, "^text_gdiplus") or string.find(id, "^text_ft2_source") then
        local name = obs.obs_source_get_name(src)
        obs.obs_property_list_add_string(list, name, name)
      end
    end
  end
  obs.source_list_release(sources)

  obs.obs_properties_add_text(props, "prefix", "Label", obs.OBS_TEXT_DEFAULT)
  obs.obs_properties_add_int(props, "count", "Count", 0, 999999, 1)
  obs.obs_properties_add_path(props, "file", "Also save to file (optional)",
    obs.OBS_PATH_FILE_SAVE, "Text files (*.txt)", nil)

  obs.obs_properties_add_button(props, "btn_plus", "+1", function() set_count(count + 1); return false end)
  obs.obs_properties_add_button(props, "btn_minus", "-1", function() set_count(count - 1); return false end)
  obs.obs_properties_add_button(props, "btn_reset", "Reset to 0", function() set_count(0); return false end)
  return props
end

function script_defaults(settings)
  obs.obs_data_set_default_string(settings, "prefix", "Deaths: ")
  obs.obs_data_set_default_int(settings, "count", 0)
end

-- Called when the user edits a field in the script settings.
function script_update(settings)
  source_name = obs.obs_data_get_string(settings, "source")
  prefix      = obs.obs_data_get_string(settings, "prefix")
  file_path   = obs.obs_data_get_string(settings, "file")
  count       = obs.obs_data_get_int(settings, "count")
  update_text()
end

-- ---------- hotkeys ----------
function script_load(settings)
  settings_ref = settings
  for _, hk in ipairs(HOTKEYS) do
    local id = obs.obs_hotkey_register_frontend(hk.id, hk.desc, function(pressed)
      if not pressed then return end
      if hk.reset then set_count(0) else set_count(count + hk.delta) end
    end)
    local saved = obs.obs_data_get_array(settings, hk.id)
    obs.obs_hotkey_load(id, saved)
    obs.obs_data_array_release(saved)
    hotkey_ids[hk.id] = id
  end
  -- Re-apply the text once the scene collection has finished loading.
  obs.obs_frontend_add_event_callback(function(event)
    if event == obs.OBS_FRONTEND_EVENT_FINISHED_LOADING
       or event == obs.OBS_FRONTEND_EVENT_SCENE_COLLECTION_CHANGED then
      update_text()
    end
  end)
end

function script_save(settings)
  obs.obs_data_set_int(settings, "count", count)
  for _, hk in ipairs(HOTKEYS) do
    local arr = obs.obs_hotkey_save(hotkey_ids[hk.id])
    obs.obs_data_set_array(settings, hk.id, arr)
    obs.obs_data_array_release(arr)
  end
end
