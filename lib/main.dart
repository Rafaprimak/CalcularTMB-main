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
            ElevatedButton(onPressed: _calcularTMB, child: Text('Calcular TMB')),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _exibirResultado, child: Text('Ver Resultado')),
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
