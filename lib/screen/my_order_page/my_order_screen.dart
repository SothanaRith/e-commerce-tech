import 'package:e_commerce_tech/controllers/order_contoller.dart';
import 'package:e_commerce_tech/main.dart';
import 'package:e_commerce_tech/models/Transaction_model.dart';
import 'package:e_commerce_tech/models/product_model.dart';
import 'package:e_commerce_tech/screen/track_order_page/order_transaction_detail_screen.dart';
import 'package:e_commerce_tech/utils/app_constants.dart';
import 'package:e_commerce_tech/utils/tap_routes.dart';
import 'package:e_commerce_tech/widgets/app_bar_widget.dart';
import 'package:e_commerce_tech/widgets/item_select_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MyOrderScreen extends StatefulWidget {
  const MyOrderScreen({super.key});

  @override
  State<MyOrderScreen> createState() => _MyOrderScreenState();
}

class _MyOrderScreenState extends State<MyOrderScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final OrderController orderController = Get.put(OrderController());

  DateTime? startDate;
  DateTime? endDate;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);

    final userId = UserStorage.currentUser?.id.toString() ?? '';

    Future.delayed(Duration.zero, () {
      fetchOrder(status: 'pending', userId: userId);
    });

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;

      final statuses = ['pending', 'delivery', 'delivered', 'completed', 'cancelled'];
      final status = statuses[_tabController.index];

      Future.delayed(Duration.zero, () {
        orderController.getOrderById(
          context: context,
          status: status,
          userId: userId,
          startDate: startDate != null ? startDate!.toIso8601String() : "",
          endDate: endDate != null ? endDate!.toIso8601String() : "",
        );
      });
    });
  }

  void fetchOrder({required String status, required String userId}) {
    orderController.getOrderById(
      context: context,
      status: status,
      userId: userId,
      startDate: startDate != null ? startDate!.toIso8601String() : "",
      endDate: endDate != null ? endDate!.toIso8601String() : "",
    );
  }

  Future<void> pickDateRange() async {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text("Select Date Range"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: Text("Start Date: ${startDate != null ? startDate!.toLocal().toString().split(' ')[0] : "Not selected"}"),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: startDate ?? DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (picked != null) {
                        setDialogState(() {
                          startDate = picked;
                        });
                      }
                    },
                  ),
                  ListTile(
                    title: Text("End Date: ${endDate != null ? endDate!.toLocal().toString().split(' ')[0] : "Not selected"}"),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: endDate ?? DateTime.now(),
                        firstDate: startDate ?? DateTime(2020),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (picked != null) {
                        setDialogState(() {
                          endDate = picked;
                        });
                      }
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    // Trigger the fetch again with updated dates
                    final userId = UserStorage.currentUser?.id.toString() ?? '';
                    final statuses = ['pending', 'delivery', 'delivered', 'completed', 'cancelled'];
                    final status = statuses[_tabController.index];
                    fetchOrder(status: status, userId: userId);
                  },
                  child: Text('Apply'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(type: this, title: "my_order".tr, context: context,
        action: [
          IconButton(
            icon: const Icon(Icons.date_range),
            onPressed: pickDateRange,
          ),
        ],
        bottom: TabBar(
        controller: _tabController,
        indicatorColor: theme.primaryColor,
        labelColor: theme.primaryColor,
        tabs: [
          Tab(text: "pending".tr, icon: Icon(Icons.watch_later_outlined),),
          Tab(text: "delivery".tr, icon: Icon(Icons.delivery_dining),),
          Tab(text: "delivered".tr, icon: Icon(Icons.local_shipping),),
          Tab(text: "complete".tr, icon: Icon(Icons.done),),
          Tab(text: "cancel".tr, icon: Icon(Icons.cancel),),
        ],
      ),),
      body: TabBarView(
        controller: _tabController,
        children: const [
          OrdersTab(status: 'pending'),
          OrdersTab(status: 'delivery'),
          OrdersTab(status: 'delivered'),
          OrdersTab(status: 'completed'),
          OrdersTab(status: 'cancelled'),
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

      final List<TransactionModel> items =
          orderController.transactionsByStatus[widget.status] ?? [];

      if (items.isEmpty) {
        return Center(child: Text('no_orders_found'.tr));
      }

      return Skeletonizer(
        enabled: orderController.isLoading,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: ListView.builder(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final tx = items[index];
              final imageList = <String>[];

              for (var item in tx.order?.orderItems ?? []) {
                final matchedVariant = item.product?.variants?.firstWhere(
                      (v) => v.id.toString() == item.variantId.toString(),
                  orElse: () => Variants(),
                );

                final imageUrl = matchedVariant.imageUrl;
                if (imageUrl != null && imageUrl.toLowerCase() != 'null') {
                  print("object image , ${matchedVariant.imageUrl}");
                  imageList.add(imageUrl);

                }
              }
              print("object image list , ${imageList.length}");
              return ItemSelectWidget(
                imageUrl: '',
                imageUrlList: imageList,
                onTap: () async {
                  goTo(this, OrderTransactionDetailScreen(data: tx.order ?? OrderModel(),));
                },
                title: tx.order?.paymentType ?? 'No Title',
                prices: '${tx.amount ?? '0.00'}',
                countNumber: tx.order?.orderItems?.length.toString() ?? '0', variantTitle: 'Billing ID : ${tx.order?.billingNumber}', discount: '',
              );
            },
          ),
        ),
      );
    });
  }
}
