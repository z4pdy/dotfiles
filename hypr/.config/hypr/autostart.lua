hl.on("hyprland.start", function () 
   hl.exec_cmd("systemctl --user start hyprpolkitagent")
   hl.exec_cmd("mako")
   -- add ~/.local/bin to hyprland's PATH so waybar can access programs from that directory
   hl.exec_cmd("env PATH=$HOME/.local/bin:$PATH waybar")
end)
