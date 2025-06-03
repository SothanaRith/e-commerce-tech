import 'package:e_commerce_tech/controllers/order_contoller.dart';
import 'package:e_commerce_tech/models/Transaction_model.dart';
import 'package:e_commerce_tech/utils/app_constants.dart';
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

    // Load initial tab's data (pending)
    orderController.getTransactionById(
        context: context, status: 'pending', userId: userId);

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return; // skip while animating

      final statuses = ['pending', 'complete', 'failed'];
      final status = statuses[_tabController.index];

      orderController.getTransactionById(
          context: context, status: status, userId: userId);
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
      appBar: AppBar(
        title: const Text("My Orders"),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "Pending"),
            Tab(text: "Complete"),
            Tab(text: "Cancel"),
          ],
        ),
      ),
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
  final OrderController orderController = Get.find<OrderController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrderController>(builder: (_) {
      if (orderController.isLoading) {
        return const Center(child: CircularProgressIndicator());
      }

      // Get transactions for this tab's status from the map
      final List<TransactionModel> items =
          orderController.transactionsByStatus[widget.status] ?? [];

      if (items.isEmpty) {
        return const Center(child: Text('No orders found.'));
      }

      return Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: ListViewCustomWidget(
            items: items
                .map((tx) => ItemSelectWidget(
              imageUrl: tx.order?.orderItems?[0].product?.imageUrl?.first ?? '',
              title: tx.notes ?? 'No Title',
              prices: '\$${tx.amount ?? '0.00'}',
              countNumber: tx.orderId?.toString() ?? '0',
            ))
                .toList(),
          ),
        ),
      );
    });
  }
}
