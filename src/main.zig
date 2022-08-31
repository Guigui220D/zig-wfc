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

/// Tile struct
const Tile = struct {
    const IdT = u5;
    const Count = 29;

    /// List of all tiles
    /// There cannot be more than 32 because the bitfields are u32
    var list: [Count]Tile = .{ 
        Tile{ .id = 0,  .char = '═', .color = .blue },
        Tile{ .id = 1,  .char = '║', .color = .blue },
        Tile{ .id = 2,  .char = '╒', .color = .blue },
        Tile{ .id = 3,  .char = '╓', .color = .blue },
        Tile{ .id = 4,  .char = '╔', .color = .blue },
        Tile{ .id = 5,  .char = '╕', .color = .blue },
        Tile{ .id = 6,  .char = '╖', .color = .blue },
        Tile{ .id = 7,  .char = '╗', .color = .blue },
        Tile{ .id = 8,  .char = '╘', .color = .blue },
        Tile{ .id = 9,  .char = '╙', .color = .blue },
        Tile{ .id = 10, .char = '╚', .color = .blue },
        Tile{ .id = 11, .char = '╛', .color = .blue },
        Tile{ .id = 12, .char = '╜', .color = .blue },
        Tile{ .id = 13, .char = '╝', .color = .blue },
        Tile{ .id = 14, .char = '╞', .color = .blue },
        Tile{ .id = 15, .char = '╟', .color = .blue },
        Tile{ .id = 16, .char = '╠', .color = .blue },
        Tile{ .id = 17, .char = '╡', .color = .blue },
        Tile{ .id = 18, .char = '╢', .color = .blue },
        Tile{ .id = 19, .char = '╣', .color = .blue },
        Tile{ .id = 20, .char = '╤', .color = .blue },
        Tile{ .id = 21, .char = '╥', .color = .blue },
        Tile{ .id = 22, .char = '╦', .color = .blue },
        Tile{ .id = 23, .char = '╧', .color = .blue },
        Tile{ .id = 24, .char = '╨', .color = .blue },
        Tile{ .id = 25, .char = '╩', .color = .blue },
        Tile{ .id = 26, .char = '╪', .color = .blue },
        Tile{ .id = 27, .char = '╫', .color = .blue },
        Tile{ .id = 28, .char = '╬', .color = .blue },
    };

    /// Inits the compatibilities of all tiles
    pub fn initAll() void {
        { // 28
            list[28].accept(&list[28], DirUp);

            list[28].accept(&list[28], DirLeft);
        }

        { // 25
            list[25].accept(&list[28], DirUp);

            list[25].accept(&list[25], DirLeft);
            list[25].accept(&list[28], DirLeft);

            list[25].accept(&list[25], DirRight);
            list[25].accept(&list[28], DirRight);
        }

        { // 22
            list[22].accept(&list[25], DirDown);
            list[22].accept(&list[28], DirDown);

            list[22].accept(&list[25], DirUp);

            list[22].accept(&list[22], DirLeft);
            list[22].accept(&list[25], DirLeft);
            list[22].accept(&list[28], DirLeft);

            list[22].accept(&list[22], DirRight);
            list[22].accept(&list[25], DirRight);
            list[22].accept(&list[28], DirRight);
        }

        { // 19
            list[19].accept(&list[25], DirDown);
            list[19].accept(&list[28], DirDown);

            list[19].accept(&list[19], DirUp);
            list[19].accept(&list[28], DirUp);

            list[19].accept(&list[20], DirLeft);
            list[19].accept(&list[22], DirLeft);
            list[19].accept(&list[25], DirLeft);
            list[19].accept(&list[28], DirLeft);
        }

        { // 16
            list[16].accept(&list[25], DirDown);
            list[16].accept(&list[28], DirDown);

            list[16].accept(&list[16], DirUp);
            list[16].accept(&list[19], DirUp);
            list[16].accept(&list[28], DirUp);

            list[16].accept(&list[19], DirLeft);

            list[16].accept(&list[19], DirRight);
            list[16].accept(&list[20], DirRight);
            list[16].accept(&list[22], DirRight);
            list[16].accept(&list[25], DirRight);
            list[16].accept(&list[28], DirRight);
        }

        { // 13
            list[13].accept(&list[22], DirDown);

            list[13].accept(&list[16], DirUp);
            list[13].accept(&list[19], DirUp);
            list[13].accept(&list[28], DirUp);

            list[13].accept(&list[20], DirLeft);
            list[13].accept(&list[22], DirLeft);
            list[13].accept(&list[25], DirLeft);
            list[13].accept(&list[28], DirLeft);

            list[13].accept(&list[16], DirRight);
        }

        { // 10
            list[10].accept(&list[22], DirDown);

            list[10].accept(&list[16], DirUp);
            list[10].accept(&list[19], DirUp);
            list[10].accept(&list[28], DirUp);

            list[10].accept(&list[13], DirLeft);
            list[10].accept(&list[19], DirLeft);

            list[10].accept(&list[13], DirRight);
            list[10].accept(&list[19], DirRight);
            list[10].accept(&list[20], DirRight);
            list[10].accept(&list[22], DirRight);
            list[10].accept(&list[25], DirRight);
            list[10].accept(&list[28], DirRight);
        }

        { // 7
            list[7].accept(&list[10], DirDown);
            list[7].accept(&list[13], DirDown);
            list[7].accept(&list[16], DirDown);
            list[7].accept(&list[25], DirDown);
            list[7].accept(&list[28], DirDown);

            list[7].accept(&list[10], DirUp);
            list[7].accept(&list[13], DirUp);
            list[7].accept(&list[25], DirUp);

            list[7].accept(&list[10], DirLeft);
            list[7].accept(&list[20], DirLeft);
            list[7].accept(&list[22], DirLeft);
            list[7].accept(&list[25], DirLeft);
            list[7].accept(&list[28], DirLeft);

            list[7].accept(&list[4], DirRight);
            list[7].accept(&list[10], DirRight);
            list[7].accept(&list[16], DirRight);
        }

        { // 4
            list[4].accept(&list[10], DirDown);
            list[4].accept(&list[13], DirDown);
            list[4].accept(&list[16], DirDown);
            list[4].accept(&list[25], DirDown);
            list[4].accept(&list[28], DirDown);

            list[4].accept(&list[10], DirUp);
            list[4].accept(&list[13], DirUp);
            list[4].accept(&list[25], DirUp);

            list[4].accept(&list[7], DirLeft);
            list[4].accept(&list[13], DirLeft);
            list[4].accept(&list[19], DirLeft);

            list[4].accept(&list[7], DirRight);
            list[4].accept(&list[13], DirRight);
            list[4].accept(&list[19], DirRight);
            list[4].accept(&list[20], DirRight);
            list[4].accept(&list[22], DirRight);
            list[4].accept(&list[25], DirRight);
            list[4].accept(&list[28], DirRight);
        }

        { // 1
            list[1].accept(&list[1], DirDown);
            list[1].accept(&list[10], DirDown);
            list[1].accept(&list[13], DirDown);
            list[1].accept(&list[16], DirDown);
            list[1].accept(&list[25], DirDown);
            list[1].accept(&list[28], DirDown);

            list[1].accept(&list[4], DirUp);
            list[1].accept(&list[7], DirUp);
            list[1].accept(&list[16], DirUp);
            list[1].accept(&list[19], DirUp);
            list[1].accept(&list[28], DirUp);
            
            list[1].accept(&list[1], DirLeft);
            list[1].accept(&list[7], DirLeft);
            list[1].accept(&list[13], DirLeft);
            list[1].accept(&list[19], DirLeft);

            list[1].accept(&list[4], DirRight);
            list[1].accept(&list[10], DirRight);
            list[1].accept(&list[16], DirRight);
        }

        { // 0
            list[0].accept(&list[0], DirDown);
            list[0].accept(&list[6], DirDown);
            list[0].accept(&list[7], DirDown);
            list[0].accept(&list[22], DirDown);

            list[0].accept(&list[10], DirUp);
            list[0].accept(&list[13], DirUp);
            list[0].accept(&list[25], DirUp);

            list[0].accept(&list[10], DirLeft);
            list[0].accept(&list[20], DirLeft);
            list[0].accept(&list[22], DirLeft);
            list[0].accept(&list[25], DirLeft);
            list[0].accept(&list[28], DirLeft);

            list[0].accept(&list[0], DirRight);
            list[0].accept(&list[7], DirRight);
            list[0].accept(&list[13], DirRight);
            list[0].accept(&list[19], DirRight);
            list[0].accept(&list[20], DirRight);
            list[0].accept(&list[22], DirRight);
            list[0].accept(&list[25], DirRight);
            list[0].accept(&list[28], DirRight);
        }
    }

    /// Creates a compatibility between two tiles
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

    /// ID of the tile
    id: IdT,
    /// Char for rendering the tile in a terminal
    char: u21,
    /// Color in the terminal
    color: mibu.color.Color,
    /// Bitfields for what can be next to it
    accepts: struct {
        right: u32 = 0,
        down: u32 = 0,
        left: u32 = 0,
        up: u32 = 0,
    } = .{},
};

