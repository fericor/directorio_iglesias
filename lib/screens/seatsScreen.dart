import 'package:book_my_seat/book_my_seat.dart';
import 'package:conexion_mas/controllers/eventosApiClient.dart';
import 'package:conexion_mas/utils/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localstorage/localstorage.dart';

class SeatsScreen extends StatefulWidget {
  const SeatsScreen({super.key});

  @override
  State<SeatsScreen> createState() => _SeatsScreenState();
}

class _SeatsScreenState extends State<SeatsScreen> {
  Set<SeatNumber> selectedSeats = {};
  List<List<SeatState>> seatStates = [];
  bool isLoaded = true;

  @override
  void initState() {
    super.initState();
    listarEventosSeats();
  }

  void listarEventosSeats() {
    EventosApiClient().getEventoSeatsById(1).then((eventoSeatsResponse) {
      List<List<int>> data = eventoSeatsResponse.seats;

      for (var row in data) {
        List<SeatState> seatRow = row.map<SeatState>((seat) {
          return SeatState
              .values[seat]; // Mapea el valor numérico al valor del enum
        }).toList();

        seatStates.add(seatRow); // Agrega la fila convertida a seatStates
      }

      setState(() {
        isLoaded = false;
      });
    });
  }

  void modificarAsiento(int fila, int columna, int valor) async {
    await initLocalStorage();
    EventosApiClient().updateSeat(
        "1",
        localStorage.getItem('miIdUser').toString(),
        fila,
        columna,
        valor,
        localStorage.getItem('miToken').toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color(0xFFf0f0f0),
      body: isLoaded
          ? frcaWidget.frca_loading_simple()
          : SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 16,
                  ),
                  const Text("Theatre Screen this side"),
                  const SizedBox(
                    height: 16,
                  ),
                  Flexible(
                    child: SizedBox(
                      width: double.maxFinite,
                      height: 550,
                      child: SeatLayoutWidget(
                        onSeatStateChanged: (rowI, colI, seatState) {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: seatState == SeatState.selected
                                  ? Text("Selected Seat[$rowI][$colI]")
                                  : Text("De-selected Seat[$rowI][$colI]"),
                            ),
                          );
                          if (seatState == SeatState.selected) {
                            selectedSeats
                                .add(SeatNumber(rowI: rowI, colI: colI));
                            modificarAsiento(rowI, colI, 0);
                          } else {
                            selectedSeats
                                .remove(SeatNumber(rowI: rowI, colI: colI));
                            modificarAsiento(rowI, colI, 1);
                          }
                        },
                        stateModel: SeatLayoutStateModel(
                          pathDisabledSeat:
                              'assets/images/seats/svg_disabled_bus_seat.svg',
                          pathSelectedSeat:
                              'assets/images/seats/svg_selected_bus_seats.svg',
                          pathSoldSeat:
                              'assets/images/seats/svg_sold_bus_seat.svg',
                          pathUnSelectedSeat:
                              'assets/images/seats/svg_unselected_bus_seat.svg',
                          rows: seatStates.length,
                          cols: seatStates[0].length,
                          seatSvgSize: 55,
                          currentSeatsState: seatStates,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              'assets/images/seats/svg_disabled_bus_seat.svg',
                              width: 15,
                              height: 15,
                            ),
                            const Text('Disabled')
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              'assets/images/seats/svg_sold_bus_seat.svg',
                              width: 15,
                              height: 15,
                            ),
                            const Text('Sold')
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              'assets/images/seats/svg_unselected_bus_seat.svg',
                              width: 15,
                              height: 15,
                            ),
                            const Text('Available')
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              'assets/images/seats/svg_selected_bus_seats.svg',
                              width: 15,
                              height: 15,
                            ),
                            const Text('Selected by you')
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {});
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.resolveWith(
                          (states) => const Color(0xFFfc4c4e)),
                    ),
                    child: const Text('Show my selected seat numbers'),
                  ),
                  const SizedBox(height: 12),
                  Text(selectedSeats.join(" , "))
                ],
              ),
            ),
    );
  }
}

class SeatNumber {
  final int rowI;
  final int colI;

  const SeatNumber({required this.rowI, required this.colI});

  @override
  bool operator ==(Object other) {
    return rowI == (other as SeatNumber).rowI && colI == (other).colI;
  }

  @override
  int get hashCode => rowI.hashCode;

  @override
  String toString() {
    return '[$rowI][$colI]';
  }
}
