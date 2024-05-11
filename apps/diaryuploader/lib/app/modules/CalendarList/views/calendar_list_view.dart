import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/calendar_list_controller.dart';

class CalendarListView extends GetView<CalendarListController> {
  const CalendarListView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar List'),
        centerTitle: true,
      ),
      body: FutureBuilder(
          future: controller.list(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // 当异步操作进行中
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              // 当异步操作发生错误
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Icon(Icons.error_outline),
                    const SizedBox(height: 20),
                    Text('Error: ${snapshot.error}'),
                  ],
                ),
              );
            } else if (snapshot.hasData) {
              // 当异步操作成功并有数据返回
              final data = snapshot.requireData;
              return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (c, index) {
                    final item = data[index];
                    return InkWell(
                      onTap: () {
                        Get.back(result: item);
                      },
                      child: Row(
                        children: [
                          Text(index.toString()),
                          const SizedBox(width: 8),
                          Text(item.name),
                          const SizedBox(width: 8),
                          Text(item.id),
                        ],
                      ),
                    );
                  });
            } else {
              // 当异步操作没有数据返回（通常不会发生）
              return const Center(child: Text('No data'));
            }
          }),
    );
  }
}
