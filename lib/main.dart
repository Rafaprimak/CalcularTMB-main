import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora TMB',
      home: TelaPrincipal(),
    );
  }
}

class TelaPrincipal extends StatefulWidget {

  @override
  _TelaPrincipalState createState() => 
    _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {

  final TextEditingController _idadeController = TextEditingController();
  final TextEditingController _pesoController = TextEditingController();
  final TextEditingController _alturaController = TextEditingController();

  double? _tmb;
  bool _isMulher = true;
  double _buttonOpacity = 1.0;

  void _calcularTMB(){
    final double idade = double.tryParse(_idadeController.text) ?? 0.0;
    final double peso = double.tryParse(_pesoController.text) ?? 0.0;
    final double altura = double.tryParse(_alturaController.text) ?? 0.0;

    if(_isMulher){
      _tmb = 447.593 + (9.247 * peso) + (3.098 * altura) - (4.330 * idade);
    } else {
      _tmb = 88.362 + (13.397 * peso) + (4.799 * altura) - (5.677 * idade);
    }

    setState(() {});
  }

  void _exibirResultado(){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TelaResultado(tmb: _tmb),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculadora TMB'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:[
            TextField(
              controller: _idadeController,
              decoration: InputDecoration(
                labelText: 'Idade (anos)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            TextField(
              controller: _alturaController,
              decoration: InputDecoration(
                labelText: 'altura (cm)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            TextField(
              controller: _pesoController,
              decoration: InputDecoration(
                labelText: 'Peso (kg)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),

            Row(
              children:[
                Text('Feminino'),
                Switch(
                  value: _isMulher,
                  onChanged: (value){
                    setState(() {
                      _isMulher = value;
                    });
                  },
                ),
                Text('Masculino'),
              ],
            ),
            // Button with fade effect
            InkWell(
              onTap: () {
                setState(() {
                  _buttonOpacity = 0.5;
                });
                _calcularTMB();
                Future.delayed(Duration(milliseconds: 300), () {
                  setState(() {
                    _buttonOpacity = 1.0;
                  });
                });
              },
              child: AnimatedOpacity(
                opacity: _buttonOpacity,
                duration: Duration(milliseconds: 300),
                child: ElevatedButton(
                  onPressed: null, // Handling in InkWell
                  child: Text('Calcular TMB'),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => 
                      TelaResultado(tmb: _tmb),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      var begin = Offset(1.0, 0.0);
                      var end = Offset.zero;
                      var curve = Curves.ease;
                      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                      return SlideTransition(
                        position: animation.drive(tween),
                        child: child,
                      );
                    },
                    transitionDuration: Duration(milliseconds: 500),
                  ),
                );
              }, 
              child: Text('Ver Resultado')
            ),
          ],
        ),
      ),
    );
    
  }
}

class TelaResultado extends StatelessWidget{
  final double? tmb;

  TelaResultado({required this.tmb});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Resultado'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Center(
          child: Text(
            'Sua Taxa Metabólica Basal é: ${tmb?.toStringAsFixed(2)} kcal/dia',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
