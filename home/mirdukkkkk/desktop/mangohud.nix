{
    programs.mangohud = {
        enable = true;
        settings = {
            full = false;
            position = "top-left";
            offset_x = 10;
            offset_y = 10;
            font_size = 24;
            background_alpha = 0.2;
            alpha = 0.9;

            fps = true;
            fps_only = false;
            frametime = true;
            frame_timing = true;

            cpu_stats = true;
            gpu_stats = true;
            cpu_temp = true;
            gpu_temp = true;

            cpu_power = true;
            gpu_power = true;
            cpu_mhz = true;
            gpu_core_clock = true;

            cpu_load_change = true;
            gpu_load_change = true;

            ram = true;
            vram = true;

            refresh_rate = true;
            vulkan_driver = true;
            gl_vsync = 0;
            vsync = 0;

            log_duration = false;

            wine = true;
            winesync = true;
            gamemode = true;

            fps_limit = 0;
        };
    };
}
