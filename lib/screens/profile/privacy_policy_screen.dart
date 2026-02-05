import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Privacy Policy',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
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
            
            _buildSection(
              title: '1. Introduction',
              content: 'Welcome to Recoza. We are committed to protecting your personal information and your right to privacy. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our mobile application.',
            ),
            
            _buildSection(
              title: '2. Information We Collect',
              content: 'We collect information that you provide directly to us, including:',
              children: [
                _buildBulletPoint('Account information (name, email, phone number)'),
                _buildBulletPoint('Location data (with your permission)'),
                _buildBulletPoint('Recycling activity data'),
                _buildBulletPoint('Collection schedules and history'),
                _buildBulletPoint('Communication preferences'),
              ],
            ),
            
            _buildSection(
              title: '3. How We Use Your Information',
              content: 'We use the information we collect to:',
              children: [
                _buildBulletPoint('Facilitate connections between Households and Collectors'),
                _buildBulletPoint('Calculate and display estimated earnings'),
                _buildBulletPoint('Send notifications about collection schedules'),
                _buildBulletPoint('Improve and optimize our app'),
                _buildBulletPoint('Ensure the safety and security of our platform'),
                _buildBulletPoint('Communicate with you about updates and features'),
              ],
            ),
            
            _buildSection(
              title: '4. Information Sharing',
              content: 'We may share your information in the following situations:',
              children: [
                _buildBulletPoint('With other users as necessary for the service (e.g., Collectors can see Household addresses for collection)'),
                _buildBulletPoint('With service providers who assist in our operations'),
                _buildBulletPoint('When required by law or to protect rights'),
                _buildBulletPoint('During business transfers (mergers or acquisitions)'),
              ],
            ),
            
            _buildSection(
              title: '5. Data Security',
              content: 'We implement appropriate technical and organizational security measures designed to protect the security of your personal information. However, please remember that no method of transmission over the Internet, or method of electronic storage is 100% secure.',
            ),
            
            _buildSection(
              title: '6. Your Privacy Rights',
              content: 'Depending on your location, you may have the right to:',
              children: [
                _buildBulletPoint('Access and receive a copy of your personal information'),
                _buildBulletPoint('Rectify inaccurate personal information'),
                _buildBulletPoint('Request deletion of your personal information'),
                _buildBulletPoint('Object to processing of your personal information'),
                _buildBulletPoint('Data portability'),
              ],
            ),
            
            _buildSection(
              title: '7. Location Data',
              content: 'We collect location data to:',
              children: [
                _buildBulletPoint('Help Collectors navigate to Households'),
                _buildBulletPoint('Verify service areas'),
                _buildBulletPoint('Improve service recommendations'),
              ],
            ),
            
            _buildSection(
              title: '8. Children\'s Privacy',
              content: 'Our Service does not address anyone under the age of 13. We do not knowingly collect personally identifiable information from children under 13.',
            ),
            
            _buildSection(
              title: '9. Changes to This Privacy Policy',
              content: 'We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page and updating the "Last Updated" date.',
            ),
            
            _buildSection(
              title: '10. Contact Us',
              content: 'If you have questions or concerns about this Privacy Policy, please contact us at:',
              children: [
                const SizedBox(height: 8),
                Text(
                  'Email: privacy@recoza.app\nAddress: Recoza Privacy Team, [Your Company Address]',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'By using Recoza, you acknowledge that you have read and understood this Privacy Policy.',
                style: TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String content,
    List<Widget>? children,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[800],
              height: 1.6,
            ),
          ),
          if (children != null) ...children,
        ],
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
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
                color: Colors.grey[800],
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}