import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora TMB',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: TelaPrincipal(),
    );
  }
}

class TelaPrincipal extends StatefulWidget {
  @override
  _TelaPrincipalState createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> with SingleTickerProviderStateMixin {
  final TextEditingController _idadeController = TextEditingController();
  final TextEditingController _pesoController = TextEditingController();
  final TextEditingController _alturaController = TextEditingController();

  double? _tmb;
  bool _isMulher = true;
  double _buttonOpacity = 1.0;

  late AnimationController _controller;
  late Animation<double> _formAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _formAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _idadeController.dispose();
    _pesoController.dispose();
    _alturaController.dispose();
    super.dispose();
  }

  void _calcularTMB() {
    final double idade = double.tryParse(_idadeController.text) ?? 0.0;
    final double peso = double.tryParse(_pesoController.text) ?? 0.0;
    final double altura = double.tryParse(_alturaController.text) ?? 0.0;

    if (_isMulher) {
      _tmb = 447.593 + (9.247 * peso) + (3.098 * altura) - (4.330 * idade);
    } else {
      _tmb = 88.362 + (13.397 * peso) + (4.799 * altura) - (5.677 * idade);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculadora TMB'),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: FadeTransition(
            opacity: _formAnimation,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(-0.5, 0),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: _controller,
                    curve: Interval(0.0, 0.4, curve: Curves.easeOut),
                  )),
                  child: TextField(
                    controller: _idadeController,
                    decoration: InputDecoration(
                      labelText: 'Idade (anos)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(height: 10),
                SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(-0.5, 0),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: _controller,
                    curve: Interval(0.2, 0.6, curve: Curves.easeOut),
                  )),
                  child: TextField(
                    controller: _alturaController,
                    decoration: InputDecoration(
                      labelText: 'altura (cm)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(height: 10),
                SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(-0.5, 0),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: _controller,
                    curve: Interval(0.4, 0.8, curve: Curves.easeOut),
                  )),
                  child: TextField(
                    controller: _pesoController,
                    decoration: InputDecoration(
                      labelText: 'Peso (kg)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(height: 10),
                SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(-0.5, 0),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: _controller,
                    curve: Interval(0.6, 1.0, curve: Curves.easeOut),
                  )),
                  child: Row(
                    children: [
                      Text('Feminino'),
                      Switch(
                        value: _isMulher,
                        onChanged: (value) {
                          setState(() {
                            _isMulher = value;
                          });
                        },
                      ),
                      Text('Masculino'),
                    ],
                  ),
                ),
                SizedBox(height: 30),

                DraggableButton(
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
                  child: Container(
                    width: double.infinity,
                    child: AnimatedOpacity(
                      opacity: _buttonOpacity,
                      duration: Duration(milliseconds: 300),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 15),
                        ),
                        onPressed: null, // Handling in DraggableButton
                        child: Text('Calcular TMB', style: TextStyle(fontSize: 18)),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 15),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) =>
                              TelaResultado(tmb: _tmb),
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            return FadeTransition(
                              opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                                CurvedAnimation(parent: animation, curve: Curves.easeOut),
                              ),
                              child: SlideTransition(
                                position: Tween<Offset>(begin: Offset(0, 0.5), end: Offset.zero)
                                    .animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
                                child: ScaleTransition(
                                  scale: Tween<double>(begin: 0.8, end: 1.0).animate(
                                    CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
                                  ),
                                  child: child,
                                ),
                              ),
                            );
                          },
                          transitionDuration: Duration(milliseconds: 800),
                        ),
                      );
                    },
                    child: Text('Ver Resultado', style: TextStyle(fontSize: 18)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DraggableButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  DraggableButton({required this.child, required this.onTap});

  @override
  _DraggableButtonState createState() => _DraggableButtonState();
}

class _DraggableButtonState extends State<DraggableButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Alignment> _animation;
  Alignment _dragAlignment = Alignment.center;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _controller.addListener(() {
      setState(() {
        _dragAlignment = _animation.value;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _runAnimation(Offset pixelsPerSecond, Size size) {
    _animation = _controller.drive(
      AlignmentTween(
        begin: _dragAlignment,
        end: Alignment.center,
      ),
    );

    final unitsPerSecondX = pixelsPerSecond.dx / size.width;
    final unitsPerSecondY = pixelsPerSecond.dy / size.height;
    final unitsPerSecond = Offset(unitsPerSecondX, unitsPerSecondY);
    final unitVelocity = unitsPerSecond.distance;

    const spring = SpringDescription(
      mass: 30,
      stiffness: 1,
      damping: 1,
    );

    final simulation = SpringSimulation(spring, 0, 1, -unitVelocity);
    _controller.animateWith(simulation);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: widget.onTap,
      onPanDown: (details) {
        _controller.stop();
      },
      onPanUpdate: (details) {
        setState(() {
          _dragAlignment += Alignment(
            2 * details.delta.dx / size.width,
            2 * details.delta.dy / size.height,
          );
        });
      },
      onPanEnd: (details) {
        _runAnimation(details.velocity.pixelsPerSecond, size);
      },
      child: Align(
        alignment: _dragAlignment,
        child: widget.child,
      ),
    );
  }
}

class TelaResultado extends StatefulWidget {
  final double? tmb;

  TelaResultado({required this.tmb});

  @override
  _TelaResultadoState createState() => _TelaResultadoState();
}

class _TelaResultadoState extends State<TelaResultado> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Interval(0.0, 0.6, curve: Curves.easeIn),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Interval(0.2, 0.8, curve: Curves.elasticOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Resultado'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: Tween<double>(begin: 0.5, end: 1.0).animate(_scaleAnimation),
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          spreadRadius: 1,
                        )
                      ],
                    ),
                    child: Text(
                      'Sua Taxa Metabólica Basal é: ${widget.tmb?.toStringAsFixed(2)} kcal/dia',
                      style: TextStyle(fontSize: 24),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40),
              FadeTransition(
                opacity: CurvedAnimation(
                  parent: _controller,
                  curve: Interval(0.6, 1.0, curve: Curves.easeIn),
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Voltar', style: TextStyle(fontSize: 18)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
