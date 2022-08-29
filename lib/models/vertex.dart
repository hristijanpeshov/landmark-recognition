import 'package:json_annotation/json_annotation.dart';
part 'vertex.g.dart';


@JsonSerializable()
class Vertex {
  int x;
  int y;

  Vertex(this.x, this.y);
  factory Vertex.fromJson(Map<String, dynamic> json) => _$VertexFromJson(json);
}