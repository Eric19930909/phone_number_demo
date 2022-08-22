import 'package:app/home/bloc/home_bloc.dart';
import 'package:app/show/view/show_page.dart';
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
        initialPrefix: '+852',
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
                final widgetList = <Widget>[];
                state.countryCodeMap!.forEach((key, value) {
                  var prefix = value.toString();
                  if (value is String) {
                    if (!value.startsWith('+')) {
                      prefix = '+$value';
                    }
                  }
                  final showMsg = '$key: $prefix';
                  widgetList.add(
                    SimpleDialogOption(
                      child: Text(showMsg),
                      onPressed: () {
                        Navigator.of(context).pop(prefix);
                      },
                    ),
                  );
                });
                showDialog<String>(
                  context: context,
                  builder: (_) => SimpleDialog(
                    title: const Text('选择国家区号'),
                    children: widgetList,
                  ),
                ).then(
                  (value) => {
                    context
                        .read<HomeBloc>()
                        .add(SetPrefixEvent(value.toString()))
                  },
                );
              }
            },
          ),
          // 数据保存监听
          BlocListener<HomeBloc, HomeState>(
            listenWhen: (previous, current) {
              if (previous.status == HomeStatus.loading &&
                  (current.status == HomeStatus.success ||
                      current.status == HomeStatus.failure ||
                      current.status == HomeStatus.emptyFailure)) {
                return true;
              }
              return false;
            },
            listener: (context, state) {
              if (state.status == HomeStatus.success) {
                // 保存成功
                ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(content: Text('保存成功')));
              } else if (state.status == HomeStatus.failure) {
                // 保存失败
                ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(content: Text('已存在相同号码')));
              } else if (state.status == HomeStatus.emptyFailure) {
                // 号码为空
                ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(content: Text('请输入电话号码')));
              }
            },
          )
        ],
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            return Column(
              children: <Widget>[
                const SizedBox(height: 20),
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(100),
                    image: const DecorationImage(
                      image: AssetImage('lib/assets/images/iphone.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text('Please enter a phone number:'),
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
                            return const Text('+852');
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
                  onPressed: () => context.read<HomeBloc>().add(
                        ConfirmNumberEvent(
                          state.initialPrefix!,
                          controller.text,
                        ),
                      ),
                  child: const Text('Confirm'),
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
