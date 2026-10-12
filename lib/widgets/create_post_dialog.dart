import 'package:flutter/material.dart';
import '../data/posts_api.dart';

class CreatePostDialog extends StatefulWidget {
  const CreatePostDialog({super.key});
  @override
  State<CreatePostDialog> createState() => _CreatePostDialogState();
}
class _CreatePostDialogState extends State<CreatePostDialog> {
  final _form = GlobalKey<FormState>();
  final _title = TextEditingController(), _body = TextEditingController();
  bool _sending = false, _success = false;
  String? _result;
  @override
  void dispose() { _title.dispose(); _body.dispose(); super.dispose(); }
  Future<void> _send() async {
    if(!_form.currentState!.validate()) return;
    setState(() { _sending = true; _result = null; });
    try {
      final post = await const PostsApi().createPost(_title.text, _body.text);
      if(!mounted) return;
      setState(() { _success = true; _result = 'Post #${post['id']} created successfully! HTTP 201. Tap Done to see it in the list.'; });
    } catch(e) {
      if(mounted) setState(() => _result = e is ApiFailure ? e.message : 'Post failed. Check your connection and try again.');
    } finally {
      if(mounted) setState(() => _sending = false);
    }
  }
  String? _required(String? value) => value == null || value.trim().isEmpty ? 'This field cannot be empty.' : null;
  @override
  Widget build(BuildContext context) => PopScope(canPop: !_sending, child: AlertDialog(
    title: const Text('Create a post'),
    content: SizedBox(width: 420, child: SingleChildScrollView(child: Form(key: _form, child: Column(
      mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        if(!_success) ...[
          TextFormField(controller: _title, enabled: !_sending, validator: _required, maxLength: 150,
            decoration: const InputDecoration(labelText: 'Title')),
          const SizedBox(height: 12),
          TextFormField(controller: _body, enabled: !_sending, validator: _required, minLines: 3, maxLines: 6,
            maxLength: 3000, decoration: const InputDecoration(labelText: 'Body')),
        ],
        if(_sending) const LinearProgressIndicator(),
        if(_result != null) Padding(padding: const EdgeInsets.only(top: 12), child: Text(_result!,
          style: TextStyle(color: _success ? const Color(0xFFA6E3BB) : Theme.of(context).colorScheme.error))),
      ],
    )))),
    actions: [
      TextButton(onPressed: _sending ? null : () => Navigator.pop(context, _success), child: Text(_success ? 'Done' : 'Cancel')),
      if(!_success) ElevatedButton(onPressed: _sending ? null : _send, child: Text(_sending ? 'Sending...' : 'Send post')),
    ],
  ));
}
