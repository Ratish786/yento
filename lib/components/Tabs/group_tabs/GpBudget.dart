import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GPBudget extends StatefulWidget {
  const GPBudget({super.key});

  @override
  State<GPBudget> createState() => _GPBudgetState();
}

// ----------------- Expense Model -----------------
class Expense {
  final String description;
  final String paidBy;
  final double amount;

  Expense(this.description, this.paidBy, this.amount);
}

class _GPBudgetState extends State<GPBudget> {
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  final List<Expense> expenses = [];
  double totalExpense = 0.0;

  @override
  void dispose() {
    descriptionController.dispose();
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Get.isDarkMode;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF1E293B)
          : const Color(0xFFF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                /// ===================== TOP CARDS =====================
                Row(
                  children: [
                    Expanded(
                      child: Card(
                        color: isDark ? const Color(0xFF334155) : Colors.white,
                        elevation: isDark ? 0 : 0.5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 13,
                            horizontal: 16,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Total Estimate',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: isDark
                                      ? Colors.grey[400]
                                      : Colors.grey[700],
                                ),
                              ),
                              Text(
                                '\$${totalExpense.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 28,
                                  color: isDark
                                      ? Colors.white
                                      : const Color(0xFF1F2937),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Card(
                        color: isDark ? const Color(0xFF334155) : Colors.white,
                        elevation: isDark ? 0 : 0.5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 13,
                            horizontal: 16,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(
                                Icons.money,
                                size: 36,
                                color: Color(0xFF16A34A),
                              ),
                              Text(
                                'AI Estimate',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Color(0xFF16A34A),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                /// ===================== ADD EXPENSE =====================
                Card(
                  color: isDark ? const Color(0xFF334155) : Colors.white,
                  elevation: isDark ? 0 : 0.5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Add Expense',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF1F2937),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: descriptionController,
                          style: TextStyle(
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF1F2937),
                          ),
                          decoration: _inputDecoration('Description', isDark),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: amountController,
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF1F2937),
                          ),
                          decoration: _inputDecoration('Amount', isDark),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (descriptionController.text.isEmpty ||
                                  amountController.text.isEmpty)
                                return;

                              final amount =
                                  double.tryParse(amountController.text) ?? 0;

                              setState(() {
                                final newExpense = Expense(
                                  descriptionController.text,
                                  'You',
                                  amount,
                                );
                                expenses.add(newExpense);
                                totalExpense += amount;
                              });

                              descriptionController.clear();
                              amountController.clear();
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 0,
                              backgroundColor: const Color(0xFF16A34A),
                            ),
                            child: const Text(
                              'ADD',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                /// ===================== EXPENSE LIST =====================
                Column(
                  children: expenses.map((expense) {
                    return _ExpenseListTile(
                      expense,
                      isDark: isDark,
                      onDelete: () {
                        setState(() {
                          expenses.remove(expense);
                          totalExpense -= expense.amount;
                        });
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, bool isDark) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: isDark ? Colors.grey[500] : Colors.grey[600]),
      filled: true,
      fillColor: isDark ? const Color(0xFF1E293B) : Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: isDark ? const Color(0xFF475569) : Colors.grey[400]!,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: isDark ? const Color(0xFF3B82F6) : const Color(0xFF16A34A),
          width: 2,
        ),
      ),
    );
  }
}

//-------------------Custom List tile----------------------------
Widget _ExpenseListTile(
  Expense expense, {
  required bool isDark,
  required VoidCallback onDelete,
}) {
  return Card(
    elevation: isDark ? 0 : 0.5,
    color: isDark ? const Color(0xFF334155) : Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: ListTile(
      title: Text(
        expense.description,
        style: TextStyle(
          color: isDark ? Colors.white : const Color(0xFF1F2937),
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        'Paid by ${expense.paidBy}',
        style: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[600]),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '\$${expense.amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: isDark ? Colors.white : const Color(0xFF1F2937),
            ),
          ),
          IconButton(
            onPressed: onDelete,
            icon: Icon(
              Icons.delete_outline,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
        ],
      ),
    ),
  );
}
