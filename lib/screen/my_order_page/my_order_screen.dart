import 'package:e_commerce_tech/widgets/item_select_widget.dart';
import 'package:e_commerce_tech/widgets/list_view_custom_widget.dart';
import 'package:flutter/material.dart';

class MyOrderScreen extends StatefulWidget {
  const MyOrderScreen({super.key});

  @override
  State<MyOrderScreen> createState() => _MyOrderScreenState();
}

class _MyOrderScreenState extends State<MyOrderScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
            Tab(text: "Active"),
            Tab(text: "Complete"),
            Tab(text: "Cancel"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          Padding(
            padding: EdgeInsets.all(12.0),
            child: ActiveOrders(),
          ),
          Padding(
            padding: EdgeInsets.all(12.0),
            child: CompleteOrders(),
          ),
          Padding(
            padding: EdgeInsets.all(12.0),
            child: CancelOrders(),
          ),
        ],
      ),
    );
  }
}

class ActiveOrders extends StatelessWidget {
  const ActiveOrders({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ListViewCustomWidget(items: [
        ItemSelectWidget(
          imageUrl: 'https://i.pinimg.com/736x/43/61/09/4361091dd491bacbbcdbaa0be7a2d2be.jpg',
          title: 'Tech Gadget',
          prices: '\$199.99',
          countNumber: 4.toString(), // Passing the callback
        ),
        ItemSelectWidget(
          imageUrl: 'https://i.pinimg.com/736x/43/61/09/4361091dd491bacbbcdbaa0be7a2d2be.jpg',
          title: 'Tech Gadget',
          prices: '\$199.99',
          countNumber: 4.toString(), // Passing the callback
        ),
        ItemSelectWidget(
          imageUrl: 'https://i.pinimg.com/736x/43/61/09/4361091dd491bacbbcdbaa0be7a2d2be.jpg',
          title: 'Tech Gadget',
          prices: '\$199.99',
          countNumber: 4.toString(), // Passing the callback
        ),
        ItemSelectWidget(
          imageUrl: 'https://i.pinimg.com/736x/43/61/09/4361091dd491bacbbcdbaa0be7a2d2be.jpg',
          title: 'Tech Gadget',
          prices: '\$199.99',
          countNumber: 4.toString(), // Passing the callback
        ),
        ItemSelectWidget(
          imageUrl: 'https://i.pinimg.com/736x/43/61/09/4361091dd491bacbbcdbaa0be7a2d2be.jpg',
          title: 'Tech Gadget',
          prices: '\$199.99',
          countNumber: 4.toString(), // Passing the callback
        ),
        ItemSelectWidget(
          imageUrl: 'https://i.pinimg.com/736x/43/61/09/4361091dd491bacbbcdbaa0be7a2d2be.jpg',
          title: 'Tech Gadget',
          prices: '\$199.99',
          countNumber: 4.toString(), // Passing the callback
        ),
        ItemSelectWidget(
          imageUrl: 'https://i.pinimg.com/736x/43/61/09/4361091dd491bacbbcdbaa0be7a2d2be.jpg',
          title: 'Tech Gadget',
          prices: '\$199.99',
          countNumber: 4.toString(), // Passing the callback
        ),
        ItemSelectWidget(
          imageUrl: 'https://i.pinimg.com/736x/43/61/09/4361091dd491bacbbcdbaa0be7a2d2be.jpg',
          title: 'Tech Gadget',
          prices: '\$199.99',
          countNumber: 4.toString(), // Passing the callback
        ),
        ItemSelectWidget(
          imageUrl: 'https://i.pinimg.com/736x/43/61/09/4361091dd491bacbbcdbaa0be7a2d2be.jpg',
          title: 'Tech Gadget',
          prices: '\$199.99',
          countNumber: 4.toString(), // Passing the callback
        ),

      ]),
    );
  }
}

