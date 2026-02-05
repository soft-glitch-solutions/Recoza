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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Terms and Conditions for Recoza',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppsColors.charcoal,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Last Updated: ${DateTime.now().toString().split(' ')[0]}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            
            _buildTermSection(
              number: '1',
              title: 'Acceptance of Terms',
              content: 'By accessing and using the Recoza mobile application, you accept and agree to be bound by these Terms and Conditions. If you do not agree with any part of these terms, you must not use our service.',
            ),
            
            _buildTermSection(
              number: '2',
              title: 'Definitions',
              content: 'For the purpose of these Terms:',
              children: [
                _buildDefinition('App', 'The Recoza mobile application'),
                _buildDefinition('Household', 'A user who logs recyclables for collection'),
                _buildDefinition('Collector', 'A user who collects recyclables from Households'),
                _buildDefinition('Network', 'The trusted connections between Collectors and Households'),
                _buildDefinition('Service', 'All features and functionality provided by Recoza'),
              ],
            ),
            
            _buildTermSection(
              number: '3',
              title: 'User Accounts',
              content: 'To use Recoza, you must:',
              children: [
                _buildBullet('Be at least 18 years old or have parental consent'),
                _buildBullet('Provide accurate and complete information'),
                _buildBullet('Maintain the security of your account credentials'),
                _buildBullet('Notify us immediately of any unauthorized access'),
              ],
            ),
            
            _buildTermSection(
              number: '4',
              title: 'User Roles and Responsibilities',
              content: '',
              children: [
                const SizedBox(height: 8),
                const Text(
                  '4.1 Household Responsibilities:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                _buildBullet('Accurately log types and quantities of recyclables'),
                _buildBullet('Prepare recyclables for scheduled collection times'),
                _buildBullet('Maintain a safe collection environment'),
                _buildBullet('Notify your Collector of any changes or cancellations'),
                
                const SizedBox(height: 16),
                const Text(
                  '4.2 Collector Responsibilities:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                _buildBullet('Collect recyclables as scheduled or reschedule in advance'),
                _buildBullet('Treat all households with respect and professionalism'),
                _buildBullet('Maintain accurate records of collections'),
                _buildBullet('Follow all applicable local recycling regulations'),
                _buildBullet('Ensure safe transportation of collected materials'),
              ],
            ),
            
            _buildTermSection(
              number: '5',
              title: 'Earnings and Payments',
              content: 'Recoza provides estimated earnings calculations based on:',
              children: [
                _buildBullet('Average market prices for recyclable materials'),
                _buildBullet('Estimated weights based on user input'),
                _buildBullet('Historical collection data'),
                const SizedBox(height: 8),
                const Text(
                  'Actual earnings may vary based on market conditions, actual weights, and other factors. Recoza is not responsible for any discrepancies between estimated and actual earnings.',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ],
            ),
            
            _buildTermSection(
              number: '6',
              title: 'Trust Network System',
              content: 'Recoza operates on a trust-based network:',
              children: [
                _buildBullet('Collectors build networks with people they already know'),
                _buildBullet('Households join via invitation links from known Collectors'),
                _buildBullet('Users can switch Collectors at any time'),
                _buildBullet('Both parties are responsible for maintaining respectful relationships'),
              ],
            ),
            
            _buildTermSection(
              number: '7',
              title: 'Prohibited Activities',
              content: 'You agree not to:',
              children: [
                _buildBullet('Use the service for any illegal purpose'),
                _buildBullet('Harass, threaten, or intimidate other users'),
                _buildBullet('Share false or misleading information'),
                _buildBullet('Attempt to gain unauthorized access to the service'),
                _buildBullet('Impersonate another person or entity'),
                _buildBullet('Use automated systems to interact with the service'),
              ],
            ),
            
            _buildTermSection(
              number: '8',
              title: 'Intellectual Property',
              content: 'The Recoza app, including its design, features, and content, is protected by copyright, trademark, and other laws. You may not copy, modify, distribute, or create derivative works without our express permission.',
            ),
            
            _buildTermSection(
              number: '9',
              title: 'Disclaimer of Warranties',
              content: 'THE SERVICE IS PROVIDED "AS IS" AND "AS AVAILABLE" WITHOUT WARRANTIES OF ANY KIND, EITHER EXPRESS OR IMPLIED. RECOZA DOES NOT GUARANTEE THAT THE SERVICE WILL BE UNINTERRUPTED, SECURE, OR ERROR-FREE.',
            ),
            
            _buildTermSection(
              number: '10',
              title: 'Limitation of Liability',
              content: 'TO THE MAXIMUM EXTENT PERMITTED BY LAW, RECOZA SHALL NOT BE LIABLE FOR ANY INDIRECT, INCIDENTAL, SPECIAL, CONSEQUENTIAL, OR PUNITIVE DAMAGES, INCLUDING LOST PROFITS, LOST DATA, OR BUSINESS INTERRUPTION.',
            ),
            
            _buildTermSection(
              number: '11',
              title: 'Termination',
              content: 'We may suspend or terminate your account if you violate these Terms. You may terminate your account at any time by contacting us or through the app settings.',
            ),
            
            _buildTermSection(
              number: '12',
              title: 'Changes to Terms',
              content: 'We reserve the right to modify these Terms at any time. We will provide notice of significant changes through the app or via email. Continued use of the service after changes constitutes acceptance.',
            ),
            
            _buildTermSection(
              number: '13',
              title: 'Governing Law',
              content: 'These Terms shall be governed by and construed in accordance with the laws of South Africa, without regard to its conflict of law provisions.',
            ),
            
            _buildTermSection(
              number: '14',
              title: 'Dispute Resolution',
              content: 'Any disputes arising from these Terms will first be attempted to be resolved through good faith negotiations. If unresolved, disputes may be submitted to mediation.',
            ),
            
            _buildTermSection(
              number: '15',
              title: 'Contact Information',
              content: 'For questions about these Terms, please contact us at:',
              children: [
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Recoza Support',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Text('Email: support@recoza.app'),
                      SizedBox(height: 4),
                      Text('Website: www.recoza.app'),
                      SizedBox(height: 4),
                      Text('Address: [Company Address, City, Country]'),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppsColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppsColors.primary.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  const Icon(Icons.gavel_rounded, size: 40, color: AppsColors.primary),
                  const SizedBox(height: 12),
                  const Text(
                    'By using Recoza, you acknowledge that you have read, understood, and agree to be bound by these Terms and Conditions.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppsColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    ),
                    child: const Text('I Understand'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildTermSection({
    required String number,
    required String title,
    required String content,
    List<Widget>? children,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppsColors.primary,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    number,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppsColors.charcoal,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (content.isNotEmpty)
            Text(
              content,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
                height: 1.6,
              ),
            ),
          if (children != null) ...children,
        ],
      ),
    );
  }

  Widget _buildBullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 16)),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefinition(String term, String definition) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 4),
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[700],
            height: 1.6,
          ),
          children: [
            TextSpan(
              text: '$term: ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: definition),
          ],
        ),
      ),
    );
  }
}