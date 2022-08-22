import 'package:app/show/bloc/show_bloc.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_number_repository/phone_number_repository.dart';

class ShowPage extends StatelessWidget {
  const ShowPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => BlocProvider(
        create: (context) => ShowBloc(
          repository: context.read<PhoneNumberRepository>(),
        )..add(const ShowDataEvent()),
        child: const ShowPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ShowBloc(
        repository: context.read<PhoneNumberRepository>(),
      )..add(const ShowDataEvent()),
      child: const ShowView(),
    );
  }
}

class ShowView extends StatelessWidget {
  const ShowView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text('Show phone number'),
        centerTitle: true,
      ),
      body: BlocBuilder<ShowBloc, ShowState>(
        builder: (context, state) {
          LogUtil.e(state.status);
          LogUtil.e(state.numberList.length);
          if (state.numberList.isEmpty) {
            return Center(
              child: Text(
                '没有数据',
                style: Theme.of(context).textTheme.caption,
              ),
            );
          }

          return ListView(
            children: [
              for (final number in state.numberList)
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    '${number.prefix} ${number.number}',
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
