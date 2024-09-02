const math = @import("std").math;

fn radians(deg: f32) f32 {
    return deg * (math.pi / 180.0);
}

pub const Vec2 = extern struct {
    x: f32,
    y: f32,

    pub fn zero() Vec2 {
        return Vec2{ .x = 0.0, .y = 0.0 };
    }

    pub fn new(x: f32, y: f32, z: f32) Vec2 {
        return Vec2{ .x = x, .y = y, .z = z };
    }

    pub fn len(v: Vec2) f32 {
        return math.sqrt(Vec2.dot(v, v));
    }

    pub fn add(left: Vec2, right: Vec2) Vec2 {
        return Vec2{ .x = left.x + right.x, .y = left.y + right.y };
    }

    pub fn sub(left: Vec2, right: Vec2) Vec2 {
        return Vec2{ .x = left.x - right.x, .y = left.y - right.y };
    }

    pub fn norm(v: Vec2) Vec2 {
        const l = Vec2.len(v);
        if (l != 0.0) {
            return Vec2{ .x = v.x / l, .y = v.y / l };
        } else {
            return Vec2.zero();
        }
    }

    pub fn dot(v0: Vec2, v1: Vec2) f32 {
        return v0.x * v1.x + v0.y * v1.y;
    }
};

fn eq(val: f32, cmp: f32) bool {
    const delta: f32 = 0.00001;
    return (val > (cmp - delta)) and (val < (cmp + delta));
}
