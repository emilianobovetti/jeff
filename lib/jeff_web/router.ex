defmodule JeffWeb.Router do
  use Plug.Router

  plug JeffWeb.CodeReloader

  plug Plug.Parsers, parsers: [:urlencoded]

  plug Plug.Logger
  plug :match
  plug :dispatch

  defp slicer_args do
    %{
      acceleration_enabled: "false",
      acceleration_print: "500",
      acceleration_roofing: "1000",
      acceleration_travel_layer_0: "1000",
      acceleration_travel: "500",
      adaptive_layer_height_enabled: "false",
      adaptive_layer_height_variation_step: "0.04",
      adaptive_layer_height_variation: "0.04",
      adhesion_type: "skirt",
      anti_overhang_mesh: "false",
      brim_replaces_support: "false",
      center_object: "false",
      clean_between_layers: "false",
      cool_fan_enabled: "true",
      cool_fan_full_at_height: "layer_height_0 + 2 * layer_height",
      cool_fan_full_layer: "2",
      cool_fan_speed_0: "0",
      cool_fan_speed_max: "100",
      cool_fan_speed_min: "100",
      cool_min_layer_time_fan_speed_max: "10",
      cool_min_layer_time: "10",
      cool_min_speed: "10",
      cool_min_temperature: "0",
      cutting_mesh: "false",
      fill_outline_gaps: "false",
      gantry_height: "25",
      infill_before_walls: "false",
      infill_mesh: "false",
      infill_overlap: "30.0",
      infill_pattern: "cubic",
      infill_wipe_dist: "0.0",
      jerk_enabled: "false",
      jerk_print: "8",
      jerk_travel_layer_0: "jerk_travel",
      jerk_travel: "jerk_print",
      layer_height_0: "0.3",
      layer_height: "0.1",
      layer_start_x: "0.0",
      layer_start_y: "0.0",
      machine_acceleration: "500",
      machine_always_write_active_tool: "false",
      machine_center_is_zero: "false",
      machine_depth: "235",
      machine_end_gcode:
        "G91 ;Relative positioning\nG1 E-2 F2700 ;Retract a bit\nG1 E-2 Z0.2 F2400 ;Retract and raise Z\nG1 X5 Y5 F3000 ;Wipe out\nG1 Z10 ;Raise Z more\nG90 ;Absolute positioning\n\nG1 X0 Y{machine_depth} ;Present print\nM106 S0 ;Turn-off fan\nM104 S0 ;Turn-off hotend\nM140 S0 ;Turn-off bed\n\nM84 X Y E ;Disable all steppers but Z\n",
      machine_extruder_cooling_fan_number: "0",
      machine_extruder_start_code: "",
      machine_extruders_share_heater: "false",
      machine_extruders_share_nozzle: "false",
      machine_firmware_retract: "false",
      machine_gcode_flavor: "RepRap (Marlin/Sprinter)",
      machine_heated_bed: "true",
      machine_heated_build_volume: "false",
      machine_height: "250",
      machine_max_acceleration_e: "5000",
      machine_max_acceleration_x: "500",
      machine_max_acceleration_y: "500",
      machine_max_acceleration_z: "100",
      machine_max_feedrate_e: "50",
      machine_max_feedrate_x: "500",
      machine_max_feedrate_y: "500",
      machine_max_feedrate_z: "10",
      machine_max_jerk_e: "5",
      machine_max_jerk_xy: "10",
      machine_max_jerk_z: "0.4",
      machine_minimum_feedrate: "false",
      machine_name: "Creality Ender-3",
      machine_nozzle_temp_enabled: "true",
      machine_start_gcode:
        "; Ender 3 Custom Start G-code\nG92 E0 ; Reset Extruder\nG28 ; Home all axes\nG1 Z2.0 F3000 ; Move Z Axis up little to prevent scratching of Heat Bed\nG1 X0.1 Y20 Z0.3 F5000.0 ; Move to start position\nG1 X0.1 Y200.0 Z0.3 F1500.0 E15 ; Draw the first line\nG1 X0.4 Y200.0 Z0.3 F5000.0 ; Move to side a little\nG1 X0.4 Y20 Z0.3 F1500.0 E30 ; Draw the second line\nG92 E0 ; Reset Extruder\nG1 Z2.0 F3000 ; Move Z Axis up little to prevent scratching of Heat Bed\nG1 X5 Y20 Z0.3 F5000.0 ; Move over to prevent blob squish",
      machine_use_extruder_offset_to_offset_coords: "true",
      machine_width: "235",
      magic_spiralize: "false",
      material_bed_temp_prepend: true,
      material_bed_temp_wait: "true",
      material_bed_temperature_layer_0: "60",
      material_diameter: "1.75",
      material_final_print_temperature: "material_print_temperature",
      material_guid: "",
      material_initial_print_temperature: "material_print_temperature",
      material_print_temp_prepend: "true",
      material_print_temp_wait: "true",
      material_print_temperature_layer_0: "215",
      material_shrinkage_percentage_xy: "100.0",
      material_shrinkage_percentage_z: "100.0",
      max_extrusion_before_wipe: "10",
      mesh_position_x: "0",
      mesh_position_y: "0",
      mesh_position_z: "0",
      mesh_rotation_matrix: "[[1,0,0], [0,1,0], [0,0,1]]",
      meshfix_maximum_resolution: "0.25",
      meshfix_maximum_travel_resolution: "meshfix_maximum_resolution",
      min_wall_line_width: "0.3",
      minimum_interface_area: "10",
      minimum_support_area: "2 if support_structure == 'normal' else 0",
      optimize_wall_printing_order: "True",
      prime_tower_enable: "false",
      raft_base_extruder_nr: "0",
      raft_interface_extruder_nr: "0",
      raft_surface_extruder_nr: "0",
      relative_extrusion: "false",
      remove_empty_first_layers: "true",
      retraction_amount: "6.5",
      retraction_combing_max_distance: "30",
      retraction_combing: "'off' if retraction_hop_enabled else 'noskin'",
      retraction_count_max: "100",
      retraction_enable: "true",
      retraction_extra_prime_amount: "0",
      retraction_extrusion_window: "10",
      retraction_hop_after_extruder_switch_height: "1",
      retraction_hop_after_extruder_switch: "true",
      retraction_hop: "0.2",
      retraction_min_travel: "1.5",
      retraction_prime_speed: "0.8",
      retraction_retract_speed: "0.8",
      retraction_speed: "0.8",
      roofing_layer_count: "0",
      roofing_monotonic: "true",
      skin_overlap: "10.0",
      skirt_brim_extruder_nr: "false",
      skirt_gap: "10.0",
      skirt_line_count: "3",
      slicing_tolerance: "middle",
      speed_layer_0: "20.0",
      speed_prime_tower: "speed_topbottom",
      speed_print: "50.0",
      speed_roofing: "speed_topbottom",
      speed_support_interface: "speed_topbottom",
      speed_support: "speed_wall_0",
      speed_travel_layer_0:
        "100 if speed_layer_0 < 20 else 150 if speed_layer_0 > 30 else speed_layer_0 * 5",
      speed_travel:
        "150.0 if speed_print < 60 else 250.0 if speed_print > 100 else speed_print * 2.5",
      speed_wall_x: "speed_wall",
      speed_z_hop: "5",
      support_angle: "math.floor(math.degrees(math.atan(line_width / 2.0 /layer_height)))",
      support_bottom_angles: "[]",
      support_bottom_extruder_nr: "0",
      support_bottom_pattern: "concentric",
      support_brim_enable: "true",
      support_brim_width: "4",
      support_enable: "true",
      support_extruder_nr_layer_0: "0",
      support_infill_angles: "[]",
      support_infill_extruder_nr: "0",
      support_infill_rate: "0 if support_enable and support_structure == 'tree' else 20",
      support_interface_density: "33.333",
      support_interface_enable: "true",
      support_interface_height: "layer_height * 4",
      support_interface_pattern: "'grid'",
      support_pattern: "'zigzag'",
      support_roof_angles: "[]",
      support_roof_extruder_nr: "0",
      support_roof_pattern: "concentric",
      support_xy_distance_overhang: "wall_line_width_0",
      support_xy_distance: "wall_line_width_0 * 2",
      support_xy_overrides_z: "'xy_overrides_z'",
      support_z_distance: "layer_height if layer_height >= 0.16 else layer_height * 2",
      switch_extruder_extra_prime_amount: "0",
      switch_extruder_prime_speed: "20",
      switch_extruder_retraction_amount: "20",
      switch_extruder_retraction_speed: "20",
      top_bottom_thickness: "layer_height_0 + layer_height * 3",
      travel_avoid_other_parts: "true",
      travel_avoid_supports: "true",
      travel_retract_before_outer_wall: "true",
      wall_0_wipe_dist: "0.0",
      wall_thickness: "line_width * 2",
      wipe_brush_pos_x: "100",
      wipe_hop_amount: "1",
      wipe_hop_enable: "true",
      wipe_hop_speed: "10",
      wipe_move_distance: "20",
      wipe_pause: "0",
      wipe_repeat_count: "5",
      wipe_retraction_amount: "1",
      wipe_retraction_enable: "true",
      wipe_retraction_extra_prime_amount: "0",
      wipe_retraction_prime_speed: "3",
      wipe_retraction_retract_speed: "3",
      z_seam_corner: "'z_seam_corner_weighted'",
      z_seam_type: "'back'"
    }
  end

  get "/slice" do
    %{"stl" => stl_url} = conn.query_params
    sha256 = :crypto.hash(:sha256, stl_url) |> Base.encode16(case: :lower)
    tmp_stl = Path.join(System.tmp_dir!(), "#{sha256}.stl")
    tmp_gcode = Path.join(System.tmp_dir!(), "#{sha256}.gcode")

    if not File.exists?(tmp_stl) do
      :httpc.request(:get, {stl_url, []}, [], stream: to_charlist(tmp_stl))
    end

    {out, status} =
      System.cmd(
        "CuraEngine",
        ["slice" | Enum.flat_map(slicer_args(), fn {key, val} -> ["-s", "#{key}=#{val}"] end)] ++
          ["-e0", "-l", tmp_stl, "-o", tmp_gcode],
        stderr_to_stdout: true
      )

    if status == 0 do
      send_file(conn, 200, tmp_gcode)
    else
      send_resp(conn, 500, out)
    end
  end

  match _ do
    send_resp(conn, 404, "not found")
  end
end
