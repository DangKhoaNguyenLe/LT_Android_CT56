import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:io';
import 'package:path/path.dart';

void main() async {
  sqfliteFfiInit();
  var databaseFactory = databaseFactoryFfi;
  
  // Assuming standard sqflite windows path:
  // Usually Documents or AppData. But sqflite ffi uses Documents by default?
  // Let's print the default path
  String defaultPath = await databaseFactory.getDatabasesPath();
  String path = join(defaultPath, 'khao_sat.db');
  
  print("DB Path: \$path");
  
  if (await File(path).exists()) {
    var db = await databaseFactory.openDatabase(path);
    
    var lichSus = await db.query('LichSuKhaoSat');
    print("=== LICH SU KHAO SAT ===");
    for (var row in lichSus) {
      print(row);
    }
    
    var chiTiets = await db.query('ChiTietLichSuKhaoSat');
    print("=== CHI TIET LICH SU ===");
    for (var row in chiTiets) {
      print(row);
    }
    
    var cauHois = await db.query('CauHoi');
    print("=== CAU HOI ===");
    for (var row in cauHois) {
      print(row);
    }

    var dapAns = await db.query('DapAn');
    print("=== DAP AN ===");
    for (var row in dapAns) {
      print(row);
    }
    
    db.close();
  } else {
    print("File DB ko ton tai.");
  }
}
