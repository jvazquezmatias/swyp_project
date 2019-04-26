import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

class MapPage extends StatefulWidget {
  static int _indexFormatMap = 0;
  static String tag = 'map-page';
  static MapType tipusMapa = MapType.normal;
  @override
  MapUiPage createState() => new MapUiPage();
  
}

class MapUiPage extends State<MapPage> {
  static double numZoom = 14.4746;
  //static List<dynamic> listMarkers = new ArrayList<>();
  static CameraPosition _position = CameraPosition(
    target: LatLng(41.38616, 2.1037613),
    zoom: numZoom,
  );
  Completer<GoogleMapController> _controller = Completer();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: GoogleMap(
          mapType: MapPage.tipusMapa,
          initialCameraPosition: _position,
          onCameraMove: _updateCameraPosition,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
            _addMarkers();
          },
          markers: Set<Marker>.of(markers.values),
        ),
        floatingActionButton:
            Column(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
          FloatingActionButton(
            heroTag: "buttonFormatMap",
            onPressed: () {
              _formatMap();
            },
            child: Icon(Icons.map),
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            heroTag: "buttonAdd",
            onPressed: () {
              _zoomIn();
            },
            child: Icon(Icons.add),
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            heroTag: "buttonRemove",
            onPressed: () {
              _zoomOut();
            },
            child: Icon(Icons.remove),
          ),
          SizedBox(height: 10),
        ],
        ),
        
        );
        
  }

  Future<void> _zoomIn() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.zoomTo(_position.zoom + 1));
  }

  Future<void> _zoomOut() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.zoomTo(_position.zoom - 1));
  }

  void _formatMap() {
    MapPage._indexFormatMap++;
    if (MapPage._indexFormatMap == 0) {
      setState(() {
        MapPage.tipusMapa = MapType.normal;
      });
    }
    if (MapPage._indexFormatMap == 1) {
      setState(() {
        MapPage.tipusMapa = MapType.satellite;
      });
    }
    if (MapPage._indexFormatMap == 2) {
      setState(() {
        MapPage.tipusMapa = MapType.terrain;
      });
    }
    if (MapPage._indexFormatMap == 3) {
      setState(() {
        MapPage.tipusMapa = MapType.hybrid;
      });
      MapPage._indexFormatMap = -1;
    }
  }

  void _updateCameraPosition(CameraPosition position) {
    setState(() {
      _position = position;
    });
  }

  void _addMarkers() {
    var markerIdVal = "ausias";
    final MarkerId markerId = MarkerId(markerIdVal);

    // creating a new MARKER
    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(41.38616,  2.1037613),
      onTap: () {
        
      },
      
    );

    setState(() {
      // adding a new marker to map
      markers[markerId] = marker;
    });
}

}