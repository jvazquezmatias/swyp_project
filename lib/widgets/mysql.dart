import 'package:project/model/user.dart';
import 'dart:async';
import 'package:mysql1/mysql1.dart';
import 'package:project/model/my_marker.dart';
import 'package:project/ui/pages/map_page.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

const parkingDiaNoche = "parkingDiaNoche";
const parkingSoloDia = "parkingDia";
const rodeadoNaturaleza = "naturaleza";
const areaDeServicio = "areaDeServicio";
const solucionDeProblemas = "solucionProblemas";
const areaAutocaravanasPublica = "autocaravanaPublicaGratis";
const zonaPicnic = "zonaPicnic";
List<String> filtrosActivos;
List<String> favoritesUser = new List<String>();
User user;
String name = "";
String surname = "";
String surname2 = "";
String username = "";
String password = "";
String email = "";
bool connection = false;

Future<String> query(var query) async {
  name = "";
  surname = "";
  surname2 = "";
  username = "";
  password = "";
  email = "";
  // Open a connection (testdb should already exist) javi123456_
  final conn = await MySqlConnection.connect(new ConnectionSettings(
      host: 'labs.iam.cat',
      port: 3306,
      user: 'a17pabsanrod_adm',
      password: 'pablo1234',
      db: 'a17pabsanrod_projectefinal'));

  // Query the database using a parameterized query
  var results = await conn.query(query);
  for (var row in results) {
    name = row[0];
    surname = row[1];
    surname2 = row[2];
    username = row[3];
    email = row[4];
    password = row[5];
    connection = true;
  }
  user = new User(
      name: name,
      surname: surname,
      surname2: surname2,
      username: username,
      password: password,
      email: email);
  // Finally, close the connection
  await conn.close();
}

Future<String> queryChangePassword(var query) async {
  // Open a connection (testdb should already exist) javi123456_
  final conn = await MySqlConnection.connect(new ConnectionSettings(
      host: 'labs.iam.cat',
      port: 3306,
      user: 'a17pabsanrod_adm',
      password: 'pablo1234',
      db: 'a17pabsanrod_projectefinal'));

  // Query the database using a parameterized query
  await conn.query(query);

  // Finally, close the connection
  await conn.close();
}

Future<String> queryDownloadMarkers() async {
  MapUiPage.listMarkers.clear();
  String id = "";
  double latitud = 0;
  double longitud = 0;
  String icono = "";
  String titulo = "";
  String descripcion = "";
  int estrellas = 0;
  String imagen = "";

  // Open a connection (testdb should already exist) javi123456_
  final conn = await MySqlConnection.connect(new ConnectionSettings(
      host: 'labs.iam.cat',
      port: 3306,
      user: 'a17pabsanrod_adm',
      password: 'pablo1234',
      db: 'a17pabsanrod_projectefinal'));

  // Query the database using a parameterized query
  var results = await conn
      .query("SELECT * FROM MARKERS m JOIN MARKERS_INFO i ON m.ID=i.ID");
  for (var row in results) {
    id = row[0];
    latitud = row[1];
    longitud = row[2];
    icono = row[3];
    titulo = row[5];
    descripcion = row[6];
    estrellas = row[7];
    MyMarker marker = new MyMarker(
        id: id,
        latitud: latitud,
        longitud: longitud,
        icono: icono,
        titulo: titulo,
        descripcion: descripcion,
        estrellas: estrellas);
    MapUiPage.listMarkers.add(marker);
  }
  // Finally, close the connection
  await conn.close();
}

Future<String> queryDownloadMarkersAndFilter() async {
  filtrosActivos = MapPage.filtrosActivos;
  String condicion = "";
  int i = 1;
  filtrosActivos.forEach((filtro) {
    if (filtrosActivos.length == i) {
      condicion = condicion + "m.ICONO = '" + filtro + "'";
    } else {
      condicion = condicion + "m.ICONO = '" + filtro + "' OR ";
      i++;
    }
  });

  String id = "";
  double latitud = 0;
  double longitud = 0;
  String icono = "";
  String titulo = "";
  String descripcion = "";
  int estrellas = 0;
  String imagen = "";

  // Open a connection (testdb should already exist) javi123456_
  final conn = await MySqlConnection.connect(new ConnectionSettings(
      host: 'labs.iam.cat',
      port: 3306,
      user: 'a17pabsanrod_adm',
      password: 'pablo1234',
      db: 'a17pabsanrod_projectefinal'));

  var results;
  // Query the database using a parameterized query´
  if (condicion == "") {
    results = await conn.query(
        "SELECT * FROM MARKERS m JOIN MARKERS_INFO i ON m.ID=i.ID where m.ID='XDDD'");
  } else {
    results = await conn.query(
        "SELECT * FROM MARKERS m JOIN MARKERS_INFO i ON m.ID=i.ID WHERE " +
            condicion);
  }

  for (var row in results) {
    id = row[0];
    latitud = row[1];
    longitud = row[2];
    icono = row[3];
    titulo = row[5];
    descripcion = row[6];
    estrellas = row[7];
    MyMarker marker = new MyMarker(
        id: id,
        latitud: latitud,
        longitud: longitud,
        icono: icono,
        titulo: titulo,
        descripcion: descripcion,
        estrellas: estrellas);
    MapUiPage.listMarkers.add(marker);
  }
  // Finally, close the connection
  await conn.close();
}

