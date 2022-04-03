import 'package:flutter/material.dart';

import 'package:latlong/latlong.dart';

import '../../../models/address/address.dart';

import '../geo_location.dart';

class GeoLocationSearch extends SearchDelegate<Map> {
  final _scrollController = ScrollController();
  final _searchBloc = GeoLocationSearchBloc();

  Widget buildError() {
    return Center(
      child: Text(_searchBloc.error),
    );
  }

  @override
  String get searchFieldLabel => 'Поиск мест и адресов';

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () => query = '',
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return StreamBuilder(
      stream: _searchBloc.address,
      builder: (context, AsyncSnapshot<List<Address>> snapshot) {
        if (_searchBloc.error != null) {
          return buildError();
        }
        if (!snapshot.hasData) {
          return Center(
            child: Text('Нет результатов'),
          );
        }

        return Scrollbar(
          isAlwaysShown: true,
          controller: _scrollController,
          child: ListView.separated(
            controller: _scrollController,
            itemCount: snapshot?.data?.length ?? 0,
            separatorBuilder: (_, __) => Divider(),
            itemBuilder: (context, index) {
              final address = snapshot?.data[index];
              return ListTile(
                title: Text(address?.formattedAddress),
                trailing: Icon(Icons.arrow_forward),
                onTap: () {
                  final data = {
                    'location':
                        LatLng(address?.latitude, address?.longitude),
                    'formattedAddress': address?.formattedAddress,
                  };
                  close(context, data);
                },
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isNotEmpty) {
      _searchBloc.getAddress(query);
    }
    return StreamBuilder(
      stream: _searchBloc.address,
      builder: (context, AsyncSnapshot<List<Address>> snapshot) {
        if (_searchBloc.error != null) {
          return buildError();
        }
        if (!snapshot.hasData) {
          return Center(
            child: Text('Пока что здесь ничего нет...'),
          );
        }

        return Scrollbar(
          isAlwaysShown: true,
          controller: _scrollController,
          child: ListView.separated(
            controller: _scrollController,
            itemCount: snapshot?.data?.length ?? 0,
            separatorBuilder: (_, __) => Divider(),
            itemBuilder: (context, index) {
              final address = snapshot?.data[index];
              return ListTile(
                title: Text(address?.formattedAddress),
                trailing: Icon(Icons.arrow_forward),
                onTap: () {
                  final data = {
                    'location':
                        LatLng(address?.latitude, address?.longitude),
                    'formattedAddress': address?.formattedAddress,
                  };
                  close(context, data);
                },
              );
            },
          ),
        );
      },
    );
  }
}
