import 'package:barcollector_sdk/types/register/data/system_table_model.dart';

enum CollectionReasionColumns {
  id('tab_cod'),
  description('tab_desc'),
  displayTurnover('tab_exibegiro');

  final String tableName;
  const CollectionReasionColumns(this.tableName);
}

class CollectionReason implements SystemTableModel {
  @override
  final int id;
  @override
  final String description;

  final bool displayTurnover;

  CollectionReason({
    required this.id,
    required this.description,
    required this.displayTurnover,
  });

  /// [map] pode ser o resultado da consulta no banco ou um json
  factory CollectionReason.fromMap(Map<String, dynamic> map) {
    final map_displayTurnover = map['displayTurnover'];
    return CollectionReason(
      id: map['id'] as int,
      description: map['descricao'] as String,
      displayTurnover: map_displayTurnover is bool ? map_displayTurnover : map_displayTurnover == 1,
    );
  }

  /// Retorna um [Map] json
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'descricao': description,
      'displayTurnover': displayTurnover,
    };
  }
}
