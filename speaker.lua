local speaker = peripheral.find("speaker") -- Find the connected speaker peripheral

if not speaker then
  print("No speaker found!")
  return
end

local soundName = "block.note_block.harp"
local volume = 3

while true do
  speaker.playSound(soundName, volume) -- Play the sound
  os.sleep(1) -- Wait for 1 second before playing the sound again
