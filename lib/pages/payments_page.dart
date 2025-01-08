import 'package:flutter/material.dart';
import 'recipe_instruction_page.dart';

class PaymentDetailPage extends StatefulWidget {
 final String recipeTitle;
  final String description;
  final String imageUrl;
  final String location;
  final String cookingTime;
  final String difficulty; 
  final String price;
  final List<String> mainIngredients; 
  final List<String> instructions;

  

  const PaymentDetailPage({
    required this.recipeTitle,
    required this.imageUrl,
    required this.price,
    required this.location,
    required this.cookingTime,
    required this.difficulty,
    required this.mainIngredients,
    required this.instructions,
    required this.description,
    Key? key,
  }) : super(key: key);

  @override
  _PaymentDetailPageState createState() => _PaymentDetailPageState();
}

class _PaymentDetailPageState extends State<PaymentDetailPage> {
  final _formKey = GlobalKey<FormState>();

  void _handlePayment() {
    if (_formKey.currentState!.validate()) {
      // Show success message
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Payment Success'),
          content: Text(
            'Your payment for "${widget.recipeTitle}" has been processed successfully.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Navigate to RecipeInstructionPage
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => RecipeInstructionPage(
                      recipeTitle: widget.recipeTitle,
                      location: widget.location,
                      difficulty: widget.difficulty,
                      cookingTime: widget.cookingTime,
                      imageUrl: widget.imageUrl,
                      mainIngredients: widget.mainIngredients,
                      instructions: widget.instructions, onAddToHistory: (String ) {  },
                    ),
                  ),
                );
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  resizeToAvoidBottomInset: true, // Pastikan ini diatur
  appBar: AppBar(
    title: const Text('Payment Details'),
  ),
  body: SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: RecipeSummary(
                imageUrl: widget.imageUrl,
                recipeTitle: widget.recipeTitle,
                price: widget.price,
              ),
            ),
            const SizedBox(height: 16),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextFormField(
                    labelText: 'Debit Card No.',
                    keyboardType: TextInputType.number,
                    validatorMessage: 'Please enter your card number',
                  ),
                  const SizedBox(height: 16),
                  CustomTextFormField(
                    labelText: 'Name on card',
                    validatorMessage: 'Please enter the name on card',
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextFormField(
                          labelText: 'Expiry',
                          keyboardType: TextInputType.datetime,
                          validatorMessage: 'Enter expiry date',
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: CustomTextFormField(
                          labelText: 'CVV/CVC',
                          keyboardType: TextInputType.number,
                          validatorMessage: 'Enter CVV/CVC',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _handlePayment,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        'Pay',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}

class RecipeSummary extends StatelessWidget {
  final String imageUrl;
  final String recipeTitle;
  final String price;

  const RecipeSummary({
    required this.imageUrl,
    required this.recipeTitle,
    required this.price,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          imageUrl,
          height: 150,
          fit: BoxFit.cover,
        ),
        const SizedBox(height: 8),
        Text(
          'Item: $recipeTitle',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          'Total: $price',
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}

class CustomTextFormField extends StatelessWidget {
  final String labelText;
  final TextInputType? keyboardType;
  final String validatorMessage;

  const CustomTextFormField({
    required this.labelText,
    required this.validatorMessage,
    this.keyboardType,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
      ),
      keyboardType: keyboardType,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return validatorMessage;
        }
        return null;
      },
    );
  }
}
