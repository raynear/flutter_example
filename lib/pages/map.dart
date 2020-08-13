import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';

import 'package:hire/main.dart';

class Map extends StatefulWidget {
  @override
  _Map createState() => _Map();
}

class _Map extends State<Map> {
  GoogleMapController _controller;

  @override
  Widget build(BuildContext context) {
    var appBarHeight =
        AppBar().preferredSize.height - MediaQuery.of(context).padding.top;
    return Scaffold(
        appBar: AppBar(
          title: Text('Map'),
          actions: [
            CircleAvatar(
                radius: appBarHeight * 1.0,
                backgroundColor: Colors.teal[200],
                child: CircleAvatar(
                  radius: appBarHeight * 0.9,
                  backgroundImage: CachedNetworkImageProvider(
                    Provider.of<Account>(context).avatar,
                  ),
                  backgroundColor: Colors.transparent,
                ))
          ],
        ),
        body: Center(
          child: FutureBuilder(
              future: this._getCurrentPosition(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return CircularProgressIndicator();
                    break;
                  default:
                    print(snapshot.data);
                    var position = LatLng(0.0,
                        0.0); //snapshot.data.latitude, snapshot.data.longitude);
                    print("test ${position.latitude} ${position.longitude}");
                    var here = CameraPosition(
                      target: LatLng(
                          0.0, 0.0), //position.latitude, position.longitude),
                      zoom: 18.0,
                    );
                    return GoogleMap(
                      mapType: MapType.normal,
                      initialCameraPosition: here,
                      onMapCreated: (GoogleMapController controller) {
                        _controller = controller;
                      },
                      markers: <Marker>[
                        Marker(
                            markerId: MarkerId("here"),
                            position: position,
                            infoWindow:
                                InfoWindow(title: "너는 여기야", snippet: "맞아?"))
                      ].toSet(),
                      compassEnabled: true,
                      zoomGesturesEnabled: true,
                      rotateGesturesEnabled: true,
                      scrollGesturesEnabled: true,
                      tiltGesturesEnabled: true,
                    );
                    break;
                }
              }),
        ));
  }

  _getCurrentPosition() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print("position $position");
    return position;
  }
}
