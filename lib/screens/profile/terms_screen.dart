import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/constants/colors.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppsColors.background,
      appBar: AppBar(
        title: const Text('Terms & Conditions', style: TextStyle(color: AppsColors.charcoal)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppsColors.charcoal),
          onPressed: () => context.pop(),
        ),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Text(
          '''
## Terms and Conditions for Recoza

**Last Updated:** 2024-07-25

Welcome to Recoza! These terms and conditions outline the rules and regulations for the use of Recoza's mobile application.

### 1. Acceptance of Terms

By accessing and using our app, you accept and agree to be bound by the terms and provision of this agreement. If you do not agree to abide by the above, please do not use this service.

### 2. User Roles

Our app provides two main roles: "Household" and "Collector." All users start as Households. You may apply to become a Collector, subject to our review and approval process.

### 3. User Conduct

Users are expected to conduct themselves in a respectful and lawful manner. Harassment, abuse, or any form of discriminatory behavior will not be tolerated and may result in account termination.

### 4. Recycling and Collections

- **Households:** You are responsible for accurately logging the types and amounts of recyclables you have available.
- **Collectors:** You agree to collect recyclables from your linked households in a timely and professional manner, according to the schedule you set.

### 5. Disclaimer

The service is provided "as is." Recoza does not guarantee any specific level of income for collectors or the availability of recyclables. We are a platform to facilitate connections, not a party to the direct transactions between users.

### 6. Limitation of Liability

In no event shall Recoza, nor its directors, employees, partners, agents, suppliers, or affiliates, be liable for any indirect, incidental, special, consequential or punitive damages, including without limitation, loss of profits, data, use, goodwill, or other intangible losses, resulting from your access to or use of or inability to access or use the service.

### 7. Changes to Terms

We reserve the right, at our sole discretion, to modify or replace these Terms at any time. We will provide notice of any changes by posting the new Terms and Conditions on this page.

### 8. Contact Us

If you have any questions about these Terms, please contact us at support@recoza.app.
          ''',
        ),
      ),
    );
  }
}
