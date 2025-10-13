import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracklet_pro/src/view/screens/gas_plant/settings/setting_screen/provider/manage_plant_provider.dart';
import 'package:tracklet_pro/src/widget/custom_svg_icon.dart';
import 'package:tracklet_pro/src/utils/app_icons.dart';
import 'package:tracklet_pro/src/shared_widgets/custom_button_widget.dart';

class ManagePlantScreen extends StatelessWidget {
  const ManagePlantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ManagePlantProvider(),
      child: const _ManagePlantView(),
    );
  }
}

class _ManagePlantView extends StatelessWidget {
  const _ManagePlantView();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ManagePlantProvider>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: CustomSvgIcon(
            assetName: AppIcons.svgArrowBack,
            width: 24,
            height: 24,
            color: Theme.of(context).colorScheme.onSurface,
            fallbackIcon: AppIcons.arrowBackIosNew,
          ),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text('Manage Plant', style: Theme.of(context).textTheme.titleLarge),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text('Plant Information', style: Theme.of(context).textTheme.displaySmall),
              const SizedBox(height: 16),

              Text('Plant Image:', style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => provider.pickImage(context),
                child: Container(
                  height: 140,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Theme.of(context).dividerColor, style: BorderStyle.solid, width: 1, strokeAlign: BorderSide.strokeAlignInside),
                  ),
                  child: const DottedBorderPlaceholder(),
                ),
              ),

              const SizedBox(height: 16),
              Text('Plant Name:', style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 6),
              TextField(
                controller: provider.plantNameController,
                textDirection: TextDirection.ltr,
                textAlign: TextAlign.start,
                decoration: const InputDecoration(hintText: 'Enter Plant Name'),
              ),

              const SizedBox(height: 12),
              Text('Contact Number:', style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 6),
              TextField(
                keyboardType: TextInputType.phone,
                controller: provider.contactController,
                textDirection: TextDirection.ltr,
                textAlign: TextAlign.start,
                decoration: const InputDecoration(hintText: '03xx xxxxxxx'),
              ),

              const SizedBox(height: 12),
              Text('Address', style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 6),
              TextField(
                controller: provider.addressController,
                textDirection: TextDirection.ltr,
                textAlign: TextAlign.start,
                decoration: const InputDecoration(hintText: 'Enter Address'),
                maxLines: 3,
              ),

              const SizedBox(height: 22),
              SizedBox(
                height: 48,
                width: double.infinity,
                child: CustomButtonWidget(
                  type: ButtonType.full,
                  text: 'Save Changes',
                  onPressed: () => provider.saveChanges(context),
                  isLoading: provider.isSaving,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DottedBorderPlaceholder extends StatelessWidget {
  const DottedBorderPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).dividerColor,
          width: 1,
          style: BorderStyle.solid,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomSvgIcon(
              assetName: 'lib/src/assets/svg/image.svg', // Placeholder - needs to be created
              width: 36,
              height: 36,
              color: scheme.primary,
              fallbackIcon: AppIcons.imageOutlined,
            ),
            const SizedBox(height: 8),
            Text('Upload Plant Image', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text(
              'Add a logo or image to help identify your plant easily.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7)),
            ),
          ],
        ),
      ),
    );
  }
}
