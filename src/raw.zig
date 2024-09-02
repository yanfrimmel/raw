const std = @import("std");
const sokol = @import("sokol");
const slog = sokol.log;
const sg = sokol.gfx;
const sapp = sokol.app;
const sglue = sokol.glue;
const shd = @import("shaders/quad.glsl.zig");

const state = struct {
    var bind: sg.Bindings = .{};
    var pip: sg.Pipeline = .{};
    var pass_action: sg.PassAction = .{};
    var index_count: u16 = 0;
};

export fn init() void {
    sg.setup(.{
        .environment = sglue.environment(),
        .logger = .{ .func = slog.func },
    });

    const circle_vertex_count = 40;
    const radius = 0.7;
    const center_x = 0.0;
    const center_y = 0.0;

    const attrs_count = 7;
    var triangle_vertexes = std.mem.zeroes([circle_vertex_count * attrs_count]f32);
    const angle_diff: f32 = 1 / @as(f32, @floatFromInt(circle_vertex_count));

    for (0..circle_vertex_count) |i| {
        const pi = @as(f32, @floatCast(std.math.pi));
        const angle = @as(f32, @floatFromInt(i)) * angle_diff * 2 * pi;
        const x = radius * @cos(angle) + center_x;
        const y = radius * @sin(angle) + center_y;

        const si = i * attrs_count;
        triangle_vertexes[si + 0] = x;
        triangle_vertexes[si + 1] = y;
        triangle_vertexes[si + 2] = 0.5;

        triangle_vertexes[si + 3] = 1;
        triangle_vertexes[si + 4] = 0;
        triangle_vertexes[si + 5] = 0.5;
    }

    // a vertex buffer
    state.bind.vertex_buffers[0] = sg.makeBuffer(.{
        .data = sg.asRange(&triangle_vertexes),
    });

    const triangle_count = circle_vertex_count - 2;

    var index_buffer: [triangle_count * 3]u16 = undefined;

    for (0..triangle_count) |tri| {
        const triCast: u16 = @intCast(tri);
        index_buffer[tri * 3 + 0] = 0;
        index_buffer[tri * 3 + 1] = triCast + 1;
        index_buffer[tri * 3 + 2] = triCast + 2;
    }

    state.index_count = index_buffer.len;

    // an index buffer
    state.bind.index_buffer = sg.makeBuffer(.{
        .type = .INDEXBUFFER,
        .data = sg.asRange(&index_buffer),
    });

    // a shader and pipeline state object
    var pip_desc: sg.PipelineDesc = .{
        .index_type = .UINT16,
        .shader = sg.makeShader(shd.quadShaderDesc(sg.queryBackend())),
    };
    pip_desc.layout.attrs[shd.ATTR_vs_position].format = .FLOAT3;
    pip_desc.layout.attrs[shd.ATTR_vs_color0].format = .FLOAT4;
    state.pip = sg.makePipeline(pip_desc);

    // clear to black
    state.pass_action.colors[0] = .{
        .load_action = .CLEAR,
        .clear_value = .{ .r = 255, .g = 255, .b = 255, .a = 1 },
    };
}

export fn frame() void {
    sg.beginPass(.{ .action = state.pass_action, .swapchain = sglue.swapchain() });
    sg.applyPipeline(state.pip);
    sg.applyBindings(state.bind);
    sg.draw(0, state.index_count, 1);
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
        .width = 500,
        .height = 500,
        .icon = .{ .sokol_default = true },
        .window_title = "quad.zig",
        .logger = .{ .func = slog.func },
    });
}