class CompleteOrders extends StatelessWidget {
  const CompleteOrders({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: ListViewCustomWidget(items: [
          ItemSelectWidget(
            imageUrl: 'https://i.pinimg.com/736x/43/61/09/4361091dd491bacbbcdbaa0be7a2d2be.jpg',
            title: 'Tech Gadget',
            prices: '\$199.99',
            countNumber: 4.toString(), // Passing the callback
          ),
          ItemSelectWidget(
            imageUrl: 'https://i.pinimg.com/736x/43/61/09/4361091dd491bacbbcdbaa0be7a2d2be.jpg',
            title: 'Tech Gadget',
            prices: '\$199.99',
            countNumber: 4.toString(), // Passing the callback
          ),
          ItemSelectWidget(
            imageUrl: 'https://i.pinimg.com/736x/43/61/09/4361091dd491bacbbcdbaa0be7a2d2be.jpg',
            title: 'Tech Gadget',
            prices: '\$199.99',
            countNumber: 4.toString(), // Passing the callback
          ),
          ItemSelectWidget(
            imageUrl: 'https://i.pinimg.com/736x/43/61/09/4361091dd491bacbbcdbaa0be7a2d2be.jpg',
            title: 'Tech Gadget',
            prices: '\$199.99',
            countNumber: 4.toString(), // Passing the callback
          ),
          ItemSelectWidget(
            imageUrl: 'https://i.pinimg.com/736x/43/61/09/4361091dd491bacbbcdbaa0be7a2d2be.jpg',
            title: 'Tech Gadget',
            prices: '\$199.99',
            countNumber: 4.toString(), // Passing the callback
          ),
          ItemSelectWidget(
            imageUrl: 'https://i.pinimg.com/736x/43/61/09/4361091dd491bacbbcdbaa0be7a2d2be.jpg',
            title: 'Tech Gadget',
            prices: '\$199.99',
            countNumber: 4.toString(), // Passing the callback
          ),
          ItemSelectWidget(
            imageUrl: 'https://i.pinimg.com/736x/43/61/09/4361091dd491bacbbcdbaa0be7a2d2be.jpg',
            title: 'Tech Gadget',
            prices: '\$199.99',
            countNumber: 4.toString(), // Passing the callback
          ),
          ItemSelectWidget(
            imageUrl: 'https://i.pinimg.com/736x/43/61/09/4361091dd491bacbbcdbaa0be7a2d2be.jpg',
            title: 'Tech Gadget',
            prices: '\$199.99',
            countNumber: 4.toString(), // Passing the callback
          ),
          ItemSelectWidget(
            imageUrl: 'https://i.pinimg.com/736x/43/61/09/4361091dd491bacbbcdbaa0be7a2d2be.jpg',
            title: 'Tech Gadget',
            prices: '\$199.99',
            countNumber: 4.toString(), // Passing the callback
          ),

        ]),
      )
    );
  }
}

class CancelOrders extends StatelessWidget {
  const CancelOrders({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: ListViewCustomWidget(items: [
          ItemSelectWidget(
            imageUrl: 'https://i.pinimg.com/736x/43/61/09/4361091dd491bacbbcdbaa0be7a2d2be.jpg',
            title: 'Tech Gadget',
            prices: '\$199.99',
            countNumber: 4.toString(), // Passing the callback
          ),
          ItemSelectWidget(
            imageUrl: 'https://i.pinimg.com/736x/43/61/09/4361091dd491bacbbcdbaa0be7a2d2be.jpg',
            title: 'Tech Gadget',
            prices: '\$199.99',
            countNumber: 4.toString(), // Passing the callback
          ),
          ItemSelectWidget(
            imageUrl: 'https://i.pinimg.com/736x/43/61/09/4361091dd491bacbbcdbaa0be7a2d2be.jpg',
            title: 'Tech Gadget',
            prices: '\$199.99',
            countNumber: 4.toString(), // Passing the callback
          ),
          ItemSelectWidget(
            imageUrl: 'https://i.pinimg.com/736x/43/61/09/4361091dd491bacbbcdbaa0be7a2d2be.jpg',
            title: 'Tech Gadget',
            prices: '\$199.99',
            countNumber: 4.toString(), // Passing the callback
          ),
          ItemSelectWidget(
            imageUrl: 'https://i.pinimg.com/736x/43/61/09/4361091dd491bacbbcdbaa0be7a2d2be.jpg',
            title: 'Tech Gadget',
            prices: '\$199.99',
            countNumber: 4.toString(), // Passing the callback
          ),
          ItemSelectWidget(
            imageUrl: 'https://i.pinimg.com/736x/43/61/09/4361091dd491bacbbcdbaa0be7a2d2be.jpg',
            title: 'Tech Gadget',
            prices: '\$199.99',
            countNumber: 4.toString(), // Passing the callback
          ),
          ItemSelectWidget(
            imageUrl: 'https://i.pinimg.com/736x/43/61/09/4361091dd491bacbbcdbaa0be7a2d2be.jpg',
            title: 'Tech Gadget',
            prices: '\$199.99',
            countNumber: 4.toString(), // Passing the callback
          ),
          ItemSelectWidget(
            imageUrl: 'https://i.pinimg.com/736x/43/61/09/4361091dd491bacbbcdbaa0be7a2d2be.jpg',
            title: 'Tech Gadget',
            prices: '\$199.99',
            countNumber: 4.toString(), // Passing the callback
          ),
          ItemSelectWidget(
            imageUrl: 'https://i.pinimg.com/736x/43/61/09/4361091dd491bacbbcdbaa0be7a2d2be.jpg',
            title: 'Tech Gadget',
            prices: '\$199.99',
            countNumber: 4.toString(), // Passing the callback
          ),

        ]),
      )
    );
  }
}
