import 'package:flutter/material.dart';
import 'package:silkeborgcano/standards/app_colors.dart';
import 'package:silkeborgcano/standards/app_sizes.dart';
import 'package:silkeborgcano/widgets/custom_icon_button.dart';
import 'package:silkeborgcano/widgets/custom_text_form_field.dart';

class EditableListTile extends StatefulWidget {
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onDelete;
  final VoidCallback? onLongPress;
  final VoidCallback? onTap;
  final ValueChanged<String>? onTapOutside;
  final bool showDelete;
  final bool showEdit;
  final bool isEditing;
  const EditableListTile({
    super.key,
    this.initialValue,
    this.onChanged,
    this.onDelete,
    this.onLongPress,
    this.onTap,
    this.onTapOutside,
    this.showDelete = true,
    this.showEdit = true,
    this.isEditing = false,
  });

  @override
  State<EditableListTile> createState() => _EditableListTileState();
}

class _EditableListTileState extends State<EditableListTile> {
  late final TextEditingController _controller;
  bool _isEditing = false;
  bool _valid = false;

  @override
  void initState() {
    super.initState();

    _isEditing = widget.isEditing;
    _controller = TextEditingController(text: widget.initialValue);

    _controller.addListener(() {
      setState(() {
        _valid = _controller.text.trim().isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    setState(() {
      _isEditing = false;
    });
    if (widget.onChanged != null) {
      widget.onChanged!(_controller.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: _isEditing
          ? CustomTextFormField(controller: _controller, onEditingComplete: _save, onTapOutside: widget.onTapOutside)
          : Text(
              _controller.text,
              style: TextStyle(fontSize: AppSizes.sm, color: AppColors.textAndIcon),
            ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedCrossFade(
            firstChild: _isEditing ? CustomIconButton(icon: Icons.save, onPressed: _valid ? _save : null) : SizedBox.shrink(),
            secondChild: Row(
              children: [
                if (widget.showEdit && !_isEditing)
                  CustomIconButton(
                    icon: Icons.edit,
                    onPressed: () async {
                      setState(() {
                        _isEditing = true;
                      });
                    },
                  ),
                if (widget.showDelete && !_isEditing) CustomIconButton(icon: Icons.delete, onPressed: widget.onDelete),
              ],
            ),
            crossFadeState: _isEditing ? CrossFadeState.showFirst : CrossFadeState.showSecond,
            duration: Duration(milliseconds: 300),
          ),
        ],
      ),

      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
    );
  }
}
