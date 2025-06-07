import 'package:e_commerce_tech/controllers/order_contoller.dart';
import 'package:e_commerce_tech/models/Transaction_model.dart';
import 'package:e_commerce_tech/utils/app_constants.dart';
import 'package:e_commerce_tech/widgets/app_bar_widget.dart';
import 'package:e_commerce_tech/widgets/item_select_widget.dart';
import 'package:e_commerce_tech/widgets/list_view_custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyOrderScreen extends StatefulWidget {
  const MyOrderScreen({super.key});

  @override
  State<MyOrderScreen> createState() => _MyOrderScreenState();
}

class _MyOrderScreenState extends State<MyOrderScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final OrderController orderController = Get.put(OrderController());

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    final userId = UserStorage.currentUser?.id.toString() ?? '';

    Future.delayed(Duration.zero, () {
      orderController.getTransactionById(
        context: context,
        status: 'pending',
        userId: userId,
      );
    });

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;

      final statuses = ['pending', 'complete', 'failed'];
      final status = statuses[_tabController.index];

      Future.delayed(Duration.zero, () {
        orderController.getTransactionById(
          context: context,
          status: status,
          userId: userId,
        );
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(type: this, title: "checkout".tr, context: context, bottom: TabBar(
        controller: _tabController,
        tabs: [
          Tab(text: "pending".tr),
          Tab(text: "complete".tr),
          Tab(text: "cancel".tr),
        ],
      ),),
      body: TabBarView(
        controller: _tabController,
        children: const [
          OrdersTab(status: 'pending'),
          OrdersTab(status: 'complete'),
          OrdersTab(status: 'failed'),
        ],
      ),
    );
  }
}

class OrdersTab extends StatefulWidget {
  final String status;

  const OrdersTab({super.key, required this.status});

  @override
  State<OrdersTab> createState() => _OrdersTabState();
}

class _OrdersTabState extends State<OrdersTab> {
  final OrderController orderController = Get.put(OrderController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrderController>(builder: (_) {
      if (orderController.isLoading) {
        return const Center(child: CircularProgressIndicator());
      }

      final List<TransactionModel> items =
          orderController.transactionsByStatus[widget.status] ?? [];

      if (items.isEmpty) {
        return Center(child: Text('no_orders_found'.tr));
      }

      return Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView.builder(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final tx = items[index];
            final imageList = <String>[];

            for (var item in tx.order?.orderItems ?? []) {
              for (var image in item.product?.imageUrl ?? []) {
                imageList.add(image);
              }
            }
            return ItemSelectWidget(
              imageUrl: imageList,
              title: tx.createdAt ?? 'No Title',
              prices: '\$${tx.amount ?? '0.00'}',
              countNumber: tx.order?.orderItems?.length.toString() ?? '0',
            );
          },
        ),
      );
    });
  }
}