/// reduces the possibilities of an other tile based on the possibilities of "tile" 
// and what they are compatible with in the given direction
pub fn filter(tile: u32, other: *u32, comptime dir: Directions) !bool {
    var mask: u32 = 0;
    var a = tile;
    var tid: u5 = 0;
    // Iterate through the bitfield of "tile"
    while (a != 0) : ({a >>= 1; tid += 1;}) {
        if (a & 1 != 1)
            continue; 
        // add the compatibilities of the possibility in the mask
        switch (dir) {
            DirRight => mask |= Tile.list[tid].accepts.right,
            DirDown => mask |= Tile.list[tid].accepts.down,
            DirLeft => mask |= Tile.list[tid].accepts.left,
            DirUp =>  mask |= Tile.list[tid].accepts.up,
            else => unreachable
        }
    }
    // mask what is possible
    const ret = other.* & mask;
    const changed = (ret != other.*);
    // no possibility left
    if (ret == 0)
        return error.notPossible;

    other.* = ret;
    // return whether or not the possibilities have changed
    return changed;
}

/// A grid of tiles
const Grid = struct {
    const Size = 16;
    
    /// print the grid to a writer, like stdout
    pub fn print(self: Grid, writer: anytype) !void {
        var x: usize = 0;
        try writer.writeByte('\n');
        while (x < Size) : (x += 1) {
            var y: usize = 0;
            try writer.writeByte(' ');
            while (y < Size) : (y += 1) {
                const possibilities = self.data[y][x];
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
                        try writer.print("{u}", .{tile.char});
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

    /// update the neigbors of a tile
    pub fn updateNeighbors(self: *Grid, x: usize, y: usize) anyerror!void {
        const tile = self.data[x][y];
        // Update on the left
        if (x > 0) {
            if (try filter(tile, &self.data[x - 1][y], DirLeft))
                try updateNeighbors(self, x - 1, y);
        }
        // Update on the top
        if (y > 0) {
            if (try filter(tile, &self.data[x][y - 1], DirUp))
                try updateNeighbors(self, x, y - 1);
        }
        // Update on the right
        if (x < Size - 1) {
            if (try filter(tile, &self.data[x + 1][y], DirRight))
                try updateNeighbors(self, x + 1, y);
        }
        // Update on the bottom
        if (y < Size - 1) {
            if (try filter(tile, &self.data[x][y + 1], DirDown))
                try updateNeighbors(self, x, y + 1);
        }
    }

    /// forces a tile to be "id" and only "id" (updates neighbors)
    /// updating is recursive, so a single cell may affect the whole grid
    pub fn forceCellValue(self: *Grid, x: usize, y: usize, id: u5) !void {
        const mask = @as(u32, 1) << id;
        if ((self.data[x][y] & mask) == 0)
            return error.notPossible;
        self.data[x][y] = mask;
        try updateNeighbors(self, x, y);
    }

    /// inits a grid with every possibility everywhere
    pub fn init() !Grid {
        var ret: Grid = undefined;
        var x: usize = 0;
        while (x < Size) : (x += 1) {
            var y: usize = 0;
            while (y < Size) : (y += 1) {
                //ret.data[x][y] = @as(u32, 1) << @truncate(u5, (x + y) % Tile.Count);
                ret.data[x][y] = 0b11111111111111111111111111111; // TODO: get that from tile list
            }
        }
        return ret;
    }

    /// chooses a tile randomly amongst the ones with the least entropy, and chooses a possibility randomly for that tile
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

    //try grid.forceCellValue(5, 5, 28);

    var i: usize = 0;
    while (i < Grid.Size) : (i += 1) {
        try grid.forceCellValue(8, i, 1);
    }

    try grid.print(writer);
    try buffered_writer.flush();

    while (try grid.setOneRandomly()) {
        //std.time.sleep(100_000_000);
        
    }

    try grid.print(writer);
    try buffered_writer.flush();
}
