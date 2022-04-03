import 'package:flutter/material.dart';

import '../../../models/station/station.dart';

navigationButtonPressed({
  @required String routeName,
  @required BuildContext context,
  @required List<Station> stations,
  IconData trailingIcon = Icons.arrow_forward,
}) async {
  await showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(20),
        topLeft: Radius.circular(20),
      ),
    ),
    builder: (_) {
      return ListView.separated(
        primary: false,
        shrinkWrap: true,
        itemCount: stations?.length ?? 0,
        separatorBuilder: (_, __) => Divider(),
        itemBuilder: (context, index) {
          final station = stations[index];
          return ListTile(
            title: Text(station?.name),
            subtitle: Text(station?.location?.formattedAddress),
            trailing: Icon(trailingIcon),
            onTap: () => Navigator.of(context)
                .pushNamed(routeName, arguments: station),
          );
        },
      );
    },
  );
}
