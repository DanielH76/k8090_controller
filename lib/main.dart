import 'package:flutter/material.dart';
import 'package:k8090_controller/service/serial_port_service.dart';

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
        body: Center(
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
                      ),
                    ),
                    FilledButton(
                      onPressed:
                          () => setState(() => portName = portController.text),
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
    );
  }
}

class _PortControls extends StatefulWidget {
  final String portName;
  const _PortControls({required this.portName});

  int get relay => 0x08;

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
    print("SASDASDASD");
    return Column(
      children: [
        Text(switch (relayService.port.isOpened) {
          true => "FORBINDELSE",
          _ => "INGEN FORBINDELSE",
        }),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              spacing: 20,
              children: [
                Text("USB RÅ"),
                FilledButton(
                  onPressed:
                      () async =>
                          await relayService.sendONCommand20(widget.relay),
                  child: Text("TÆND PORT 4 - kode 20"),
                ),
                FilledButton(
                  onPressed:
                      () async =>
                          await relayService.sendOFFCommand21(widget.relay),
                  child: Text("SLUK PORT 4 - kode 21"),
                ),
                FilledButton(
                  onPressed:
                      () async =>
                          await relayService.sendTimerCommand22(widget.relay),
                  child: Text("SÆT TIMER PORT 4 - kode 22"),
                ),
              ],
            ),
            Column(
              spacing: 20,
              children: [
                Text("USB DLL"),
                FilledButton(
                  onPressed:
                      () async =>
                          await relayService.sendONCommand11(widget.relay),
                  child: Text("TÆND PORT 4 - kode 11"),
                ),
                FilledButton(
                  onPressed:
                      () async =>
                          await relayService.sendOFFCommand12(widget.relay),
                  child: Text("SLUK PORT 4 - kode 12"),
                ),
                FilledButton(
                  onPressed:
                      () async =>
                          await relayService.sendTimerCommand41(widget.relay),
                  child: Text("SÆT TIMER PORT 4 - kode 41"),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
