import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gemini/pages/upload_page.dart';
import 'package:gemini/pages/feedback.dart';
import 'package:gemini/pages/intro_screen.dart';
import 'package:gemini/components/constants.dart';



class ViewUploadsPage extends StatefulWidget {
  const ViewUploadsPage({super.key});

  @override
  _ViewUploadsPageState createState() => _ViewUploadsPageState();
}

class _ViewUploadsPageState extends State<ViewUploadsPage> {
  // final _usernameController = TextEditingController();
  // final _websiteController = TextEditingController();
  // String? _avatarUrl;
  final userId = supabase.auth.currentSession!.user.id;
  final Color mint = Color.fromARGB(255, 162, 228, 184);
  int len = -1;
  var _files_list = null;
  var _loading = true;

  /// Called once a user id is received within `onAuthenticated()`
  Future<void> _getStorageFiles() async {
    setState(() {
      _loading = true;
    });
      try {
        final userFiles = await supabase
          .storage
          .from('report_images')
          .list(path: userId);
        len = userFiles.length;
        _files_list = userFiles;
        // len = 2000;
      } catch (error) {
      SnackBar(
        content: const Text('Unexpected error occurred'),
        backgroundColor: Theme.of(context).colorScheme.error,
      );
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
    }

  @override
  void initState() {
    super.initState();
    _getStorageFiles();
    
    setState(() { 
          _loading = false;
        });
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mint,
        title: Row(
          children: [
            Image.asset('lib/images/medicode_logo.png', height: 40),
            const SizedBox(width: 10),
            Text(
              'Profile',
              style: TextStyle(color: Colors.black),
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.start,
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const IntroScreen()),
              );
            },
            icon: Icon(Icons.logout), // Use the logout icon
            color: Colors.black,
          ),
          const SizedBox(width: 10),
        ],
        elevation: 0,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        children: [
          // Avatar(
          //   imageUrl: _avatarUrl,
          //   onUpload: _onUpload,
          // ),
          const SizedBox(height: 18),
          Text(userId),
          Text(len.toString()),
          const SizedBox(height: 18),
          // TextButton(onPressed: _signOut, child: const Text('Sign Out')),
          
          navigationButtons(context)
        ],
      ),
    );
  }

  ButtonStyle buttonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: mint,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    );
  }

  Widget navigationButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ReportImage()));
            }
          },
          style: buttonStyle(),
          child: const Text("Back", style: TextStyle(color: Colors.black, fontSize: 16)),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const FeedbackPage()));
          },
          style: buttonStyle(),
          child: const Text("Next", style: TextStyle(color: Colors.black, fontSize: 16)),
        ),
      ],
    );
  }
}
