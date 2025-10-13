import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracklet_pro/src/shared_widgets/custom_button_widget.dart';

/// Dialog state for Download Report
class DownloadReportDialogModel extends ChangeNotifier {
  bool isDaily = true;
  DateTime selectedDate = DateTime.now();
  bool isLoading = false;
  bool _disposed = false;

  void toggle(bool daily) {
    if (isDaily == daily || _disposed) return;
    isDaily = daily;
    notifyListeners();
  }

  void setDate(DateTime date) {
    if (_disposed) return;
    selectedDate = date;
    notifyListeners();
  }

  void setLoading(bool loading) {
    if (_disposed) return;
    isLoading = loading;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}

/// Result returned from the dialog
class DownloadReportResult {
  final bool isDaily;
  final DateTime date;
  const DownloadReportResult({required this.isDaily, required this.date});
}

/// Public helper to show the dialog and get the result
Future<DownloadReportResult?> showDownloadReportDialog(BuildContext context) {
  return showDialog<DownloadReportResult>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) {
      return ChangeNotifierProvider(
        create: (_) => DownloadReportDialogModel(),
        child: const _DownloadReportDialog(),
      );
    },
  );
}

/// Helper function to safely handle PDF generation
Future<void> _handlePdfGeneration(
  BuildContext context,
  DownloadReportDialogModel model,
) async {
  // Store context references before async operations
  final navigator = Navigator.of(context);
  final scaffoldMessenger = ScaffoldMessenger.of(context);

  model.setLoading(true);

  try {
    // Simulate PDF generation
    await Future.delayed(const Duration(seconds: 2));

    // Show success message and close dialog
    if (context.mounted) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(
            'PDF report would be saved for ${_formatDate(model.selectedDate)}!\n(This is a simulation - no actual PDF generated)',
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 4),
        ),
      );

      // Close dialog with result
      navigator.pop(
        DownloadReportResult(isDaily: model.isDaily, date: model.selectedDate),
      );
    }
  } catch (e) {
    // Show error message
    if (context.mounted) {
      String errorMessage = e.toString();
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('Failed to generate PDF: $errorMessage'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    }
  } finally {
    if (context.mounted) {
      model.setLoading(false);
    }
  }
}

String _formatDate(DateTime date) {
  // e.g., 27-Sep-25
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  final dd = date.day.toString().padLeft(2, '0');
  final mmm = months[date.month - 1];
  final yy = (date.year % 100).toString().padLeft(2, '0');
  return '$dd-$mmm-$yy';
}

class _DownloadReportDialog extends StatelessWidget {
  const _DownloadReportDialog();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final model = context.watch<DownloadReportDialogModel>();

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Center(
              child: Text(
                'Download Report',
                style: theme.textTheme.titleMedium,
              ),
            ),
            const SizedBox(height: 8),
            // Subtitle
            Center(
              child: Text(
                'Select Date Range for Orders History',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: 16),

            // Toggle: Daily / Custom
            Row(
              children: [
                _PillToggle(
                  text: 'Daily',
                  isActive: model.isDaily,
                  onTap: () => model.toggle(true),
                  activeColor: scheme.primary,
                ),
                const SizedBox(width: 10),
                _PillToggle(
                  text: 'Custom',
                  isActive: !model.isDaily,
                  onTap: () => model.toggle(false),
                  activeColor: scheme.primary,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Date selector label
            Text('Select Date:', style: theme.textTheme.bodyMedium),
            const SizedBox(height: 8),

            // Date field (readOnly)
            GestureDetector(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: model.selectedDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2100),
                );
                if (picked != null) model.setDate(picked);
              },
              child: AbsorbPointer(
                child: TextField(
                  readOnly: true,
                  textDirection: TextDirection.ltr,
                  decoration: InputDecoration(
                    hintText: _formatDate(model.selectedDate),
                    hintStyle: theme.textTheme.bodyMedium,
                    filled: true,
                    fillColor: theme.colorScheme.surfaceContainer.withValues(
                      alpha: 0.2,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    suffixIcon: Icon(
                      Icons.arrow_drop_down_rounded,
                      color: theme.iconTheme.color,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: theme.dividerColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: scheme.primary, width: 1.5),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Actions: Cancel / Export Report
            Row(
              children: [
                Expanded(
                  child: CustomButtonWidget(
                    type: ButtonType.tab,
                    text: 'Cancel',
                    backgroundColor: Colors.transparent,
                    textColor: Theme.of(context).colorScheme.onSurface,
                    onPressed: () => Navigator.of(context).pop(null),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomButtonWidget(
                    type: ButtonType.full,
                    text: 'Export Report',
                    onPressed: () => _handlePdfGeneration(context, model),
                    isLoading: model.isLoading,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PillToggle extends StatelessWidget {
  final String text;
  final bool isActive;
  final VoidCallback onTap;
  final Color activeColor;
  const _PillToggle({
    required this.text,
    required this.isActive,
    required this.onTap,
    required this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            color: isActive ? activeColor : Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: isActive ? Colors.transparent : Colors.grey.shade300,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
