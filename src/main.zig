//------------------------------------------------------------------------------
//  triangle.zig
//
//  Vertex buffer, shader, pipeline state object.
//------------------------------------------------------------------------------
const sokol = @import("sokol");
const slog = sokol.log;
const sg = sokol.gfx;
const sapp = sokol.app;
const sglue = sokol.glue;
const shd = @import("shaders/triangle.glsl.zig");

const state = struct {
    var bind: sg.Bindings = .{};
    var pip: sg.Pipeline = .{};
};

export fn init() void {
    sg.setup(.{
        .environment = sglue.environment(),
        .logger = .{ .func = slog.func },
    });

    // create vertex buffer with triangle vertices
    state.bind.vertex_buffers[0] = sg.makeBuffer(.{
        .data = sg.asRange(&[_]f32{
            // positions(3)      colors(4)
            // left leg
            0.0,   0.1,  0.0, 1.0, 0.0, 0.0, 1.0,
            0.05,  -0.4, 0.0, 0.0, 1.0, 0.0, 1.0,
            -0.05, -0.4, 0.0, 0.0, 0.0, 1.0, 1.0,
            // right leg
            0.15,  0.1,  0.0, 1.0, 0.0, 0.0, 1.0,
            0.2,   -0.4, 0.0, 0.0, 1.0, 0.0, 1.0,
            0.1,   -0.4, 0.0, 0.0, 0.0, 1.0, 1.0,
            // torso
            -0.15, 0.4,  0.0, 0.0, 0.0, 1.0, 1.0,
            0.3,   0.4,  0.0, 0.0, 1.0, 0.0, 1.0,
            0.075, -0.1, 0.0, 1.0, 0.0, 0.0, 1.0,
            // head
            -0.1,  0.55, 0.0, 0.0, 0.0, 1.0, 1.0,
            0.25,  0.55, 0.0, 0.0, 1.0, 0.0, 1.0,
            0.075, 0.4,  0.0, 1.0, 0.0, 0.0, 1.0,
        }),
    });

    // create a shader and pipeline object
    var pip_desc: sg.PipelineDesc = .{
        .shader = sg.makeShader(shd.triangleShaderDesc(sg.queryBackend())),
    };
    pip_desc.layout.attrs[0].format = .FLOAT3;
    pip_desc.layout.attrs[1].format = .FLOAT4;
    state.pip = sg.makePipeline(pip_desc);
}

export fn frame() void {
    // default pass-action clears to grey
    sg.beginPass(.{ .swapchain = sglue.swapchain() });
    sg.applyPipeline(state.pip);
    sg.applyBindings(state.bind);
    sg.draw(0, 12, 1);
    sg.endPass();
    sg.commit();
}

export fn cleanup() void {
    sg.shutdown();
}

pub fn main() void {
    sapp.run(.{
        .init_cb = init,
        .frame_cb = frame,
        .cleanup_cb = cleanup,
        .width = 640,
        .height = 480,
        .icon = .{ .sokol_default = true },
        .window_title = "triangle.zig",
        .logger = .{ .func = slog.func },
    });
}
