[![CI](https://github.com/abus-sh/egui-sdl3/actions/workflows/ci.yml/badge.svg)](https://github.com/abus-sh/egui-sdl3/actions)
[![Documentation](https://docs.rs/egui-sdl3/badge.svg)](https://docs.rs/egui-sdl3)
[![Dependencies](https://deps.rs/repo/github/abus-sh/egui-sdl3/status.svg)](https://deps.rs/repo/github/abus-sh/egui-sdl3)
[![crates.io](https://img.shields.io/crates/v/egui-sdl3.svg)](https://crates.io/crates/egui-sdl3)
[![Downloads](https://img.shields.io/crates/d/egui-sdl3)](https://crates.io/crates/egui-sdl3)
<!--![MIT](https://img.shields.io/badge/license-MIT-blue.svg)
![Apache](https://img.shields.io/badge/license-Apache-blue.svg) -->

# egui-sdl3

This crate provides integration between [`egui`](https://github.com/emilk/egui) and [`sdl3`](https://github.com/vhspace/sdl3-rs), including event handling and multiple rendering backends with a consistent API. It supports optional rendering backends:

- Software via [`Canvas`](https://docs.rs/sdl3/latest/sdl3/render/struct.Canvas.html) (`canvas-backend` feature)
- OpengGL via [`glow`](https://crates.io/crates/glow) (`glow-backend` feature)
- WebgGPU via [`wgpu`](https://github.com/gfx-rs/wgpu) (`wgpu-backend` feature)

The implementation is based on the design of the official egui-winit, egui_glow, egui-wgpu crates, aming to make it easy to use SDL3 with egui.

Both `egui` and `sdl3` are re-exported for convenience. The `sdl3` re-export includes all feature flags available to use.

## Usage

```rust
// Create SDL3 window:
let sdl = sdl3::init().unwrap();
let video = sdl.video().unwrap();
let window = video.window("Egui SDL3 Canvas", 800, 600).build().unwrap();
// Create egui renderer:
let mut egui = egui_sdl3::EguiCanvas::new(window);
let mut event_pump = sdl.event_pump().unwrap();
loop {
    // Feed SDL3 events into egui:
    for event in event_pump.poll_iter() {
        egui.on_event(&event);
    }
    // Call `run` + `paint` each frame:
    egui.run(|ctx: &egui::Context| {});
    egui.paint();
    egui.present();
    std::thread::sleep(std::time::Duration::from_secs_f64(1.0 / 60.0));
}
```

To get started, create an [`EguiGlow`](https://docs.rs/egui-sdl3/latest/egui_sdl3/glow/index.html) or [`EguiCanvas`](https://docs.rs/egui-sdl3/latest/egui_sdl3/canvas/index.html) or [`EguiWgpu`](https://docs.rs/egui-sdl3/latest/egui_sdl3/wgpu/index.html) instance to manage rendering. Pass SDL3 events to `on_event`, then call `run` and `paint` each frame. For event handling only, you can use the [`State`](https://docs.rs/egui-sdl3/latest/egui_sdl3/state/index.html) type.
Examples are available in the [examples/](https://github.com/abus-sh/egui-sdl3/tree/main/examples/) directory. To run the `canvas` example:

```sh
cargo run --example canvas
```
