import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Main',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class SliderData extends ChangeNotifier {
  double _value = 0.0;
  double get value => _value;
  set value(double newValue) {
    if (newValue != _value) {
      _value = newValue;
      notifyListeners();
    }
  }
}

final sliderData = SliderData();

//InheritedWidget holds onto its own value
//InheritedNotifier doesn't itself contains a value, it's depended on Notifier which is a
//listnable such as Value or ChangeNotifier

class SliderInheritedNotifier extends InheritedNotifier<SliderData> {
  // const SliderInheritedNotifier({
  //   Key? key,
  //   required SliderData sliderData,
  //   required Widget child,
  // }) : super(
  //         key: key,
  //         notifier: sliderData,
  //         child: child,
  //       );
  const SliderInheritedNotifier({
    super.key,
    required super.child,
    required super.notifier,
  });
  static double of(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<SliderInheritedNotifier>()
          ?.notifier
          ?.value ??
      0.0;
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: SafeArea(
        child: SliderInheritedNotifier(
          notifier: sliderData,
          child: Builder(
            // HomePage context was made earlier that time no SliderNotifier
            //context was there
            // SliderInheritedNotifier was built after the homepage context
            // SliderNotifier is not using its own Build context
            // Without builder the SliderInheritedNotifier context
            // So using builder the SliderInheritedNotifier will use the
            //context which is made after the build method
            // builder's context includes not only the context that was
            //inside the build function above it but it also includes all data
            //and inherited widgets that were created after that build function
            //just before the builder so in between -- sandwiching between
            builder: (context) {
              return Column(
                children: [
                  Slider(
                    value: SliderInheritedNotifier.of(context),
                    onChanged: (value) {
                      sliderData.value = value;
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Opacity(
                        opacity: SliderInheritedNotifier.of(context),
                        child: Container(
                          height: 200,
                          color: Colors.teal,
                        ),
                      ),
                      Opacity(
                        opacity: SliderInheritedNotifier.of(context),
                        child: Container(
                          height: 200,
                          color: Colors.purple,
                        ),
                      ),
                    ].expandEqually().toList(),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

extension ExpandEqually on Iterable<Widget> {
  Iterable<Widget> expandEqually() => map(
        (w) => Expanded(child: w),
      );
}
