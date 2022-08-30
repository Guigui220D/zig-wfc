const std = @import("std");
const mibu = @import("mibu");

var rand: std.rand.DefaultPrng = undefined;
var random: std.rand.Random = undefined;

const Directions = u4;
const DirRight: Directions = 1;
const DirDown: Directions = 2;
const DirLeft: Directions = 4;
const DirUp: Directions = 8;
const AllDirs = DirRight | DirDown | DirLeft | DirUp;

const Tile = struct {
    const IdT = u5;
    const Count = 3;

    var list: [Count]Tile = .{ 
        Tile{ .id = 0, .char = '@', .color = .blue },
        Tile{ .id = 1, .char = '*', .color = .red },
        Tile{ .id = 2, .char = '%', .color = .green }
    };

    pub fn accept(a: *Tile, b: *Tile, dirs: Directions) void {
        if ((dirs & DirRight) != 0) {
            a.accepts.right |= @as(u32, 1) << b.id;
            b.accepts.left |= @as(u32, 1) << a.id;
        }
        if ((dirs & DirDown) != 0) {
            a.accepts.down |= @as(u32, 1) << b.id;
            b.accepts.up |= @as(u32, 1) << a.id;
        }
        if ((dirs & DirLeft) != 0) {
            a.accepts.left |= @as(u32, 1) << b.id;
            b.accepts.right |= @as(u32, 1) << a.id;
        }
        if ((dirs & DirUp) != 0) {
            a.accepts.up |= @as(u32, 1) << b.id;
            b.accepts.down |= @as(u32, 1) << a.id;
        }
    }

    pub fn initAll() void {
        list[0].accept(&list[1], AllDirs);
        list[0].accept(&list[0], AllDirs);
        list[1].accept(&list[2], AllDirs);
        list[1].accept(&list[1], AllDirs);
        list[2].accept(&list[2], AllDirs);
    }

    id: IdT,
    char: u8,
    color: mibu.color.Color,
    accepts: struct {
        right: u32 = 0,
        down: u32 = 0,
        left: u32 = 0,
        up: u32 = 0,
    } = .{},
};

pub fn filter(tile: u32, other: *u32, comptime dir: Directions) bool {
    var mask: u32 = 0;
    var a = tile;
    var tid: u5 = 0;
    
    while (a != 0) : ({a >>= 1; tid += 1;}) {
        if (a & 1 != 1)
            continue;
        
        switch (dir) {
            DirRight => mask |= Tile.list[tid].accepts.right,
            DirDown => mask |= Tile.list[tid].accepts.down,
            DirLeft => mask |= Tile.list[tid].accepts.left,
            DirUp =>  mask |= Tile.list[tid].accepts.up,
            else => unreachable
        }
    }

    const ret = other.* & mask;
    const changed = (ret != other.*);

    other.* = ret;

    return changed;
}

const Grid = struct {
    const Size = 12;
    
    pub fn print(self: Grid, writer: anytype) !void {
        var x: usize = 0;
        try writer.writeByte('\n');
        while (x < Size) : (x += 1) {
            var y: usize = 0;
            try writer.writeByte(' ');
            while (y < Size) : (y += 1) {
                const possibilities = self.data[x][y];
                const how_many = @popCount(u32, possibilities);
                switch (how_many) {
                    0 => {
                        try mibu.color.fg256(writer, .default);
                        try writer.writeByte('!');
                        //try writer.writeByte(' ');
                    },
                    1 => {
                        const id: u5 = @truncate(u5, @ctz(u32, possibilities));
                        const tile = Tile.list[id];
                        try mibu.color.fg256(writer, tile.color);
                        try writer.writeByte(tile.char);
                        //try writer.writeByte(' ');
                    },
                    else => {
                        try mibu.color.fg256(writer, .default);
                        try writer.print("{}", .{how_many});
                        //try writer.writeByte('?');
                        //try writer.writeByte(' ');
                    }
                }
            }
            try writer.writeByte('\n');
        }
    }

    pub fn updateNeighbors(self: *Grid, x: usize, y: usize) void {
        const tile = self.data[x][y];
        // Update on the left
        if (x > 0) {
            if (filter(tile, &self.data[x - 1][y], DirLeft))
                updateNeighbors(self, x - 1, y);
        }
        // Update on the top
        if (y > 0) {
            if (filter(tile, &self.data[x][y - 1], DirUp))
                updateNeighbors(self, x, y - 1);
        }
        // Update on the right
        if (x < Size - 1) {
            if (filter(tile, &self.data[x + 1][y], DirRight))
                updateNeighbors(self, x + 1, y);
        }
        // Update on the bottom
        if (y < Size - 1) {
            if (filter(tile, &self.data[x][y + 1], DirDown))
                updateNeighbors(self, x, y + 1);
        }
    }

    pub fn forceCellValue(self: *Grid, x: usize, y: usize, id: u5) !void {
        const mask = @as(u32, 1) << id;
        if ((self.data[x][y] & mask) == 0)
            return error.notPossible;
        self.data[x][y] = mask;
        updateNeighbors(self, x, y);
    }

    pub fn init() !Grid {
        var ret: Grid = undefined;
        var x: usize = 0;
        while (x < Size) : (x += 1) {
            var y: usize = 0;
            while (y < Size) : (y += 1) {
                //ret.data[x][y] = @as(u32, 1) << @truncate(u5, (x + y) % Tile.Count);
                ret.data[x][y] = 0b111; // TODO: get that from tile list
            }
        }
        return ret;
    }

    pub fn setOneRandomly(self: *Grid) !bool {
        var x: usize = 0;
        var min_choices: u6 = 33;
        var candidates = try std.BoundedArray(Coord, Size * Size).init(0);
        while (x < Size) : (x += 1) {
            var y: usize = 0;
            while (y < Size) : (y += 1) {
                var possibilities = @popCount(u32, self.data[x][y]);
                if (possibilities <= 1)
                    continue;
                if (possibilities > min_choices)
                    continue;
                if (possibilities < min_choices) {
                    min_choices = possibilities;
                    try candidates.resize(0);
                }
                try candidates.append(Coord{ .x = x, .y = y });
            }
        }
        if (min_choices == 33)
            return false; // Grid is clear

        std.debug.assert(candidates.len != 0);
        
        var choice_coord = candidates.buffer[random.intRangeLessThan(usize, 0, candidates.len)];
        var actual_choice = random.intRangeLessThan(u5, 0, @truncate(u5, min_choices));
        var a = self.data[choice_coord.x][choice_coord.y];

        var pid: u5 = 0;
        var pi: u5 = 0;
    
        while (a != 0) : ({a >>= 1; pid += 1;}) {
            if (a & 1 != 1)
                continue;
            if (pi == actual_choice)
                break;
            pi += 1;
        }

        try self.forceCellValue(choice_coord.x, choice_coord.y, pid);

        return true;
    }

    data: [Size][Size]u32,
};

const Coord = struct {
    x: usize,
    y: usize
};

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    var buffered_writer = std.io.bufferedWriter(stdout);
    const writer = buffered_writer.writer();

    rand = std.rand.DefaultPrng.init(@intCast(u64, std.time.milliTimestamp()));
    random = rand.random();

    Tile.initAll();

    var grid = try Grid.init();

    try grid.print(writer);
    try buffered_writer.flush();

    while (try grid.setOneRandomly()) {
        std.time.sleep(100_000_000);
        try grid.print(writer);
        try buffered_writer.flush();
    }
}
