import 'package:flutter/material.dart';
import '../AppLocalizations.dart';
import '../const/Const.dart';
import '../customer/Customer.dart';
import '../flights/FlightItem.dart';
import 'Reservation.dart';

class ReservationDetailPage extends StatelessWidget {
  final Reservation reservation;
  final Customer customer;
  final FlightItem flight;
  final Function(Reservation) onDelete;

  const ReservationDetailPage({
    Key? key,
    required this.reservation,
    required this.customer,
    required this.flight,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.translate(Const.RESERVATION_DETAILS)!),
        actions: [

          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              //invoke back to ReservationPage's delete method to delete
              await onDelete(reservation);
              Navigator.of(context).pop(); // Close the detail page after deletion
            },
          ),

        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${AppLocalizations.of(context)!.translate(Const.CUSTOMER)!}: ${customer.firstName} ${customer.lastName}'),
            Text('${AppLocalizations.of(context)!.translate(Const.FLIGHT)!}: ${flight.flightCode}'),
            Text('${AppLocalizations.of(context)!.translate(Const.FROM)!}: ${flight.departureCity} ${AppLocalizations.of(context)!.translate(Const.AT)!} ${flight.departureTime}'),
            Text('${AppLocalizations.of(context)!.translate(Const.TO)!}: ${flight.destinationCity} ${AppLocalizations.of(context)!.translate(Const.AT)!} ${flight.arrivalTime}'),
            Text('${AppLocalizations.of(context)!.translate(Const.DATE)!}: ${reservation.date}'),
          ],
        ),
      ),
    );
  }

}

