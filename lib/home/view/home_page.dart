import 'package:app/home/bloc/home_bloc.dart';
import 'package:app/show/view/show_page.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_number_repository/phone_number_repository.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc(
        repository: context.read<PhoneNumberRepository>(),
        initialPrefix: "+852",
      ),
      child: HomeView(key: key),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  static TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Validate phone number'),
        centerTitle: true,
      ),
      body: MultiBlocListener(
        listeners: [
          // 弹窗
          BlocListener<HomeBloc, HomeState>(
            listenWhen: (previous, current) =>
                previous.status != current.status,
            listener: (context, state) {
              if (state.status == HomeStatus.showDialog) {
                // 展示Dialog
                List<Widget> widgetList = [];
                state.countryCodeMap!.forEach((key, value) {
                  String prefix = value;
                  if (value is String) {
                    if (!value.startsWith("+")) {
                      prefix = "+$value";
                    }
                  }
                  String showMsg = "$key: $prefix";
                  widgetList.add(SimpleDialogOption(
                    child: Text(showMsg),
                    onPressed: () {
                      Navigator.of(context).pop(prefix);
                    },
                  ));
                });
                showDialog(
                  context: context,
                  builder: (_) => SimpleDialog(
                    title: const Text("选择国家区号"),
                    children: widgetList,
                  ),
                ).then((value) =>
                    {context.read<HomeBloc>().add(SetPrefixEvent(value))});
              }
            },
          ),
          // 数据保存监听
          BlocListener<HomeBloc, HomeState>(listenWhen: (previous, current) {
            if (previous.status == HomeStatus.loading &&
                (current.status == HomeStatus.success ||
                    current.status == HomeStatus.failure ||
                    current.status == HomeStatus.emptyFailure)) {
              return true;
            }
            return false;
          }, listener: (context, state) {
            if (state.status == HomeStatus.success) {
              // 保存成功
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text("保存成功")));
            } else if(state.status == HomeStatus.failure){
              // 保存失败
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text("已存在相同号码")));
            } else if(state.status == HomeStatus.emptyFailure){
              // 号码为空
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text("请输入电话号码")));
            }
          })
        ],
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            return Column(
              // Column is also a layout widget. It takes a list of children and
              // arranges them vertically. By default, it sizes itself to fit its
              // children horizontally, and tries to be as tall as its parent.
              //
              // Invoke "debug painting" (press "p" in the console, choose the
              // "Toggle Debug Paint" action from the Flutter Inspector in Android
              // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
              // to see the wireframe for each widget.
              //
              // Column has various properties to control how it sizes itself and
              // how it positions its children. Here we use mainAxisAlignment to
              // center the children vertically; the main axis here is the vertical
              // axis because Columns are vertical (the cross axis would be
              // horizontal).
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 20),
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(100),
                      image: const DecorationImage(
                        image: AssetImage("lib/assets/images/iphone.png"),
                        fit: BoxFit.cover,
                      )),
                ),
                const SizedBox(height: 20),
                const Text("Please enter a phone number:"),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MaterialButton(
                      textColor: Colors.white,
                      color: Colors.blue,
                      hoverColor: Colors.blueAccent,
                      onPressed: () =>
                          context.read<HomeBloc>().add(const FetchDataEvent()),
                      child: BlocBuilder<HomeBloc, HomeState>(
                        builder: (context, state) {
                          if (state.initialPrefix == null) {
                            return const Text("+852");
                          } else {
                            return Text(state.initialPrefix!);
                          }
                        },
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        keyboardType: TextInputType.phone,
                        controller: controller,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                MaterialButton(
                  textColor: Colors.white,
                  color: Colors.blue,
                  hoverColor: Colors.blueAccent,
                  onPressed: () =>
                      context.read<HomeBloc>().add(ConfirmNumberEvent(
                            state.initialPrefix!,
                            controller.text,
                          )),
                  child: const Text("Confirm"),
                )
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(ShowPage.route()),
        tooltip: 'Show',
        child: const Icon(Icons.book),
      ),
    );
  }
}
