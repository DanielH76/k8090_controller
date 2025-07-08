import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:k8090_controller/consts/consts.dart';
import 'package:k8090_controller/service/serial_port_service.dart';
import 'package:k8090_controller/widgets/async_filled_button.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final portController = TextEditingController();
  String portName = "";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(30),
              child: Column(
                spacing: 20,
                children: [
                  Row(
                    spacing: 10,
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: portController,
                          decoration: InputDecoration(
                            label: Text("Indtast port - COM3 måske"),
                          ),
                          onFieldSubmitted: (_) => _onSubmitted(),
                        ),
                      ),
                      FilledButton(
                        onPressed: _onSubmitted,
                        child: Text("Sæt porten"),
                      ),
                    ],
                  ),
                  if (portName.isNotEmpty) _PortControls(portName: portName),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onSubmitted() => setState(() => portName = portController.text);
}

class _PortControls extends StatefulWidget {
  final String portName;
  const _PortControls({required this.portName});

  @override
  State<_PortControls> createState() => _PortControlsState();
}

class _PortControlsState extends State<_PortControls> {
  late final RelayService relayService;

  @override
  void initState() {
    relayService = RelayService(widget.portName);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 40,
      children: [
        Text(switch (relayService.port.isOpened) {
          true => "FORBINDELSE",
          _ => "INGEN FORBINDELSE",
        }),
        for (int i = 0; i < Relays.values.length; i += 2)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 20,
            children: [
              _RelayControls(
                relayByteValue: Relays.values[i],
                relayService: relayService,
                relayPosition: i,
              ),
              _RelayControls(
                relayByteValue: Relays.values[i + 1],
                relayPosition: i + 1,
                relayService: relayService,
              ),
            ],
          ),
      ],
    );
  }
}

class _RelayControls extends StatefulWidget {
  final int relayByteValue;
  final int relayPosition;
  final RelayService relayService;

  const _RelayControls({
    required this.relayByteValue,
    required this.relayPosition,
    required this.relayService,
  });

  @override
  State<_RelayControls> createState() => __RelayControlsState();
}

class __RelayControlsState extends State<_RelayControls> {
  bool onLoading = false;
  bool offLoading = false;
  bool timerLoading = false;

  final ValueNotifier<int> timerDurationController = ValueNotifier<int>(0);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        Text("RELÆ ${widget.relayPosition + 1}"),
        AsyncFilledButton(
          future: widget.relayService.sendONCommand(widget.relayByteValue),
          backgroundColor: Colors.greenAccent,
          foregroundColor: Colors.white,
          child: Text("TÆND"),
        ),
        AsyncFilledButton(
          future: widget.relayService.sendOFFCommand(widget.relayByteValue),
          backgroundColor: Colors.redAccent,
          foregroundColor: Colors.white,
          child: Text("SLUK"),
        ),
        Row(
          spacing: 10,
          mainAxisSize: MainAxisSize.min,
          children: [
            AsyncFilledButton(
              future: widget.relayService.sendONCommand(widget.relayByteValue),
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
              child: Text("TIMER"),
            ),
            SizedBox(
              width: 45,
              child: TextFormField(
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged:
                    (value) => timerDurationController.value = int.parse(value),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
