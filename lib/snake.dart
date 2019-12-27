import 'gamer.dart';
import 'dart:math' as math;

const BLOCK_SHAPES = {
  BlockType.I: [
    [1],
    [1],
    [1]
  ],
};

///方块初始化时的位置
const START_XY = {
  BlockType.I: [2, 2],
};

///方块变换时的中心点
const ORIGIN = {
  BlockType.I: [
    [1, 1, 1],
  ],
};

enum BlockType { I }

class Snake {
  final BlockType type;
  final List<List<int>> shape;
  final List<int> xy;
  final int rotateIndex;

  Snake(this.type, this.shape, this.xy, this.rotateIndex);

  Snake up({int step = 1}) {
    return Snake(type, shape, [xy[0], xy[1] - step], rotateIndex);
  }

  Snake down({int step = 1}) {
    return Snake(type, shape, [xy[0], xy[1] + step], rotateIndex);
  }

  Snake right({int step = 1}) {
    return Snake(type, shape, [xy[0] + step, xy[1]], rotateIndex);
  }

  Snake left({int step = 1}) {
    return Snake(type, shape, [xy[0] - step, xy[1]], rotateIndex);
  }

  Snake rotate() {
    List<List<int>> result =
        List.filled(shape[0].length, null, growable: false);
    for (int row = 0; row < shape.length; row++) {
      for (int col = 0; col < shape[row].length; col++) {
        if (result[col] == null) {
          result[col] = List.filled(shape.length, 0, growable: false);
        }
        result[col][row] = shape[shape.length - 1 - row][col];
      }
    }
    final nextXy = [
      this.xy[0] + ORIGIN[type][rotateIndex][0],
      this.xy[1] + ORIGIN[type][rotateIndex][1]
    ];
    final nextRotateIndex =
        rotateIndex + 1 >= ORIGIN[this.type].length ? 0 : rotateIndex + 1;

    return Snake(type, result, nextXy, nextRotateIndex);
  }

  bool isValidInMatrix(List<List<int>> matrix) {
    if (xy[1] + shape.length > GAME_PAD_MATRIX_H ||
        xy[1] < 0 ||
        xy[0] + shape[1].length > GAME_PAD_MATRIX_W ||
        xy[0] < 0) {
      return false;
    }
    for (var i = 0; i < matrix.length; i++) {
      final line = matrix[i];
      for (var j = 0; j < line.length; j++) {
        if (line[j] == 1 && get(j, i) == 1) {
          return false;
        }
      }
    }
    return true;
  }

  ///return null if do not show at [x][y]
  ///return 1 if show at [x,y]
  int get(int x, int y) {
    x -= xy[0];
    y -= xy[1];
    if (x < 0 || x >= shape[0].length || y < 0 || y >= shape.length) {
      return null;
    }
    return shape[y][x] == 1 ? 1 : null;
  }

  static Snake fromType(BlockType type) {
    final shape = BLOCK_SHAPES[type];
    return Snake(type, shape, START_XY[type], 0);
  }

  static Snake getRandom() {
    final i = math.Random().nextInt(BlockType.values.length);
    return fromType(BlockType.values[i]);
  }
}