Future insertNewMarker(var nombreLugar, var iconoLugar, var descripcionLugar,
    Marker marker) async {
  // Open a connection (testdb should already exist) javi123456_
  final conn = await MySqlConnection.connect(new ConnectionSettings(
      host: 'labs.iam.cat',
      port: 3306,
      user: 'a17pabsanrod_adm',
      password: 'pablo1234',
      db: 'a17pabsanrod_projectefinal'));

  conn.query("INSERT INTO MARKERS(ID, LATITUD, LONGITUD, ICONO) VALUES ('" +
      nombreLugar +
      "'," +
      marker.position.latitude.toString() +
      "," +
      marker.position.longitude.toString() +
      ",'" +
      iconoLugar +
      "')");

  conn.query(
      "INSERT INTO MARKERS_INFO(ID, TITULO, DESCRIPCION, ESTRELLAS) VALUES ('" +
          nombreLugar +
          "','" +
          nombreLugar +
          "','" +
          descripcionLugar +
          "', 0)");

  // Finally, close the connection
  await conn.close();
}

Future insertMarkerToFavorites(var idLugar, var username) async {
  // Open a connection (testdb should already exist) javi123456_
  final conn = await MySqlConnection.connect(new ConnectionSettings(
      host: 'labs.iam.cat',
      port: 3306,
      user: 'a17pabsanrod_adm',
      password: 'pablo1234',
      db: 'a17pabsanrod_projectefinal'));

  conn.query(
      "INSERT INTO USERS_FAVORITES_MARKERS(USERNAME,IDMARKER) VALUES ('" +
          username +
          "','" +
          idLugar +
          "')");

  // Finally, close the connection
  await conn.close();
}

Future removeMarkerToFavorites(var idLugar, var username) async {
  // Open a connection (testdb should already exist) javi123456_
  final conn = await MySqlConnection.connect(new ConnectionSettings(
      host: 'labs.iam.cat',
      port: 3306,
      user: 'a17pabsanrod_adm',
      password: 'pablo1234',
      db: 'a17pabsanrod_projectefinal'));

  conn.query("DELETE FROM USERS_FAVORITES_MARKERS WHERE USERNAME = '" +
      username +
      "' AND IDMARKER = '" +
      idLugar +
      "'");

  // Finally, close the connection
  await conn.close();
}

Future<String> obtenerMarkerToFavorites(var username) async {
  String nombreMarker;
  if (favoritesUser != null) {
    favoritesUser.clear();
  }
  // Open a connection (testdb should already exist) javi123456_
  final conn = await MySqlConnection.connect(new ConnectionSettings(
      host: 'labs.iam.cat',
      port: 3306,
      user: 'a17pabsanrod_adm',
      password: 'pablo1234',
      db: 'a17pabsanrod_projectefinal'));

  var results = await conn.query(
      "SELECT IDMARKER FROM USERS_FAVORITES_MARKERS WHERE USERNAME = '" +
          username +
          "'");

  if ((results.length == 0) || (results == null)) {
    favoritesUser.add("NADA");
  } else {
    for (var row in results) {
      nombreMarker = row[0];
      favoritesUser.add(nombreMarker);
    }
  }

  // Finally, close the connection
  await conn.close();
}

User getUser() {
  return user;
}

bool getConnection() {
  return connection;
}

List<String> getFavorites() {
  return favoritesUser;
}

//SELECT * FROM USERS_FAVORITES_MARKERS f JOIN MARKERS m ON f.IDMARKER = m.ID JOIN USERS u ON f.USERNAME = u.USERNAME WHERE u.USERNAME = 'javi'
