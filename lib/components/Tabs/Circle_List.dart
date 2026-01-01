import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../controller/circle_chat_controller.dart';

class CircleList extends StatefulWidget {
  final String circleName;
  
  const CircleList({super.key, required this.circleName});

  @override
  State<CircleList> createState() => _CircleListState();
}

class _CircleListState extends State<CircleList> {
  final CircleChatController controller = Get.find<CircleChatController>();
  final TextEditingController listController = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.circleId = widget.circleName;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        children: [
          // Add new list input
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 40,
                    child: TextField(
                      controller: listController,
                      decoration: InputDecoration(
                        hintText: 'New List Name',
                        hintStyle: const TextStyle(color: Colors.grey),
                        contentPadding: const EdgeInsets.only(left: 8),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: Colors.grey.shade400,
                            width: 0.8,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Colors.deepOrange,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: const Color(0xff3b82f6),
                  ),
                  child: IconButton(
                    onPressed: () async {
                      if (listController.text.isNotEmpty) {
                        controller.newListController.text = listController.text;
                        await controller.createList();
                        listController.clear();
                      }
                    },
                    icon: const Icon(Icons.add, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          
          // Lists stream
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: controller.getLists(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                      'No lists yet. Create your first list!',
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }
                
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final listDoc = snapshot.data!.docs[index];
                    final listData = listDoc.data() as Map<String, dynamic>;
                    
                    return CustomListWidget(
                      listId: listDoc.id,
                      listName: listData['title'],
                      controller: controller,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CustomListWidget extends StatefulWidget {
  final String listId;
  final String listName;
  final CircleChatController controller;

  const CustomListWidget({
    super.key,
    required this.listId,
    required this.listName,
    required this.controller,
  });

  @override
  State<CustomListWidget> createState() => _CustomListWidgetState();
}

class _CustomListWidgetState extends State<CustomListWidget> {
  final TextEditingController itemController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(width: 0.15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.listName,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      // Delete list functionality can be added later
                    },
                    icon: Icon(Icons.delete_outline, color: Colors.grey[400]),
                  ),
                ],
              ),

              // Items stream
              StreamBuilder<QuerySnapshot>(
                stream: widget.controller.getItems(widget.listId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox(height: 20, child: Center(child: CircularProgressIndicator()));
                  }
                  
                  if (!snapshot.hasData) {
                    return const SizedBox();
                  }
                  
                  return Column(
                    children: snapshot.data!.docs.map((itemDoc) {
                      final itemData = itemDoc.data() as Map<String, dynamic>;
                      final isDone = itemData['isDone'] ?? false;
                      
                      return Row(
                        children: [
                          Checkbox(
                            value: isDone,
                            onChanged: (value) {
                              widget.controller.toggleItem(
                                listId: widget.listId,
                                itemId: itemDoc.id,
                                currentValue: isDone,
                              );
                            },
                          ),
                          Expanded(
                            child: Text(
                              itemData['text'],
                              style: TextStyle(
                                decoration: isDone
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                                color: isDone ? Colors.grey : Colors.black,
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  );
                },
              ),

              // Add item input
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 30,
                      child: TextField(
                        controller: itemController,
                        decoration: InputDecoration(
                          hintText: 'Add item...',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide(
                              color: Colors.grey.shade400,
                              width: 0.8,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: const BorderSide(
                              color: Colors.deepOrange,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      if (itemController.text.isNotEmpty) {
                        await widget.controller.addItem(
                          listId: widget.listId,
                          text: itemController.text,
                        );
                        itemController.clear();
                      }
                    },
                    icon: const Icon(Icons.add, color: Color(0xff3b82f6)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}